//
//  PriorityEnum.swift
//  BasicNoteIOS
//
//  Created by hanbiro on 10/6/23.
//

import Foundation

enum Priority: String, Codable, CaseIterable {
    case none = "Không có"
    case low = "Thấp"
    case medium = "Trung bình"
    case high = "Cao"
}
    
