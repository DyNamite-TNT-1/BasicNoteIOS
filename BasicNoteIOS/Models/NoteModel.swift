//
//  NoteModel.swift
//  BasicNoteIOS
//
//  Created by hanbiro on 9/6/23.
//

import Foundation

//Immutable Struct
struct NoteModel: Identifiable, Codable {
    let id: String
    let title: String
    let desctiption: String
    let createDate: Date
    let isCompleted: Bool
    
    init(id: String = UUID().uuidString, title: String, desctiption: String, createDate: Date, isCompleted: Bool) {
        self.id = id
        self.title = title
        self.desctiption = desctiption
        self.createDate = createDate
        self.isCompleted = isCompleted
    }
    
    func updateCompletion() -> NoteModel {
        return NoteModel(id: id, title: title, desctiption: desctiption, createDate:  createDate, isCompleted: !isCompleted)
    }
}
