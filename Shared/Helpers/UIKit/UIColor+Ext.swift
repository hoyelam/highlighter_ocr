//
//  UIColor+Ext.swift
//  Envision-Highlighter-Assignment (iOS)
//
//  Created by Hoye Lam on 26/01/2021.
//

import UIKit
import SwiftUI

// MARK: - Hexcode UIColor
// https://www.hackingwithswift.com/example-code/uicolor/how-to-convert-a-hex-color-to-a-uicolor

extension UIColor {
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255

                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }

        return nil
    }
}

extension UIColor {
    static var background = UIColor(Color.background)
    static var secondaryBackground = UIColor(Color.secondaryBackground)
    
    /// Default background color for textfields
    static var textFieldBackground = UIColor(Color.textFieldBackground)
    
    /// Default background color for list and row elemenets
    static var elementBackground = UIColor(Color.elementBackground)
    
    /// Envision Highlighter Default Text Color (Title, Headlines, Body)
    static var text = UIColor(Color.text)
    
    /// Envision Highlighter Default secondary Text Color (Subtitles, Captions)
    static var secondaryText = UIColor(Color.secondaryText)
    
    static var accent = UIColor(Color.accent)
    static var secondAccent = UIColor(Color.secondAccent)
}


