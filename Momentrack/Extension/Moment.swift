//
//  Moment.swift
//  Momentrack
//
//  Created by heyji on 2024/07/23.
//

import Foundation

struct Moment: Codable {
    var id: String = UUID().uuidString
    var location: String
    var photoUrl: String
    var memo: String
    var sharedFriends: [String]
    var createdAt: String
    
    var toDictionary: [String: Any] {
        let moment: [String: Any] = ["id": id, "location": location, "photoUrl": photoUrl, "memo": memo, "sharedFriends": sharedFriends, "created": createdAt]
        return moment
    }
}
