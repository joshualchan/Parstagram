//
//  CameraViewController.swift
//  Parstagram
//
//  Created by Joshua Chan on 5/7/20.
//  Copyright © 2020 Joshua Chan. All rights reserved.
//

import UIKit
import AlamofireImage
import Parse

class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var captionField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func onSubmit(_ sender: Any) {
        //Creates relations on Parse
        let post = PFObject(className: "Posts")
        post["caption"] = captionField.text!
        post["author"] = PFUser.current()!
        
        let imageData = imageView.image!.pngData()
        let file = PFFileObject(data: imageData!)
        post["image"] = file
        
        post.saveInBackground { (success, error) in
            if success {
                //closes current view and goes back to previous one
                self.dismiss(animated: true, completion: nil)
                print("Saved!")
            } else {
                print("Error!")
            }
        }
    }
    
    @IBAction func onCameraButton(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) { //do we have a camera? i.e. are we running on a simulator
            picker.sourceType = .camera
        } else { //we are running on a simulator
            picker.sourceType = .photoLibrary
        }
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.editedImage] as! UIImage
        let size = CGSize(width: 300, height: 300)
        let scaledImage = image.af.imageScaled(to: size)
        imageView.image = scaledImage
        dismiss(animated: true, completion: nil) //dismisses the camera view
    }
    
}
