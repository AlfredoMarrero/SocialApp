//
//  PostCell.swift
//  SocialApp
//
//  Created by Alfredo M. on 3/10/17.
//  Copyright © 2017 Alfredo M. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class PostCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: CircleView!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var postImg: UIImageView!
    @IBOutlet weak var caption: UITextView!
    @IBOutlet weak var likesLbl: UILabel!
    @IBOutlet weak var likeImg: UIImageView!
    
    var userImageUrl: String!
    var post: Post!
    var likesRef = FIRDatabaseReference()
    var userNameRef = FIRDatabaseReference()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(likeTapped))
        tap.numberOfTapsRequired = 1
        likeImg.addGestureRecognizer(tap)
        likeImg.isUserInteractionEnabled = true
    }
    
    func initCell (post: Post, img: UIImage? = nil, userImg: UIImage? = nil){
        
        self.post = post
        likesRef = DataService.ds.REF_USER_CURRENT.child("likes").child(post.postKey)
        userNameRef = DataService.ds.REF_USERS.child(post.userId)
        userNameRef.observe(.value, with:{ snapshot in
            
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for value in snapshot {
                    
                    if value.key == "userName" {
                        self.userNameLbl.text = value.value as? String!
                        
                        if let userId = KeychainWrapper.standard.string(forKey: KEY_UID), post.userId == userId {
                            FeedVC.userNameCache.setObject(self.userNameLbl.text! as NSString , forKey: userId as NSString)
                        }
                    } else if value.key == "userImageUrl" {
                        if let url = value.value as? String {
                            self.userImageUrl = url
                            
                            if userImg != nil {
                                self.profileImage.image = userImg
                            }else {
                                let ref = FIRStorage.storage().reference(forURL: self.userImageUrl)
                                ref.data(withMaxSize: 2 * 1024 * 1024, completion: { data, error in
                                    if error != nil {
                                        print("Message: Unable to download user profile image from database.")
                                    }
                                    else if let imageData = data {
                                        
                                        if let img = UIImage(data: imageData) {
                                            self.profileImage.image = img
                                            FeedVC.imageCache.setObject(img, forKey: post.userId as NSString)
                                        }
                                    }
                                })
                            }
                        }
                    }
                }
            }
        })

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
        
        likesRef.observeSingleEvent(of: .value, with: { snapshot in
            if let _ = snapshot.value as? NSNull {
                self.likeImg.image = UIImage(named: "empty-heart")
            }
            else {
                self.likeImg.image = UIImage(named: "filled-heart")
            }
        })
    }
    
    func likeTapped(sender: UITapGestureRecognizer) {
        likesRef.observeSingleEvent(of: .value, with: { snapshot in
            if let _ = snapshot.value as? NSNull {
                self.likeImg.image = UIImage(named: "filled-heart")
                self.post.adjustLikes(addLike: true)
                self.likesRef.setValue(true)
            }
            else {
                self.likeImg.image = UIImage(named: "empty-heart")
                self.post.adjustLikes(addLike: false)
                self.likesRef.removeValue()
            }
        })
    }
}
