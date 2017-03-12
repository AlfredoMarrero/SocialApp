//
//  PostCell.swift
//  SocialApp
//
//  Created by Alfredo M. on 3/10/17.
//  Copyright © 2017 Alfredo M. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {

    
    @IBOutlet weak var profileImage: CircleView!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var postImg: UIImageView!
    @IBOutlet weak var caption: UITextView!
    @IBOutlet weak var likesLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    func initCell (post: Post){
    
        self.caption.text = post.caption
        self.likesLbl.text = String(post.likes)
    
    }
}
