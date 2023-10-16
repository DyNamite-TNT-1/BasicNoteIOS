//
//  LanguageModel.swift
//  BasicNoteIOS
//
//  Created by hanbiro on 10/13/23.
//

import Foundation

struct LanguageModel: Identifiable, Codable, Equatable {
    let id: String
    let title: String
    let value: String
    
    init(id: String = UUID().uuidString, title: String, value: String) {
        self.id = id
        self.title = title
        self.value = value
    }
    
    static let langVI = LanguageModel(title: "VietNam", value: "vi")
    static let langEN = LanguageModel(title: "English", value: "en")
}
