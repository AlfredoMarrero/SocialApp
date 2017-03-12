//
//  FeedVC.swift
//  SocialApp
//
//  Created by Alfredo M. on 3/9/17.
//  Copyright © 2017 Alfredo M. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addImage: CircleView!
    
    var arrayOfPosts: [Post] = []
    var imagePicker: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        
        DataService.ds.REF_POST.observe(.value, with: { snapshot in
            
            self.arrayOfPosts = []
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for post in snapshot {
                    print (post)
                    
                    if let postDic = post.value as? Dictionary<String, AnyObject> {
                        
                        let fetchedPost = Post(postKey: post.key, postData: postDic)
                        self.arrayOfPosts.append(fetchedPost)
                    }
                }
            }
            
            self.tableView.reloadData()
        })
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as? PostCell {
            cell.initCell(post: arrayOfPosts[indexPath.row])
            return cell
        }
        
        return PostCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfPosts.count
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            addImage.image = image
        } else {
            print("Message: Image was not selected.")
        
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func signOutTapped(_ sender: Any) {
        let keyChainResult = KeychainWrapper.standard.remove(key: KEY_UID)
        print("Message: \(keyChainResult)")
        try? FIRAuth.auth()?.signOut()
        performSegue(withIdentifier: "goToSignIn", sender: nil)
    }
    
    @IBAction func addImageTapped(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    
    
}
