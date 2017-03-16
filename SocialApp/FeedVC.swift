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
import MZFormSheetPresentationController

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPopoverPresentationControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addImage: CircleView!
    @IBOutlet weak var captionField: FancyField!
    
    var imageSelected = false
    
    var arrayOfPosts: [Post] = []
    var imagePicker: UIImagePickerController!
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    static var userNameCache: NSCache<NSString, NSString> = NSCache()
    
    private let currentUserId = KeychainWrapper.standard.string(forKey: KEY_UID)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadTableView), name: NSNotification.Name(rawValue: SHEET_PRESENTATION_DISMISSED), object: nil)
        
        DataService.ds.REF_POST.observe(.value, with: { snapshot in
            
            self.arrayOfPosts = []
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for post in snapshot {
                    // print (post)
                    
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        
        if editingStyle == .delete {
            print("Test: Deleted")
            
            let postToRemove = arrayOfPosts[indexPath.row]
            
            if postToRemove.userId == currentUserId {
                 DataService.ds.REF_POST.child(postToRemove.postKey).removeValue()
                
                arrayOfPosts.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as? PostCell {
            
            let post = arrayOfPosts[indexPath.row]
            
            if let img = FeedVC.imageCache.object(forKey: post.imageUrl as NSString) {
                
                if let userImg = FeedVC.imageCache.object(forKey: post.userId as NSString) {
                    cell.initCell(post: post,img: img, userImg: userImg)
                
                }else {
                     cell.initCell(post: post,img: img)
                }
            } else {
                cell.initCell(post: post)
            }
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
            imageSelected = true
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
    
    @IBAction func postButtonTapped(_ sender: Any) {
        guard let caption = captionField.text, caption != "" else{
            print("Message: Unable to get caption field.")
            return
        }
        
        guard let img = addImage.image, imageSelected == true else {
            print("Message: An image has not been selected.")
            return
        }
        
        if let imageData = UIImageJPEGRepresentation(img, 0.2) {
            
            let imageUid = NSUUID().uuidString
            let metadata = FIRStorageMetadata()
            metadata.contentType = "image/jpeg"
            DataService.ds.REF_POST_IMAGES.child(imageUid).put(imageData, metadata: metadata) { metadata, error in
                
                if error != nil {
                    print("Message: Unable to load image to Firebase")
                }else {
                    print("Message: Successfully uploaded image to Firebase storage")
                    let downloadUrl = metadata?.downloadURL()?.absoluteString
                    
                    self.postToFirebase(imageUrl: downloadUrl!)
                }
            }
        }
    }
    
    func postToFirebase(imageUrl: String) {
        
        let post: Dictionary<String, Any> = ["caption" : captionField.text! , "imageUrl" : imageUrl, "likes" : 0, "user": KeychainWrapper.standard.string(forKey: KEY_UID)! ]
        
        let firebasePost = DataService.ds.REF_POST.childByAutoId()
        firebasePost.setValue(post)
        self.captionField.text = ""
        self.imageSelected = false
        addImage.image = UIImage(named: "add-image")
        
        tableView.reloadData()
    }
    
    @IBAction func editUserButton(_ sender: Any) {
        let navigationController = self.storyboard!.instantiateViewController(withIdentifier: "SheetPresentationVC") as! SheetPresentationVC
        let formSheetController = MZFormSheetPresentationViewController(contentViewController: navigationController)
        formSheetController.presentationController?.contentViewSize = CGSize(width: 250,height: 280)
        
        let currentUserId = KeychainWrapper.standard.string(forKey: KEY_UID)
       // if let image = FeedVC.imageCache.object(forKey: currentUserId! as NSString) {
      //      navigationController.initFormSheetPresentaitonUI(userName: "Test user name", image: image)
       // } else {
      //      navigationController.initFormSheetPresentaitonUI(userName: "Test user name")
      //  }
        
        
        self.present(formSheetController, animated: true, completion: nil)
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        //controller.frameOfPresentedViewInContainerView = CGRect(x:0,y:0,width: 60 ,height: 60)
        return .formSheet
    }
    
    func reloadTableView() {
        tableView.reloadData()
    }
}
