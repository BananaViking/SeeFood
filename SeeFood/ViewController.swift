//
//  ViewController.swift
//  SeeFood
//
//  Created by Banana Viking on 1/19/19.
//  Copyright © 2019 Banana Viking. All rights reserved.
//

import UIKit
import VisualRecognitionV3

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let imagePicker = UIImagePickerController()
    let apiKey = "f5VI9DxHtrcVfeOcGyk7a0ZRqoZYOZ3hZ7N7M8cwOZlc"
    let version = "2019-01-20"
    var classificationResults = [String]()
    
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        imagePicker.sourceType = .savedPhotosAlbum // change to camera later
        imagePicker.allowsEditing = false
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            cameraButton.isEnabled = false
            
            imageView.image = image
            imagePicker.dismiss(animated: true, completion: nil)
            
            let visualRecognition = VisualRecognition(version: version, apiKey: apiKey)
            let imageData = image.jpegData(compressionQuality: 0.01)
            let compressedImage = UIImage(data: imageData!)
            
            if let finalImage = compressedImage {
                visualRecognition.classify(image: finalImage) { (classifiedImages, error) in
                    let classes = classifiedImages?.result?.images.first?.classifiers.first?.classes
                    
                    self.classificationResults = []
                    
                    for index in 0..<classes!.count {
                        self.classificationResults.append((classes?[index].className)!)
                    }
                    print(self.classificationResults)
                    
                    DispatchQueue.main.async {
                        self.cameraButton.isEnabled = true
                    }
                    
                    if self.classificationResults.contains("hotdog") {
                        DispatchQueue.main.async {
                            self.navigationItem.title = "Hotdog!"
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.navigationItem.title = "Not Hotdog!"
                        }
                    }
                }
            }else {
                print("eror compressing image")
            }
        } else {
            print("There was an error picking the image.")
        }
    }
}

