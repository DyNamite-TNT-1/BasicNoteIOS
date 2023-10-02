//
//  FilterData.swift
//  BasicNoteIOS
//
//  Created by hanbiro - ANHDUC on 9/12/23.
//

import Foundation

struct FilterModel: Identifiable, Codable {
    //id will be renewed whenever open app(caused by UUID). So, you need to use it carefully.
    let id: String
    let imageName: String
    let title: String
    let type: Int//0: only today or all day, -1: undone, 1: done
    var isSelected: Bool = false
    
    init(id: String = UUID().uuidString, imageName: String, title: String, type: Int, isSelected: Bool = false) {
        self.id = id
        self.title = title
        self.imageName = imageName
        self.type = type
        self.isSelected = isSelected
    }
    
    static let example = FilterModel(imageName: "bookmark.circle", title: "Today", type: 0)
}

