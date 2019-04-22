//
//  ShakeButton.swift
//  Minesweeper
//
//  Created by ShaoJen Chen on 2019/4/22.
//  Copyright © 2019 陳劭任. All rights reserved.
//

import UIKit

protocol Shakable {
    
    func shake()
    
}

extension Shakable {
    
    func shake() {
        
        guard let btn = self as? UIButton else { return }
        
        btn.transform = CGAffineTransform(translationX: 30, y: 0)
        
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.0, options: .curveLinear, animations: {
            
            btn.transform = CGAffineTransform.identity
            
        }, completion: nil)
        
    }
    
}

class ShakeButton: UIButton, Shakable {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.cornerRadius = 5.0
        
        self.clipsToBounds = true
        
        let color = self.titleLabel!.textColor!
        
        let disabledColor = color.withAlphaComponent(0.3)
        
        let sliverColor = UIColor(red: 0.75, green: 0.75, blue: 0.75, alpha: 1.0).cgColor
        
        self.layer.borderColor = sliverColor
        
        self.layer.borderWidth = 1.0
        
        self.setTitleColor(color, for: .normal)
        
        self.setTitleColor(disabledColor, for: .disabled)

        let gradientLayer = CAGradientLayer()
        
        let color1 = UIColor.black.cgColor
        
        let color2 = sliverColor
        
        gradientLayer.frame = self.bounds
        
        gradientLayer.colors = [color1, color2]
        
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    
}
