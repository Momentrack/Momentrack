//
//  User.swift
//  Momentrack
//
//  Created by heyji on 2024/07/23.
//

import Foundation

struct User: Codable {
    var id: String = UUID().uuidString
    var email: String
    var password: String
    var nickname: String
    var friends: [String]
    var createdAt: String
    var activite: Bool
    
    var toDictionary: [String: Any] {
        let user: [String: Any] = ["id": id, "email": email, "password": password, "nickname": nickname, "friends": friends, "createdAt": createdAt, "activite": activite]
        return user
    }
    
    // 아이디 형식 검사
    static func isValidEmail(id: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: id)
    }
    
    // 비밀번호 형식 검사
    static func isValidPassword(pwd: String) -> Bool {
        //let passwordRegEx = "^(?=.*[a-z])(?=.*\\d)(?=.*[$@$!%*?&])[A-Za-z\\d$@$!%*?&]{6,8}"
        let passwordRegEx = "^(?=.*[a-z])(?=.*\\d)[a-z\\d]{6,8}$"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
        return passwordTest.evaluate(with: pwd)
    }
}
