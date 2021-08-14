//
//  GlobalFunctions.swift
//  ChatApp
//
//  Created by Aboody on 02/08/2021.
//

import UIKit
import AVFoundation

func fileNameFrom(fileURL: String) -> String {
    
    let name = ((fileURL
                    .components(separatedBy: "_").last)?
                    .components(separatedBy: "?").first)?
                    .components(separatedBy: ".").first
    return name!
}

func timeElapsed(_ date: Date) -> String {
    
    let seconds = Date().timeIntervalSince(date)
    
    var elapsed = ""
    
    if seconds < 60 {
        elapsed = "Just now"
    } else if seconds < 60 * 60 {
        
        let minutes = Int(seconds / 60)
        let minText = minutes > 1 ? "mins" : "min"
        elapsed = "\(minutes) \(minText)"
        
    } else if seconds < 24 * 60 * 60 {
        
        let hours = Int(seconds / (60 * 60))
        let houtText = hours > 1 ? "hours" : "hour"
        elapsed = "\(hours) \(houtText)"
        
    } else {
        elapsed = date.longDate()
    }
    
    return elapsed
}

func vidoeThumbnail(video: URL) -> UIImage {
    
    let asset = AVURLAsset(url: video, options: nil)
    let imageGenerator = AVAssetImageGenerator(asset: asset)
    imageGenerator.appliesPreferredTrackTransform = true
    
    let time = CMTimeMakeWithSeconds(0.5, preferredTimescale: 1000)
    var actualTime = CMTime.zero
    
    var image: CGImage?
    
    do {
        image = try imageGenerator.copyCGImage(at: time, actualTime: &actualTime)
        
    } catch let error as NSError {
        print("error making thumbnail:", error.localizedDescription)
    }
    
    if image != nil {
        return UIImage(cgImage: image!)
    }
    
    return UIImage(named: "photoPlaceholder")!
}
