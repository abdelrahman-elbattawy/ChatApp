//
//  Date+Extensions.swift
//  ChatApp
//
//  Created by Aboody on 05/08/2021.
//

import UIKit

extension Date {
    
    func longDate() -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        return dateFormatter.string(from: self)
    }
    
    func stringDate() -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "ddMMMyyyyHHmmss"
        return dateFormatter.string(from: self)
    }
    
    func time() -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: self)
    }
    
    func interval(ofComponent comp: Calendar.Component, from date: Date) -> Float {
        
        let currentCalender = Calendar.current
        
        guard  let start = currentCalender.ordinality(of: comp, in: .era, for: date) else { return 0 }
        guard  let end = currentCalender.ordinality(of: comp, in: .era, for: self) else { return 0 }

        return Float(start - end)
    }
}
