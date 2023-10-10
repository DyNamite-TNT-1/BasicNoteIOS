//
//  PriorityEnum.swift
//  BasicNoteIOS
//
//  Created by hanbiro on 10/6/23.
//

import Foundation

enum Priority: String, Codable, CaseIterable {
    case none = "none_str"
    case low = "low_str"
    case medium = "medium_str"
    case high = "high_str"
    
    func localizedString() -> String {
            return NSLocalizedString(self.rawValue, comment: "")
        }
}
    
