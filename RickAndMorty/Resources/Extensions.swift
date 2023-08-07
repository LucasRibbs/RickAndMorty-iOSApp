//
//  Extensions.swift
//  RickAndMorty
//
//  Created by  on 31/01/23.
//

import UIKit

extension String {
    
    func sizeWithFont(_ font: UIFont, lineBreakMode: NSLineBreakMode, constrainedToSize size: CGSize) -> CGSize {
                
        let dummyLabel: UILabel = {
            let label = UILabel(frame: CGRect(origin: .zero, size: size))
            label.text = self
            label.font = font
            label.lineBreakMode = lineBreakMode
            label.numberOfLines = 0
            
            return label
        }()
        
        dummyLabel.sizeToFit()
        
        return dummyLabel.frame.size
    }
    
    var capitalizedSentence: String {
        
        let firstLetter = self.prefix(1).uppercased()
        let remainingLetters = self.dropFirst()
        return firstLetter + remainingLetters
    }
}

extension UIImage {
    
    func blurredImage() -> UIImage {
        
        let context = CIContext(options: nil)
        
        let currentFilter = CIFilter(name: "CIGaussianBlur")!
        let beginImage = CIImage(image: self)!
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        currentFilter.setValue(10, forKey: kCIInputRadiusKey)

        let cropFilter = CIFilter(name: "CICrop")!
        cropFilter.setValue(currentFilter.outputImage, forKey: kCIInputImageKey)
        cropFilter.setValue(CIVector(cgRect: beginImage.extent), forKey: "inputRectangle")

        let output = cropFilter.outputImage!
        let cgimg = context.createCGImage(output, from: output.extent)!
        let blurredImage = UIImage(cgImage: cgimg)
        return blurredImage
    }
}

extension UIView {
    
    func addSubviews(_ views: UIView...) {
        
        views.forEach({
            addSubview($0)
        })
    }
}

extension UIImageView {
    
    func addBlur() {
        // create effect
        let effect = UIBlurEffect(style: .regular)
        let effectView = UIVisualEffectView(effect: effect)
        
        // set boundry and alpha
        effectView.frame = self.bounds
        effectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        effectView.alpha = 1.0
        
        self.addSubview(effectView)
    }
}

extension UILabel {
    
    static func expectedHeight(withNumberOfLines numberOfLines: Int) -> CGFloat {
        
        let dummyLabel: UILabel = {
            let label = UILabel(frame: .zero)
            label.text = [String](repeating: "i", count: numberOfLines).joined(separator: "\n")
            label.lineBreakMode = .byWordWrapping
            label.numberOfLines = 0
            
            return label
        }()
        
        dummyLabel.sizeToFit()
        
        return dummyLabel.frame.height
    }
}
