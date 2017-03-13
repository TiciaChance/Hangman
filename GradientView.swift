//
//  GradientView.swift
//  Hangman
//
//  Created by Ticia Chance on 2/20/17.
//  Copyright © 2017 Ticia Chance. All rights reserved.
//

import UIKit
@IBDesignable

class GradientView: UIView {

    @IBInspectable var firstColor: UIColor = UIColor.clear {
        didSet {
            updateView()
        }
    }
    @IBInspectable var secondColor: UIColor = UIColor.clear {
        didSet {
            updateView()
        }
    }
    
    override class var layerClass : AnyClass {
        get {
            return CAGradientLayer.self
        }
    }
    func updateView() {
        let layer = self.layer as! CAGradientLayer
        layer.colors = [firstColor.cgColor, secondColor.cgColor]
    }
 

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
