//
//  PostingMomentViewController+Row.swift
//  Momentrack
//
//  Created by Nat Kim on 7/20/24.
//

import UIKit

extension PostingMomentViewController {
    enum Row: Hashable {
        case withFriend(String)
        case currentLocation
        case photoImage
        case text
    }
}
