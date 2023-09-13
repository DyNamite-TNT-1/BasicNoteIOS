//
//  FilterData.swift
//  BasicNoteIOS
//
//  Created by hanbiro - ANHDUC on 9/12/23.
//

import Foundation

struct FilterModel: Identifiable {
    var id = UUID()
    var imageName: String
    var title: String
    var isSelected: Bool = false
    
    static let example = FilterModel(imageName: "airplane", title: "Travel")
}

