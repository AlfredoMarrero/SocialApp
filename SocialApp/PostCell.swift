//
//  PostCell.swift
//  SocialApp
//
//  Created by Alfredo M. on 3/10/17.
//  Copyright © 2017 Alfredo M. All rights reserved.
//

import UIKit
import Firebase

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
    
    
    func initCell (post: Post, img: UIImage? = nil){
        
        self.caption.text = post.caption
        self.likesLbl.text = String(post.likes)
        
        if img != nil {
            self.postImg.image = img
        } else {
            let ref = FIRStorage.storage().reference(forURL: post.imageUrl)
            ref.data(withMaxSize: 2 * 1024 * 1024, completion: { data, error in
                if error != nil {
                    print ("Message: Unable to download image from Firebase storage.")
                } else {
                    print ("Message: Image downloaded from Firebase")
                    
                    if let imgData = data {
                        if let img = UIImage(data: imgData) {
                            self.postImg.image = img
                            FeedVC.imageCache.setObject(img, forKey: post.imageUrl as NSString)
                        }
                    }
                }
            })
        }
    }
}
