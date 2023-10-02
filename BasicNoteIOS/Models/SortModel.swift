//
//  SortModel.swift
//  BasicNoteIOS
//
//  Created by hanbiro on 9/13/23.
//

import Foundation
struct SortModel: Identifiable, Codable {
    //id will be renewed whenever open app(caused by UUID). So, you need to use it carefully.
    let id: String
    let title: String
    let type: Int // 1: title, 2: date, 3: remind
    let order: Int // -1: desc, 1: asc
    var isSelected: Bool = false
    
    init(id: String = UUID().uuidString, title: String, type: Int, order: Int, isSelected: Bool = false) {
        self.id = id
        self.title = title
        self.type = type
        self.order = order
        self.isSelected = isSelected
    }
    
    static let example = SortModel(title: "Date Desc", type: 2, order: -1)
}
