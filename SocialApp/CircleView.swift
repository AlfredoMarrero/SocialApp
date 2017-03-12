//
//  CircleView.swift
//  SocialApp
//
//  Created by Alfredo M. on 3/9/17.
//  Copyright © 2017 Alfredo M. All rights reserved.
//

import UIKit

class CircleView: UIImageView {
    override func layoutSubviews() {
        layer.cornerRadius = self.frame.width / 2
        clipsToBounds = true
    }
}
