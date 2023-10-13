//
//  PriorityEnum.swift
//  BasicNoteIOS
//
//  Created by hanbiro - ANHDUC on 10/6/23.
//

import Foundation
import SwiftUI

enum Priority: String, Codable, CaseIterable {
    case none = "none_str"
    case low = "low_str"
    case medium = "medium_str"
    case high = "high_str"
    
    func localizedString() -> LocalizedStringKey {
        return LocalizedStringKey(self.rawValue)
    }
}
    
