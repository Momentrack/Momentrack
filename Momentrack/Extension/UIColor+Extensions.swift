//
//  UIColor+Extensions.swift
//  Momentrack
//
//  Created by Nat Kim on 7/31/24.
//

import UIKit

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: 1.0
        )
    }
    
    convenience init(hex: Int) {
        self.init(
            red: (hex >> 16) & 0xFF,
            green: (hex >> 8) & 0xFF,
            blue: hex & 0xFF
        )
    }
}

extension UIColor {
    static var lightBlueJean: UIColor {
        return UIColor(hex: 0x548BA2)
    }
    
    static var pastelBlueJean: UIColor {
        return UIColor(hex: 0x8AB7C9)
    }
    
    static var basicGray: UIColor {
        return UIColor(hex: 0xd9d9d9)
    }
}

