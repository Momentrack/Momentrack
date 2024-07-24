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
    var nickname: String
    var friends: [String]
    var createdAt: String
    var activite: Bool
    
    var toDictionary: [String: Any] {
        let user: [String: Any] = ["id": id, "email": email, "nickname": nickname, "friends": friends, "createdAt": createdAt, "activite": activite]
        return user
    }
}
