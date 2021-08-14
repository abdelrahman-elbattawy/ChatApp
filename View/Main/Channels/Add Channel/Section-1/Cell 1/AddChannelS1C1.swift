//
//  AddChannelS1C1.swift
//  ChatApp
//
//  Created by Aboody on 12/08/2021.
//

import UIKit
import Gallery
import ProgressHUD

class AddChannelS1C1: UITableViewCell {
    
    //MARK: - IBOutlets
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var channelNameTextField: UITextField!
    
    //MARK: - Vars
    var gallery: GalleryController!
    var channelProfileTVC = ChannleProfileTVC()
    
    //MARK: - View LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: - Gallery
    private func showGallery() {
        
        self.gallery = GalleryController()
        self.gallery.delegate = self
        Config.tabsToShow = [.imageTab, .cameraTab]
        Config.Camera.imageLimit = 1
        Config.initialTab = .imageTab
        gallery.modalPresentationStyle = .fullScreen
        channelProfileTVC.present(gallery, animated: true, completion: nil)
    }
    
    //MARK: - Helper Functions
    private func uploadAvatarImage(_ image: UIImage) {
        let fileDirectory = "Avatars/" + "_\(User.currentId)" + ".jpg"
        FileStorage.uploadImage(image, directory: fileDirectory) { (avatarLink) in
            if var user = User.currentUser {
                user.avatarLink = avatarLink ?? ""
                saveUserLocally(user)
                FirebaseUserListener.shared.saveUserToFireStore(user)
            }
            FileStorage.saveFileLocally(fileData: image.jpegData(compressionQuality: 1.0)! as NSData, fileName: User.currentId)
        }
    }
}

extension AddChannelS1C1: GalleryControllerDelegate {
    
    //MARK: - Gallery Delegates
    func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
        
        if images.count > 0 {
            
            images.first!.resolve { (icon) in
                
                if icon != nil {
                    
                    self.uploadAvatarImage(icon!)
                    self.avatarImageView.image = icon!.circleMasked
                } else {
                    ProgressHUD.showFailed("Couldn't select image!")
                }
            }
        }
    }
    
    func galleryController(_ controller: GalleryController, didSelectVideo video: Video) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryController(_ controller: GalleryController, requestLightbox images: [Image]) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryControllerDidCancel(_ controller: GalleryController) {
        controller.dismiss(animated: true, completion: nil)
    }
}
