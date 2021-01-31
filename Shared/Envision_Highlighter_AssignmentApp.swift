//
//  Envision_Highlighter_AssignmentApp.swift
//  Shared
//
//  Created by Hoye Lam on 26/01/2021.
//

import SwiftUI

@main
struct Envision_Highlighter_AssignmentApp: App {
    @State var image: UIImage? = nil
    var body: some Scene {
        WindowGroup {
            BookMainView()
        }
    }
}

let screen = UIScreen.main.bounds

