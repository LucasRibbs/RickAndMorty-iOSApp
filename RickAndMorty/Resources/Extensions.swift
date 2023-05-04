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
}


extension UIView {
    
    func addSubviews(_ views: UIView...) {
        
        views.forEach({
            addSubview($0)
        })
    }
}
