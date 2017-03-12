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

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var tableView: UITableView!
    
    var arrayOfPosts: [Post] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        DataService.ds.REF_POST.observe(.value, with: { snapshot in
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

    @IBAction func signOutTapped(_ sender: Any) {
        let keyChainResult = KeychainWrapper.standard.remove(key: KEY_UID)
        print("Message: \(keyChainResult)")
        try? FIRAuth.auth()?.signOut()
        performSegue(withIdentifier: "goToSignIn", sender: nil)
    }
    

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as? PostCell {
            cell.initCell(post: arrayOfPosts[indexPath.row])
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfPosts.count
    }
    
    

}
