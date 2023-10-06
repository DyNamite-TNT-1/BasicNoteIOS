//
//  FilterData.swift
//  BasicNoteIOS
//
//  Created by hanbiro - ANHDUC on 9/12/23.
//

import Foundation

struct FilterModel: Identifiable, Codable {
    let id: String
    let imageName: String
    let title: String
    let description: String
    let type: Int//0: remind date(only-today/all day), -1: undone, 1: done
    var isSelected: Bool = false
    
    init(id: String = UUID().uuidString, imageName: String, title: String, description: String, type: Int, isSelected: Bool = false) {
        self.id = id
        self.title = title
        self.description = description
        self.imageName = imageName
        self.type = type
        self.isSelected = isSelected
    }
    
    static let example = FilterModel(imageName: "bookmark.circle", title: "Today", description: "Notes that their's remind is today", type: 0)
}

