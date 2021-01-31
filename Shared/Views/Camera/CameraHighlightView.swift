//
//  CameraHighlightView.swift
//  Envision-Highlighter-Assignment (iOS)
//
//  Created by Hoye Lam on 30/01/2021.
//

import SwiftUI

struct CameraHighlightView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject var viewModel = CameraViewModel()
    
    var didHighlightText: (String) -> ()
    
    var body: some View {
        VStack(spacing: 16) {
            if !viewModel.previewHighlight.isEmpty {
                Text("Preview")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(Color.text)
                    .padding(.top)
                
                ScrollView(.vertical) {
                    Text("\(viewModel.previewHighlight)")
                        .font(.title2)
                        .foregroundColor(Color.text)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.top)
                }
                
                if let image = viewModel.image {
                    Image(uiImage: image)
                        .resizable()
                        .frame(width: screen.width, height: 150)
                        .aspectRatio(contentMode: .fit)
                }
                
                Spacer()
                
                Button(action: {
                    self.didHighlightText(self.viewModel.previewHighlight)
                    self.presentationMode.dismiss()
                }) {
                    Text("confirm")
                }
                .mainButtonModifier()
                
                Button(action: {
                    DispatchQueue.main.async {
                        self.viewModel.previewHighlight = ""
                    }
                }) {
                    Text("try_again_text")
                        .font(.body)
                        .foregroundColor(.secondaryText)
                        .padding(8)
                }
            } else {
                HStack {
                    Spacer()
                    
                    Button(action: {
                        self.presentationMode.dismiss()
                    }) {
                        Text("cancel")
                            .font(.body)
                            .foregroundColor(.text)
                            .padding(8)
                            .background(Color.textFieldBackground)
                            .cornerRadius(16)
                    }
                }
                .padding(.horizontal)
                
                
                ZStack {
                    CameraView { (image) in
                        DispatchQueue.main.async {
                            self.viewModel.image = image
                        }
                    }
                    
                    VStack {
                        Text("tap_anywhere_to_highlight")
                            .font(.body)
                            .foregroundColor(.text)
                            .padding()
                            .background(Color.textFieldBackground)
                            .cornerRadius(16)
                        
                        Spacer()
                    }
                    .padding()
                }
            }
        }
        .background(Color.background)
    }
}

// TODO: Simulator Support for Camera Dummy
//
//struct CameraHighlightView_Previews: PreviewProvider {
//    static var previews: some View {
//
//        CameraHighlightView() { text in
//            print("Highlighted \(text)")
//        }
//    }
//}
