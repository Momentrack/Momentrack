//
//  PostingMomentViewController+Section.swift
//  Momentrack
//
//  Created by Nat Kim on 7/21/24.
//

import UIKit

extension PostingMomentViewController {
    enum Section: Int, Hashable {
        case friend
        case location
        case photo
        case text
        
        var name: String {
            switch self {
            case .friend:
                NSLocalizedString("함께한 사람 선택", comment: "with Friends")
            case .location:
                NSLocalizedString("현재 위치", comment: "Current Location")
            case .photo:
                NSLocalizedString("사진 등록", comment: "Upload Photo")
            case .text:
                NSLocalizedString("글 등록", comment: "text")
            }
        }
    }
}
