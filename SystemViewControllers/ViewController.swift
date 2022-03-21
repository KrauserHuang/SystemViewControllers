//
//  ViewController.swift
//  SystemViewControllers
//
//  Created by Tai Chin Huang on 2022/3/18.
//

import UIKit
import SafariServices
import MessageUI

class ViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func shareButtonTapped(_ sender: UIButton) {
        guard let image = imageView.image else { return }
        let activityController = UIActivityViewController(activityItems: [image, "share this image with you"], applicationActivities: nil)
        // for iPad, must have a non-nil sourceView, or barButtonItem set before presentation occurs
        activityController.popoverPresentationController?.sourceView = sender
        present(activityController, animated: true, completion: nil)
    }
    @IBAction func safariButtonTapped(_ sender: UIButton) {
        if let url = URL(string: "https://www.apple.com") {
            let safariViewController = SFSafariViewController(url: url)
            present(safariViewController, animated: true, completion: nil)
        }
    }
    @IBAction func cameraButtonTapped(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        let alertController = UIAlertController(title: "Choose Image Source", message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Camera", style: .default) { action in
                print("User selected Camera action")
                imagePicker.sourceType = .camera
                self.present(imagePicker, animated: true, completion: nil)
            }
            alertController.addAction(cameraAction)
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) { action in
                print("User selected Photo Library action")
                imagePicker.sourceType = .photoLibrary
                self.present(imagePicker, animated: true, completion: nil)
            }
            alertController.addAction(photoLibraryAction)
        }
        
        alertController.popoverPresentationController?.sourceView = sender
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func emailButtonTapped(_ sender: UIButton) {
        guard MFMailComposeViewController.canSendMail() else {
            print("Can not send mail")
            return
        }
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self
        // items you need to set for composeVC
        composeVC.setSubject("Welcome")
        composeVC.setToRecipients(["emaple@example.com"])
        composeVC.setMessageBody("Hello, this is the app I made", isHTML: false)
        
        if let image = imageView.image,
           let jpegData = image.jpegData(compressionQuality: 0.9) {
            composeVC.addAttachmentData(jpegData, mimeType: "image/jpeg", fileName: "photo.jpg")
        }
        
        present(composeVC, animated: true, completion: nil)
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // delegate for user finish picking image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // due to info key type is any, if you want to get image type you need to downcast to UIImage
        guard let selectedImage = info[.originalImage] as? UIImage else { return }
        imageView.image = selectedImage
        dismiss(animated: true, completion: nil)
    }
}

extension ViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        // Dismiss the mail compose view controller.
        dismiss(animated: true, completion: nil)
    }
}
