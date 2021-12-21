//
//  AddPhotoViewController.swift
//  oneday-syhien
//
//  Created by nju on 2021/12/21.
//

import UIKit

class AddPhotoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var photos: Photos?
    let photoPicker = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        photoPicker.delegate = self
        photoPicker.sourceType = .photoLibrary
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        photos = appDelegate.photos!
    }
    

    @IBAction func addPhoto(_ sender: UIButton) {
        present(photoPicker, animated: true)
    }
    
    // MARK: - UIImagePickerControllerDelegate Methods

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            photos?.addImage(newImage: pickedImage)
        }
        dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
