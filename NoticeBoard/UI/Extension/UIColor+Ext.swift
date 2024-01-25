//
//  UIColor+Ext.swift
//  NoticeBoard
//
//  Created by 김형진 on 2023/10/27.
//

import UIKit

extension UIColor {
    // red, green, blue 값을 0~255 범위로 전달 받아서 UIColor 객체 생성
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")

        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    // 16진수(hex) 값을 전달 받아서 UIColor 객체 생성
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var r = 1.0
        var g = 1.0
        var b = 1.0
        var hexFormatted: String = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        
        // 첫번째가 '#'으로 시작될 경우 제거
        if hexFormatted.hasPrefix("#") {
            hexFormatted = String(hexFormatted.dropFirst())
        }
        
        if hexFormatted.count == 6 {
            var rgbValue: UInt64 = 0
            Scanner(string: hexFormatted).scanHexInt64(&rgbValue)
            
            r = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
            g = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
            b = CGFloat(rgbValue & 0x0000FF) / 255.0
        }
        
        self.init(red: r, green: g, blue: b, alpha: alpha)
    }
}

