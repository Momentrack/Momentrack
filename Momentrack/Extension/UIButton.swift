//
//  UIButton.swift
//  Momentrack
//
//  Created by Nat Kim on 7/22/24.
//

import UIKit

extension UIButton {
    func setUnderline() {
        guard let title = title(for: .normal) else { return }
        let attributedString = NSMutableAttributedString(string: title)
        attributedString.addAttribute(.underlineStyle,
                                      value: NSUnderlineStyle.single.rawValue,
                                      range: NSRange(
                                        location: 0,
                                        length: title.count
                                      )
        )
        setAttributedTitle(attributedString, for: .normal)
    }
}
