//
//  ProfileTVS1C1.swift
//  ChatApp
//
//  Created by Aboody on 01/08/2021.
//

import UIKit
import Gallery
import ProgressHUD

class EditProfileTVS1C1: UITableViewCell {

    //MARK: - IBOutlets
    @IBOutlet weak var avatarImageView: UIImageView!
    
    //MARK: - Constants
    var gallery: GalleryController!
    var editProfile = EditProfileTVC()
    
    //MARK: - View LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: - IBActions
    @IBAction func editButtonPressed(_ sender: UIButton) {
        showImageGallery()
    }
    
    //MARK: - Helpers Functions
    private func showImageGallery() {
        self.gallery = GalleryController()
        self.gallery.delegate = self
        Config.tabsToShow = [.imageTab, .cameraTab]
        Config.Camera.imageLimit = 1
        Config.initialTab = .imageTab
        gallery.modalPresentationStyle = .fullScreen
        editProfile.present(gallery, animated: true, completion: nil)
    }
    
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

extension EditProfileTVS1C1: GalleryControllerDelegate {
    
    //MARK: - Gallery Functions
    func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
        if images.count > 0 {
            images.first!.resolve { (avatarImage) in
                if avatarImage != nil {
                    self.uploadAvatarImage(avatarImage!)
                    self.avatarImageView.image = avatarImage?.circleMasked
                    controller.dismiss(animated: true, completion: nil)
                } else {
                    ProgressHUD.showError("Couldn't select image!")
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
