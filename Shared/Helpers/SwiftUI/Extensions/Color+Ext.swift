//
//  Color+Ext.swift
//  Envision-Highlighter-Assignment (iOS)
//
//  Created by Hoye Lam on 26/01/2021.
//

import SwiftUI

extension Color {
    static var background = Color("BGColor")
    static var secondaryBackground = Color("SecondaryBGColor")
    
    /// Default background color for textfields
    static var textFieldBackground = Color("TextFieldBGColor")
    
    /// Default background color for list and row elemenets
    static var elementBackground = Color("ElementBGColor")
    
    /// Envision Highlighter Default Text Color (Title, Headlines, Body)
    static var text = Color("TextColor")
    
    /// Envision Highlighter Default secondary Text Color (Subtitles, Captions)
    static var secondaryText = Color("SecondaryTextColor")
    
    static var accent = Color("AccentColor")
    static var secondAccent = Color("SecondaryAccentColor")
}
