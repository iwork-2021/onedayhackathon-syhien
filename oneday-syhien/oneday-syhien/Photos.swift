//
//  Photos.swift
//  oneday-syhien
//
//  Created by nju on 2021/12/21.
//

import UIKit
import CoreML
import Vision

class Photos: NSObject {
    var imageViews: [UIImage] = []
    var snacksViews: [String:[UIImage]] = ["apple":[],
                                           "banana":[],
                                           "cake":[],
                                           "candy":[],
                                           "carrot":[],
                                           "cookie":[],
                                           "doughnut":[],
                                           "grape":[],
                                           "hot dog":[],
                                           "ice cream":[],
                                           "juice":[],
                                           "muffin":[],
                                           "orange":[],
                                           "pineapple":[],
                                           "popcorn":[],
                                           "pretzel":[],
                                           "salad":[],
                                           "strawberry":[],
                                           "waffle":[],
                                           "watermelon":[]]
    var viewAllController: UICollectionViewController?
    var imageToDetected: UIImage = UIImage()
    
    override init() {
        imageViews.append(UIImage(named: "banana-sample.jpg")!)
        snacksViews["banana"]?.append(UIImage(named: "banana-sample.jpg")!)
        imageViews.append(UIImage(named: "cake-sample.jpg")!)
        snacksViews["cake"]?.append(UIImage(named: "cake-sample.jpg")!)
        imageViews.append(UIImage(named: "doughnut-sample.jpg")!)
        snacksViews["doughnut"]?.append(UIImage(named: "doughnut-sample.jpg")!)
        imageViews.append(UIImage(named: "juice-sample.jpg")!)
        snacksViews["juice"]?.append(UIImage(named: "juice-sample.jpg")!)
        imageViews.append(UIImage(named: "orange-sample.jpg")!)
        snacksViews["orange"]?.append(UIImage(named: "orange-sample.jpg")!)
    }
    
    func getNumbers() -> Int {
        return imageViews.count
    }
    
    func addImage(newImage: UIImage) {
        imageViews.append(newImage)
        DispatchQueue.main.async {
            self.viewAllController?.collectionView.reloadData()
        }
        imageToDetected = newImage
        classify(image: imageToDetected)
//        print(imageViews.count)
    }
    
    func classify(image: UIImage) {
        let scaledImage = image.scalePreservingAspectRatio(targetSize: CGSize(width: 299, height: 299))
        guard let pixelbuffer = scaledImage.toCVPixelBuffer() else { return }
        let handler = VNImageRequestHandler(cvPixelBuffer: pixelbuffer)
        do {
            try handler.perform([self.classificationRequest])
        } catch {
            print("Failed to perform classification: \(error)")
        }
    }
    
    lazy var classificationRequest: VNCoreMLRequest = {
        do{
            let classifier = try snacks(configuration: MLModelConfiguration())
            let model = try VNCoreMLModel(for: classifier.model)
            let request = VNCoreMLRequest(model: model, completionHandler: {
                [weak self] request,error in
                self?.processObservations(for: request, error: error)
            })
            request.imageCropAndScaleOption = .centerCrop
            return request
        } catch {
            fatalError("Failed to create request")
        }
    }()
    
    func processObservations(for request: VNRequest, error: Error?) {
        if let results = request.results as? [VNClassificationObservation] {
            if results.isEmpty {
                return
            } else {
                let result = results[0].identifier
                let confidence = results[0].confidence
                if confidence > 0.6 {
//                    print(result)
//                    print(confidence)
                    snacksViews[result]?.append(imageToDetected)
//                    print(snacksViews[result]?.count)
                }
            }
        } else if let error = error {
            print(error.localizedDescription)
        } else {
            print("error")
        }
    }
}


extension UIImage {
    func scalePreservingAspectRatio(targetSize: CGSize) -> UIImage {
            // Determine the scale factor that preserves aspect ratio
            let widthRatio = targetSize.width / size.width
            let heightRatio = targetSize.height / size.height
            
            let scaleFactor = min(widthRatio, heightRatio)
            
            // Compute the new image size that preserves aspect ratio
            let scaledImageSize = CGSize(
                width: size.width * scaleFactor,
                height: size.height * scaleFactor
            )

            // Draw and return the resized UIImage
            let renderer = UIGraphicsImageRenderer(
                size: scaledImageSize
            )

            let scaledImage = renderer.image { _ in
                self.draw(in: CGRect(
                    origin: .zero,
                    size: scaledImageSize
                ))
            }
            
            return scaledImage
        }
    
    func toCVPixelBuffer() -> CVPixelBuffer? {
        let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue, kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
        var pixelBuffer : CVPixelBuffer?
        let status = CVPixelBufferCreate(kCFAllocatorDefault, Int(self.size.width), Int(self.size.height), kCVPixelFormatType_32ARGB, attrs, &pixelBuffer)
        guard status == kCVReturnSuccess else {
            return nil
        }

        if let pixelBuffer = pixelBuffer {
            CVPixelBufferLockBaseAddress(pixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
            let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer)

            let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
            let context = CGContext(data: pixelData, width: Int(self.size.width), height: Int(self.size.height), bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer), space: rgbColorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)

            context?.translateBy(x: 0, y: self.size.height)
            context?.scaleBy(x: 1.0, y: -1.0)

            UIGraphicsPushContext(context!)
            self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
            UIGraphicsPopContext()
            CVPixelBufferUnlockBaseAddress(pixelBuffer, CVPixelBufferLockFlags(rawValue: 0))

            return pixelBuffer
        }

        return nil
    }
}
