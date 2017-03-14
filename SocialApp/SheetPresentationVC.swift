//
//  SheetPresentationVC.swift
//  SocialApp
//
//  Created by Alfredo M. on 3/14/17.
//  Copyright © 2017 Alfredo M. All rights reserved.
//
//image resource : <a href="https://icons8.com/web-app/7820/Circled-User-Male">Circled user male and other icons by Icons8</a>
import UIKit

class SheetPresentationVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var userImage: CircleView!
    @IBOutlet weak var textView: UITextField!
    
    var imagePicker: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func doneButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func imageTapped(_ sender: Any) {
        print ("Llego aqui.")
        
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
