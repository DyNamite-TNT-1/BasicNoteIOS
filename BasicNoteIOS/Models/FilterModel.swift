//
//  FilterData.swift
//  BasicNoteIOS
//
//  Created by hanbiro - ANHDUC on 9/12/23.
//

import Foundation
import SwiftUI

struct FilterModel: Identifiable, Codable {
    let id: String
    let imageName: String
    let title: String
    let description: String
    let type: Int //0: remind date(only-today/all day), -1: undone, 1: done
    var isSelected: Bool = false
    
    init(id: String = UUID().uuidString, imageName: String, title: String, description: String, type: Int, isSelected: Bool = false) {
        self.id = id
        self.title = title
        self.description = description
        self.imageName = imageName
        self.type = type
        self.isSelected = isSelected
    }
    
    static let remindDate = FilterModel(imageName: "bookmark.circle", title: "today_filter_title_str", description: "today_filter_subtitle_str", type: 0)
    static let undone = FilterModel(imageName: "checkmark.circle", title: "done_filter_title_str", description: "done_filter_subtitle_str", type: 1)
    static let done =  FilterModel(imageName: "circle", title: "undone_filter_title_str", description: "undone_filter_subtitle_str",type: -1)
    
    func localizedTitle() -> LocalizedStringKey {
        return LocalizedStringKey(self.title);
    }
    
    func localizedDescription() -> LocalizedStringKey {
        return LocalizedStringKey(self.description);
    }
}

