//
//  CameraViewController.swift
//  Envision-Highlighter-Assignment
//
//  Created by Hoye Lam on 29/01/2021.
//

import AVFoundation
import SwiftUI

struct CameraView: UIViewControllerRepresentable {
    var pictureTaken: (UIImage) -> ()
    
    public class CameraViewCoordinator: NSObject {
        var parent: CameraView
        
        init(parent: CameraView) {
            self.parent = parent
        }
        
        func sendTakenPicture(image: UIImage) {
            parent.pictureTaken(image)
        }
    }
    
    public class CameraViewController: UIViewController, AVCapturePhotoCaptureDelegate {
        var captureSession: AVCaptureSession!
        let captureSessionQueue = DispatchQueue(label: "captureSessionQueue")
        
        var stillImageOutput: AVCapturePhotoOutput!
        var previewLayer: AVCaptureVideoPreviewLayer!
        
        var captureDevice: AVCaptureDevice?
        
        var delegate: CameraViewCoordinator?

        // MARK: - Region of interest (ROI) and text orientation
        // Region of video data output buffer that recognition should be run on.
        // Gets recalculated once the bounds of the preview layer are known.
        var regionOfInterest = CGRect(x: 0, y: 0, width: 1, height: 1)
        var regionOfInterestView = UIView()
        
        override public func viewDidLoad() {
            super.viewDidLoad()
                
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(updateOrientation),
                                                   name: Notification.Name("UIDeviceOrientationDidChangeNotification"),
                                                   object: nil)
            
            view.backgroundColor = UIColor.black
            captureSession = AVCaptureSession()
            
            // Starting the capture session is a blocking call. Perform setup using
            // a dedicated serial dispatch queue to prevent blocking the main thread.
            captureSessionQueue.async {
                self.setupCamera()
            }
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(tappedScreen))
            view.addGestureRecognizer(tap)
        }
        
        override public func viewWillLayoutSubviews() {
            DispatchQueue.main.async {
                self.previewLayer?.frame = self.view.layer.bounds
            }
        }
        
        override func accessibilityActivate() -> Bool {
            return true
        }
        
        @objc func updateOrientation() {
            guard let orientation = UIApplication.shared.windows.first?.windowScene?.interfaceOrientation else { return }
            guard let connection = captureSession.connections.last, connection.isVideoOrientationSupported else { return }
            guard let previewLayerConnection = previewLayer.connection else { return }
            
            let currentOrientation = AVCaptureVideoOrientation(rawValue: orientation.rawValue) ?? .portrait
            connection.videoOrientation = currentOrientation
            previewLayerConnection.videoOrientation = currentOrientation
        }
        
        override public func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            updateOrientation()
        }
        
        override public func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            
            if previewLayer == nil {
                previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            }
            
            previewLayer.frame = view.layer.bounds
            previewLayer.videoGravity = .resizeAspectFill
            
            view.layer.addSublayer(previewLayer)
            
            if (captureSession?.isRunning == false) {
                captureSession.startRunning()
            }
        }
        
        override public func viewDidDisappear(_ animated: Bool) {
            super.viewDidDisappear(animated)
            
            if (captureSession?.isRunning == true) {
                captureSession.stopRunning()
            }
            
            NotificationCenter.default.removeObserver(self)
        }
        
        override public var prefersStatusBarHidden: Bool {
            return true
        }
        
        override public var supportedInterfaceOrientations: UIInterfaceOrientationMask {
            return .all
        }
        
        @objc private func tappedScreen() {
            // Ensure the right orientation is known
            updateOrientation()
            
            let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
            stillImageOutput.capturePhoto(with: settings, delegate: self)
        }
        
        func setupCamera() {
            guard let captureDevice = AVCaptureDevice.default(for: .video) else {
                print("Could not create capture device.")
                return
            }
            
            // Set zoom and autofocus to help focus on very small text.
            do {
                try captureDevice.lockForConfiguration()
                captureDevice.videoZoomFactor = 2
                captureDevice.autoFocusRangeRestriction = .near
                captureDevice.unlockForConfiguration()
            } catch {
                print("Could not set zoom level due to error: \(error)")
                return
            }
            
            // NOTE:
            // Requesting 4k buffers allows recognition of smaller text but will
            // consume more power. Use the smallest buffer size necessary to keep
            // down battery usage.
            if captureDevice.supportsSessionPreset(.hd4K3840x2160) {
                captureSession.sessionPreset = AVCaptureSession.Preset.hd4K3840x2160
            } else if captureDevice.supportsSessionPreset(.hd1920x1080){
                captureSession.sessionPreset = AVCaptureSession.Preset.hd1920x1080
            } else {
                captureSession.sessionPreset = AVCaptureSession.Preset.hd1280x720
            }
            
            self.captureDevice = captureDevice
            
            guard let deviceInput = try? AVCaptureDeviceInput(device: captureDevice) else {
                return
            }
            
            stillImageOutput = AVCapturePhotoOutput()
            stillImageOutput.isHighResolutionCaptureEnabled = true
            stillImageOutput.maxPhotoQualityPrioritization = .quality
            
            if let photoOutputConnection = stillImageOutput.connection(with: AVMediaType.video) {
                photoOutputConnection.preferredVideoStabilizationMode = .auto
            }
            
            if captureSession.canAddInput(deviceInput) {
                captureSession.addInput(deviceInput)
                captureSession.addOutput(stillImageOutput)
            }
            
            captureSession.startRunning()
            
            DispatchQueue.main.async {
                self.setupRegionOfInterest()
            }
        }
        
        func setupRegionOfInterest() {
            regionOfInterestView.removeFromSuperview()
            
            // Setup the Region where we are interested in
            regionOfInterest = CGRect(x: 0,
                                      y: view.bounds.height / 2,
                                      width: view.bounds.width,
                                      height: view.bounds.height * 0.15)
            
            regionOfInterestView.layer.borderColor = UIColor.accent.cgColor
            regionOfInterestView.layer.borderWidth = 2
            regionOfInterestView.frame = regionOfInterest
            
            regionOfInterestView.backgroundColor = UIColor.accent.withAlphaComponent(0.25)
            self.view.addSubview(regionOfInterestView)
            self.view.bringSubviewToFront(regionOfInterestView)
            
            previewLayer.metadataOutputRectConverted(fromLayerRect: regionOfInterest)
        }
        
        func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
            if let error = error {
                print("Photo Capture Error: \(String(describing: error))")
            }
            
            self.readyScreenCaptureForOCR(photo: photo)
        }
        
        private func readyScreenCaptureForOCR(photo: AVCapturePhoto) {
            if let cgImageRepresentation = photo.cgImageRepresentation(),
               let orientationInt = photo.metadata[String(kCGImagePropertyOrientation)] as? UInt32,
               let imageOrientation = UIImage.Orientation.orientation(fromCGOrientationRaw: orientationInt) {
                
                let cgImage = cgImageRepresentation.takeUnretainedValue()
                
                guard let croppedImage = self.cropImage(cgImage: cgImage, orientation: imageOrientation) else { return }
                delegate?.sendTakenPicture(image: croppedImage)
            }
        }
        
        private func cropImage(cgImage: CGImage, orientation: UIImage.Orientation) -> UIImage? {
            let outputRect = previewLayer.metadataOutputRectConverted(fromLayerRect: regionOfInterest)
            
            let width = CGFloat(cgImage.width)
            let height = CGFloat(cgImage.height)
            
            let cropRect = CGRect(x: outputRect.origin.x * width,
                                  y: outputRect.origin.y * height,
                                  width: outputRect.size.width * width,
                                  height: outputRect.size.height * height)


            if let croppedCGImage = cgImage.cropping(to: cropRect) {
                return UIImage(cgImage: croppedCGImage, scale: 1.0, orientation: orientation)
            }

            return nil
        }
    }
    
    public func makeCoordinator() -> CameraViewCoordinator {
        return CameraViewCoordinator(parent: self)
    }
    
    public func makeUIViewController(context: Context) -> CameraViewController {
        let viewController = CameraViewController()
        viewController.delegate = context.coordinator
        return viewController
    }
    
    public func updateUIViewController(_ uiViewController: CameraViewController, context: Context) {
        
    }
}
