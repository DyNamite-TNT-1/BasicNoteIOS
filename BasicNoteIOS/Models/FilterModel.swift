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
    var type: Int//0: only today or all day, -1: undone, 1: done
    
    static let example = FilterModel(imageName: "bookmark.circle", title: "Today", type: 0)
}

