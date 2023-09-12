//
//  FilterData.swift
//  BasicNoteIOS
//
//  Created by hanbiro - ANHDUC on 9/12/23.
//

import Foundation

struct FilterData: Identifiable {
    var id = UUID()
    var imageName: String
    var title: String
    var isSelected: Bool = false
    
    static let example = FilterData(imageName: "airplane", title: "Travel")
}

