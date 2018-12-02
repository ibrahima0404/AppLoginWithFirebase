//
//  CustomizableImageView.swift
//  AppLoginWithFirebase
//
//  Created by Ibrahima KH GUEYE on 09/12/2017.
//  Copyright © 2017 Ibrahima KH GUEYE. All rights reserved.
//

import UIKit

@IBDesignable class CustomizableImageView: UIImageView {
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
   
    @IBInspectable var borderWith: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWith
        }
    }
    
}
