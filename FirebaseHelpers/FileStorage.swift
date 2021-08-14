//
//  FileStorage.swift
//  ChatApp
//
//  Created by Aboody on 02/08/2021.
//

import Foundation
import FirebaseStorage
import ProgressHUD

//MARK: - Constants
let storage = Storage.storage()

class FileStorage {
    
    //MARK: - Images
    class func uploadImage(_ image: UIImage, directory: String, completion: @escaping (_ doucmentLink: String?) -> Void) {
        
        let storageRef = storage.reference(forURL: kFILEREFRENCE).child(directory)
        let imageData = image.jpegData(compressionQuality: 0.6)
        var task: StorageUploadTask!
        task = storageRef.putData(imageData!, metadata: nil, completion: { (metadata, error) in
            task.removeAllObservers()
            ProgressHUD.dismiss()
            
            if error != nil {
                print("error uploading image \(error?.localizedDescription ?? "")")
                return
            }
            
            storageRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    completion(nil)
                    return
                }
                
                completion(downloadURL.absoluteString)
            }
        })
        
        task.observe(StorageTaskStatus.progress) { (snapshot) in
            let progress = snapshot.progress!.completedUnitCount / snapshot.progress!.totalUnitCount
            ProgressHUD.showProgress(CGFloat(progress))
        }
    }
    
    class func downloadImage(imageURL: String, completion: @escaping (_ image: UIImage?) -> Void) {
        
        let imageFileName = fileNameFrom(fileURL: imageURL)
        if fileExistsAtPath(path: imageFileName) {
            if let contentOfFile = UIImage(contentsOfFile: fileInDocumentsDirectory(fileName: imageFileName)) {
                completion(contentOfFile)
            } else {
                print("couldn't convert local image")
                completion(UIImage(named: "avatar"))
            }
        } else {
            if imageURL != "" {
                let documentURL = URL(string: imageURL)
                let downloadQueue = DispatchQueue(label: "imageDownloadQueue")
                downloadQueue.async {
                    let data = NSData(contentsOf: documentURL!)
                    if data != nil {
                        FileStorage.saveFileLocally(fileData: data!, fileName: imageFileName)
                        DispatchQueue.main.async {
                            completion(UIImage(data: data! as Data))
                        }
                    } else {
                        print("no document in database")
                        DispatchQueue.main.async {
                            completion(UIImage(named: "avatar"))
                        }
                    }
                }
            }
        }
    }
    
    //MARK: - Video
    class func uploadVideo(_ video: NSData, directory: String, completion: @escaping (_ videoLink: String?) -> Void) {
        
        let storageRef = storage.reference(forURL: kFILEREFRENCE).child(directory)
        
        var task: StorageUploadTask!
        
        task = storageRef.putData(video as Data, metadata: nil, completion: { (metadata, error) in
            
            task.removeAllObservers()
            ProgressHUD.dismiss()
            
            if error != nil {
                print("error uploading video \(error?.localizedDescription ?? "")")
                return
            }
            
            storageRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    completion(nil)
                    return
                }
                
                completion(downloadURL.absoluteString)
            }
        })
        
        task.observe(StorageTaskStatus.progress) { (snapshot) in
            let progress = snapshot.progress!.completedUnitCount / snapshot.progress!.totalUnitCount
            ProgressHUD.showProgress(CGFloat(progress))
        }
    }
    
    class func downloadVideo(videoLink: String, completion: @escaping (_ isReadyToPlay: Bool?,_ videoFileName: String) -> Void) {
        
        let videoURL = URL(string: videoLink)
        let videoFileName = fileNameFrom(fileURL: videoLink) + ".mov"
        
        if fileExistsAtPath(path: videoFileName) {
            
            completion(true, videoFileName)
            
        } else {
            
            let downloadQueue = DispatchQueue(label: "videoDownloadQueue")
            
            downloadQueue.async {
                
                let data = NSData(contentsOf: videoURL!)
                
                if data != nil {
                    
                    FileStorage.saveFileLocally(fileData: data!, fileName: videoFileName)
                    
                    DispatchQueue.main.async {
                        completion(true, videoFileName)
                    }
                    
                } else {
                    print("no document in database")
                }
            }
        }
    }
    
    //MARK: - Audio
    class func uploadAudio(_ audioFileName: String, directory: String, completion: @escaping (_ audioLink: String?) -> Void) {
        
        let fileName = audioFileName + ".m4a"
        
        let storageRef = storage.reference(forURL: kFILEREFRENCE).child(directory)
        
        var task: StorageUploadTask!
                
        if fileExistsAtPath(path: fileName) {
            
            if let audioData = NSData(contentsOfFile: fileInDocumentsDirectory(fileName: fileName)) {
                
                task = storageRef.putData(audioData as Data, metadata: nil, completion: { (metadata, error) in
                    
                    task.removeAllObservers()
                    ProgressHUD.dismiss()
                    
                    if error != nil {
                        print("error uploading audio \(error?.localizedDescription ?? "")")
                        return
                    }
                    
                    storageRef.downloadURL { (url, error) in
                        guard let downloadURL = url else {
                            completion(nil)
                            return
                        }
                        
                        completion(downloadURL.absoluteString)
                    }
                })
                
                task.observe(StorageTaskStatus.progress) { (snapshot) in
                    let progress = snapshot.progress!.completedUnitCount / snapshot.progress!.totalUnitCount
                    ProgressHUD.showProgress(CGFloat(progress))
                }
            } else {
                print("nothing to upload (audio)")
            }
        }
    }
    
    class func downloadAudio(audioLink: String, completion: @escaping (_ audioFileName: String) -> Void) {
        
        let audioFileName = fileNameFrom(fileURL: audioLink) + ".m4a"
        
        if fileExistsAtPath(path: audioFileName) {
            
            completion(audioFileName)
            
        } else {
            
            let downloadQueue = DispatchQueue(label: "AudioDownloadQueue")
            
            downloadQueue.async {
                
                let data = NSData(contentsOf: URL(string: audioLink)!)
                
                if data != nil {
                    
                    FileStorage.saveFileLocally(fileData: data!, fileName: audioFileName)
                    
                    DispatchQueue.main.async {
                        completion(audioFileName)
                    }
                    
                } else {
                    print("no document in database audio")
                }
            }
        }
    }
    
    //MARK: - Save Locally
    class func saveFileLocally(fileData: NSData, fileName: String) {
        
        let docURL = getDocumentsURL().appendingPathComponent(fileName, isDirectory: false)
        fileData.write(to: docURL, atomically: true)
    }
}

//MARK: - Helpers Functions
func fileInDocumentsDirectory(fileName: String) -> String {
    return getDocumentsURL().appendingPathComponent(fileName).path
}

func getDocumentsURL() -> URL {
    return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!
}

func fileExistsAtPath(path: String) -> Bool {
    
    let filePath = fileInDocumentsDirectory(fileName: path)
    let fileManager = FileManager.default
    
    return fileManager.fileExists(atPath: filePath)
}
