//
//  Network.swift
//  Momentrack
//
//  Created by heyji on 2024/07/23.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

final class Network {
    
    static let shared = Network()
    
    // MARK: 인증
    private let firebaseAuth = Auth.auth()
    
    // MARK: 실시간 데이터베이스
    private var ref: DatabaseReference! = Database.database().reference()
    
    // MARK: 저장소
    private let storage = FirebaseStorage.Storage.storage().reference()
    
    private init() { }
    
    // MARK: 신규 사용자가 이메일 인증 링크 전송
    func createNewUser(email: String, completion: @escaping (String) -> Void) {
        let actionCodeSettings = ActionCodeSettings()
        actionCodeSettings.url = URL(string: "https://momentrack-8ab67.firebaseapp.com/?email=\(email)")
        actionCodeSettings.handleCodeInApp = true
        actionCodeSettings.setIOSBundleID(Bundle.main.bundleIdentifier!)
        
        Auth.auth().sendSignInLink(toEmail: email, actionCodeSettings: actionCodeSettings) { error in
            if let error = error {
                completion("email not sent \(error.localizedDescription)")
            } else {
                completion("email sent")
            }
        }
    }
    
    // MARK: 신규 사용자가 로그인
    func signInApp(email: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let link = UserDefaults.standard.string(forKey: "Link") else { return }
        
        Auth.auth().signIn(withEmail: email, link: link) { result, error in
            if let error = error {
                print("✉️ email auth error \"\(error.localizedDescription)\"")
                completion(.failure(error))
                return
            }
            
            // NOTE: 사용자 uid UserDefault에 임시 저장 및 데이터베이스에 유저 생성
            guard let uid = result?.user.uid else { return }
            UserDefaults.standard.setValue(uid, forKey: "userId")
            
            // MARK: 기존 유저와 신규 유저 구분
            self.getUsersInfo { snapshot in
                var count = snapshot.values.count
                for i in snapshot.values {
                    count -= 1
                    guard let userInfo = i as? [String: String] else { return }
                    if userInfo["email"] == email {
                        // 기존 유저이므로 사용자 생성하지 않음
                        completion(.success("로그인 성공"))
                    }
                }
                if count == 0 {
                    // 기존 유저가 아니므로 사용자 생성
                    Network.shared.createUserInfo(email: email)
                    completion(.success("로그인 성공"))
                }
            }
        }
    }
    
    // MARK: 사용자 재인증
    func reauthenricateUser(completion: @escaping (String) -> Void) {
        guard let link = UserDefaults.standard.string(forKey: "Link") else { return }
        guard let userID = UserDefaults.standard.string(forKey: "userId") else { return }
        self.getUserInfo { user in
            let email = user.email
            var credential: AuthCredential
            credential = EmailAuthProvider.credential(withEmail: email, link: link)
            
            self.firebaseAuth.currentUser?.reauthenticate(with: credential, completion: { result, error in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                if let email = result?.user.email {
                    print("재인증이 완료되었습니다.")
                    completion(email)
                } else {
                    print("재인증에 실패하였습니다.")
                    return
                }
            })
        }
    }
    
    // MARK: 로그아웃
    func signOut() {
        do {
            try firebaseAuth.signOut()
            UserDefaults.standard.removeObject(forKey: "userId")
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    // MARK: 사용자 계정 삭제하기 (탈퇴하기)
    // NOTE: 사용자 계정 삭제 시 유저 Info와 친구 리스트에도 삭제
    func deleteAccount() {
        // NOTE: 최근 로그인(로그인 후 5분)이 지나면 사용자 재인증 필요
        self.reauthenricateUser() { _ in
            self.firebaseAuth.currentUser?.delete(completion: { error in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    // NOTE: 및 UserDefaults에 저장된 uid 삭제
                    UserDefaults.standard.removeObject(forKey: "userId")
                }
            })
        }
    }
    
    // MARK: [Create] 데이터 쓰기
    // 사용자 생성
    func createUserInfo(email: String) {
        guard let userID = UserDefaults.standard.string(forKey: "userId") else { return }
        let nickname = email.components(separatedBy: "@")[0]
        let user = User(email: email, nickname: nickname, friends: [email], createdAt: Date().stringFormat, activite: true)
        self.ref.child("users").child(userID).child("userInfo").setValue(user.toDictionary)
        // 사용자 리스트에 사용자정보 추가
        self.addUserInfo(userID: userID, user: user)
    }

    // MARK: - 원래 createMoment 메소드 코드
    
    func createMoment(location: String, photoUrl: String, memo: String, sharedFriends: [String], latitude: Double, longitude: Double) {
        guard let userID = UserDefaults.standard.string(forKey: "userId") else { return }
        self.getUserInfo { user in
            var friends = sharedFriends
            friends.append(user.email)
            let moment = Moment(location: location, photoUrl: photoUrl, memo: memo, sharedFriends: friends, createdAt: Date().stringFormat, time: Date().timeStringFormat, latitude: latitude, longitude: longitude
//                            , date: Date().yearMonthDayStringFormat
            )
            self.ref.child("users").child(userID).child("moment").child(Date().todayStringFormat).child(moment.id).setValue(moment.toDictionary)
            if sharedFriends.count > 0 {
                // NOTE: 8월 3일 현재 친구는 한명만 선택 가능
                for i in 0..<sharedFriends.count {
                    self.getUsersInfo { snapshot in
                        for userInfo in snapshot.values {
                            guard let userInfo = userInfo as? [String: String] else { return }
                            if userInfo["email"] == sharedFriends[i] {
                                let friendId = userInfo["uid"]!
                                self.createMomentAtFriend(friendId: friendId, moment: moment)
                            }
                        }
                    }
                }
            }
        }
    }
    
    // 친구와 공유 시
    func createMomentAtFriend(friendId: String, moment: Moment) {
        self.ref.child("users").child(friendId).child("moment").child(Date().todayStringFormat).child(moment.id).setValue(moment.toDictionary)
    }
    
    
    // MARK: [Read] 데이터 읽기
    // 사용자 정보 가져오기
    func getUserInfo(completion: @escaping (User) -> Void) {
        guard let userID = UserDefaults.standard.string(forKey: "userId") else { return }
        ref.child("users").child(userID).child("userInfo").getData { error, snapshot in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            guard let snapshot else { return }
            if snapshot.exists() {
                guard let snapshot = snapshot.value as? [String: Any] else { return }
                do {
                    let data = try JSONSerialization.data(withJSONObject: snapshot, options: [])
                    let decoder = JSONDecoder()
                    let userInfo: User = try decoder.decode(User.self, from: data)
                    completion(userInfo)
                    
                } catch let error {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    // 모든 사용자 이메일 가져오기
    func getUsersInfo(completion: @escaping ([String: Any]) -> Void) {
        ref.child("usersInfo").getData { error, snapshot in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            guard let snapshot else { return }
            if snapshot.exists() {
                guard let snapshot = snapshot.value as? [String: Any] else { return }
                completion(snapshot)
            }
        }
    }
    
    // moments 가져오기
    func getMoments(completion: @escaping ([Moment]) -> Void) {
        guard let uid = UserDefaults.standard.string(forKey: "userId") else { return }
        ref.child("users").child(uid).child("moment").getData { error, snapshot in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            guard let snapshot else { return }
            var momentList: [Moment] = []
            if snapshot.exists() {
                guard let snapshot = snapshot.value as? [String: Any] else { return }
                do {
                    if snapshot.keys.contains(Date().todayStringFormat) {
                        for (key, value) in snapshot {
                            if key == Date().todayStringFormat {
                                guard let momentArray = value as? [String: Any] else { return }
                                for (_, value) in momentArray {
                                    let data = try JSONSerialization.data(withJSONObject: value, options: [])
                                    let decoder = JSONDecoder()
                                    let moment: Moment = try decoder.decode(Moment.self, from: data)
                                    momentList.append(moment)
                                }
                            }
                        }
                        // NOTE: 생성된 날짜순으로 정렬
                        let sortedMomentList = momentList.sorted { $0.time < $1.time }
                        completion(sortedMomentList)
                    }
                } catch let error {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func getMomentList(completion: @escaping ([AllOfMoment]) -> Void) {
        guard let uid = UserDefaults.standard.string(forKey: "userId") else { return }
        ref.child("users").child(uid).child("moment").getData { error, snapshot in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            guard let snapshot else { return }
            var allOfmoment: [AllOfMoment] = []
            if snapshot.exists() {
                guard let snapshot = snapshot.value as? [String: Any] else { return }
                do {
                    for (key, value) in snapshot {
                        guard let momentArray = value as? [String: Any] else { return }
                        var momentList: [Moment] = []
                        for (_, value) in momentArray {
                            let data = try JSONSerialization.data(withJSONObject: value, options: [])
                            let decoder = JSONDecoder()
                            let moment: Moment = try decoder.decode(Moment.self, from: data)
                            momentList.append(moment)
                        }
                        let sortedMomentList = momentList.sorted { $0.time < $1.time }
                        let todaysMoment = AllOfMoment(date: key, moment: sortedMomentList)
                        allOfmoment.append(todaysMoment)
                    }
                    let sortedAllofMoment = allOfmoment.sorted { $0.date < $1.date }
                    completion(sortedAllofMoment)
        
                } catch let error {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    // MARK: [Update] 데이터 업데이트
    // 닉네임 수정
    func updateNickname(nickname: String) {
        guard let userID = UserDefaults.standard.string(forKey: "userId") else { return }
        self.ref.child("users").child(userID).child("userInfo").updateChildValues(["nickname": nickname])
        // 사용자 리스트의 닉네임도 수정
        self.ref.child("usersInfo").observeSingleEvent(of: .value) { snapshot in
            guard let snapshot = snapshot.value as? [String: Any] else { return }
            for i in snapshot.keys {
                if userID == i {
                    self.ref.child("usersInfo").child(userID).updateChildValues(["nickname": nickname])
                }
            }
        }
    }
    
    // 친구 추가
    func addFriend(email: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let userID = UserDefaults.standard.string(forKey: "userId") else { return }
        self.ref.child("users").child(userID).child("userInfo").child("friends").observeSingleEvent(of: .value) { snapshot in
            var count = "0"
            if let values = snapshot.value as? [String] {
                count = String(describing: values.count)
            }
            var newFriend = [String: String]()
            newFriend[count] = email
            self.ref.child("users").child(userID).child("userInfo").child("friends").updateChildValues(newFriend)
            completion(.success("친구 추가 성공"))
        }
    }
    
    // 사용자의 정보 따로 저장
    func addUserInfo(userID: String, user: User) {
        self.ref.child("usersInfo").observeSingleEvent(of: .value) { snapshot in
            let userInfo: [String: String] = ["uid": userID, "email": user.email, "nickname": user.nickname]
            self.ref.child("usersInfo").child(userID).updateChildValues(userInfo)
        }
    }
    
    // MARK: [Delete] 데이터 삭제
    // 사용자 삭제
    func deleteUserInfo() {
        guard let uid = UserDefaults.standard.string(forKey: "userId") else { return }
        // 1. 스토리지에 저장되어 있는 사진 데이터 삭제
        // 2. 사용자 정보 데이터 삭제
        self.ref.child("users").child(uid).removeValue()
        // 3. 사용자 재인증 후 사용자 삭제
//        self.deleteAccount(email: <#String#>)
    }
    
    // Moment 삭제
    func deleteMomentData(momentId: String) {
        guard let userID = UserDefaults.standard.string(forKey: "userId") else { return }
        self.ref.child("users").child(userID).child("moment").child(Date().todayStringFormat).child(momentId).removeValue()
//        deleteImageAndData(storageName: momentId)
    }
    
    // MARK: 이미지 업로드
    func imageUpload(storageName: String, id: String, imageData: Data, completion: @escaping (String) -> Void) {
        guard let uid = UserDefaults.standard.string(forKey: "userId") else { return }
        let imageRef = self.storage.child(uid).child(storageName)
        let imageName = "\(id).jpg"
        let imagefileRef = imageRef.child(imageName)
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        imagefileRef.putData(imageData, metadata: metadata) { metadata, error in
            if let error = error {
                print("이미지 올리기 실패! \(error)")
            } else {
                imagefileRef.downloadURL { url, error in
                    if let error = error {
                        print("이미지 다운로드 실패! \(error)")
                    } else {
                        guard let url = url else { return }
                        completion("\(url)")
                    }
                }
            }
        }
    }
    
    private func deleteImageAndData(storageName: String) {
        guard let uid = UserDefaults.standard.string(forKey: "userId") else { return }
        let imageRef = self.storage.child(uid).child(storageName)
        
        // 이미지가 있을 경우 삭제
        imageRef.listAll(completion: { result, error in
            if let error = error {
                print(error)
            }
            guard let result = result else { return }
            if result.items.count > 0 {
                imageRef.delete { error in
                    if let error = error {
                        print(error.localizedDescription)
                    }
                }
            }
        })
    }
}


