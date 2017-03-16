//
//  SheetPresentationVC.swift
//  SocialApp
//
//  Created by Alfredo M. on 3/14/17.
//  Copyright © 2017 Alfredo M. All rights reserved.
//
//image resource : <a href="https://icons8.com/web-app/7820/Circled-User-Male">Circled user male and other icons by Icons8</a>

import UIKit
import Firebase
import SwiftKeychainWrapper

class SheetPresentationVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var userImage: CircleView!
    @IBOutlet weak var textView: UITextField!
    
    var imagePicker: UIImagePickerController!
    
    private let userId = KeychainWrapper.standard.string(forKey: KEY_UID)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        if let image = FeedVC.imageCache.object(forKey: userId as NSString) {
            self.userImage.image = image
        } else {
            self.userImage.image = UIImage(named: "user-picture")
        }
        
        if let userName = FeedVC.userNameCache.object(forKey: userId as NSString) {
            self.textView.text = userName as String
        }else {
            self.textView.text = ""
        }

    }
    
    func initFormSheetPresentaitonUI(userName: String, image: UIImage? = nil){
        self.userImage.image = image
        textView.text = userName
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneButton(_ sender: Any) {
        
        guard let userImage = userImage.image else {
            print("Message: No image selected.")
            return
        }
        
        guard let userName = textView.text else{

            print("Message: User Name not selected.")
            return
        }
        
        if let imageData = UIImageJPEGRepresentation(userImage, 0.2) {
            
            let userImageId = NSUUID().uuidString
            let metadata = FIRStorageMetadata()
            metadata.contentType = "image/jpeg"
            DataService.ds.REF_POST_USER_IMAGE.child(userImageId).put(imageData, metadata: metadata) { metadata, error in
                if error != nil {
                    print("Message: Unable to load image to Firebase.")
                }else {
                    print ("Message: Successfully loaded image to Firebase.")
                    let downloadUrl = metadata?.downloadURL()?.absoluteString
                    self.postToFirebase(imageUrl: downloadUrl!)
                }
            }
        }
        
        FeedVC.imageCache.setObject(self.userImage.image!, forKey: userId as NSString)
        FeedVC.userNameCache.setObject(self.textView.text! as NSString, forKey: userId as NSString)
        self.dismiss(animated: true, completion: {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: SHEET_PRESENTATION_DISMISSED), object: self);
        })
        
        
        //self.dismiss(animated: true, completion: nil)
    }
    
    func postToFirebase(imageUrl : String) {
        let post: Dictionary<String, Any> = ["userImageUrl": imageUrl, "userName" : self.textView.text ?? " "]
        
        
        let firebasePost = DataService.ds.REF_USER_CURRENT
        firebasePost.setValue(post)
    }
    
    @IBAction func imageTapped(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            userImage.image = image
        } else {
            print("Message: Image was not selected.")
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
}
