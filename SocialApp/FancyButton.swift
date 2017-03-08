//
//  FancyButton.swift
//  SocialApp
//
//  Created by Alfredo M. on 3/8/17.
//  Copyright © 2017 Alfredo M. All rights reserved.
//

import UIKit

class FancyButton: UIButton {


    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.shadowColor = UIColor (red: SHADOW_GRAY, green: SHADOW_GRAY, blue: SHADOW_GRAY, alpha: 0.8).cgColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        layer.cornerRadius = 2.0
    }

}
