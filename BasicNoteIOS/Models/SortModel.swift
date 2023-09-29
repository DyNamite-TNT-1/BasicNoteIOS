//
//  SortModel.swift
//  BasicNoteIOS
//
//  Created by hanbiro on 9/13/23.
//

import Foundation
struct SortModel {
    var id = UUID()
//    var imageName: String
    var title: String
    var type: Int // 1: title, 2: date, 3: remind
    var order: Int // -1: desc, 1: asc
    var isSelected: Bool = false
    
    static let example = SortModel(title: "Date Desc", type: 2, order: -1)
}
