//
//  MomentInfo.swift
//  Momentrack
//
//  Created by Nat Kim on 7/22/24.
//

import Foundation

struct MomentInfo: Hashable, Identifiable, Codable {
    var id: String = UUID().uuidString
    var friend: String
    var location: String
    var photo: String
    var text: String
}
