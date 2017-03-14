//
//  CircleImageEdit.swift
//  SocialApp
//
//  Created by Alfredo M. on 3/14/17.
//  Copyright © 2017 Alfredo M. All rights reserved.
//

import UIKit

class CircleImageEdit: UIImageView {

    override func layoutSubviews() {
        layer.cornerRadius = self.frame.width / 2
        
    }

}
