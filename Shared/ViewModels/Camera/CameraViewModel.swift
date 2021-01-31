//
//  CameraViewModel.swift
//  Envision-Highlighter-Assignment (iOS)
//
//  Created by Hoye Lam on 30/01/2021.
//

import Foundation
import UIKit
import Vision

final class CameraViewModel: ObservableObject {
    @Published var image: UIImage? = nil {
        didSet {
            self.performOCR()
        }
    }
    
    @Published var previewHighlight: String = ""
    
    var request: VNRecognizeTextRequest!
    
    init() {
        // exists when the first image is received.
        request = VNRecognizeTextRequest(completionHandler: recognizeTextHandler)
        request.recognitionLevel = .accurate
        request.usesLanguageCorrection = true
    }
    
    /// Optical Character Recognition
    
    // Vision recognition handler.
    private func recognizeTextHandler(request: VNRequest, error: Error?) {
        guard let results = request.results as? [VNRecognizedTextObservation] else {
            return
        }
        
        let maximumCandidates = 1
        let recognizedStrings = results.compactMap { observation in
            // Return the string of the top VNRecognizedText instance.
            return observation.topCandidates(maximumCandidates).first?.string
        }
        
        var ocrText = ""
        for recognizedWord in recognizedStrings {
            ocrText += recognizedWord + " "
        }
        
        DispatchQueue.main.async {
            self.previewHighlight = ocrText
        }
    }

    func performOCR() {
        // image cropped from camera
        guard let image = image else { return }
        guard let cgImage = image.cgImage else { return }
        
        let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        do {
            try requestHandler.perform([request])
        } catch let error {
            print(error)
        }
    }
}
