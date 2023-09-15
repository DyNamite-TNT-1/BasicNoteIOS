//
//  NoteModel.swift
//  BasicNoteIOS
//
//  Created by hanbiro - ANHDUC on 9/6/23.
//

import Foundation

//Immutable Struct
struct NoteModel: Identifiable, Codable {
    let id: String
    let title: String
    let desctiption: String
    let createDate: Date
    let isCompleted: Bool
    let image: Data?
    
    init(id: String = UUID().uuidString, title: String, desctiption: String, createDate: Date, isCompleted: Bool, image: Data?) {
        self.id = id
        self.title = title
        self.desctiption = desctiption
        self.createDate = createDate
        self.isCompleted = isCompleted
        self.image = image
    }
    
    static let exampleUndone = NoteModel(title: "First Note!", desctiption: "This is description! You need to do follow step by step. If not, you will fail. First, do step one. Then, do step two.", createDate: Date(), isCompleted: false, image: nil)
    
    static let exampleDone = NoteModel(title: "First Note!", desctiption: "This is description! You need to do follow step by step. If not, you will fail. First, do step one. Then, do step two.", createDate: Date(), isCompleted: true, image: nil)
    
    func updateCompletion() -> NoteModel {
        return NoteModel(id: id, title: title, desctiption: desctiption, createDate:  createDate, isCompleted: !isCompleted, image: image)
    }
    
    func chooseThis(onlyToday:Bool) -> Bool{
        if (!onlyToday) {
            return true
        }
        let relativeDateFormatter = DateFormatter()
        relativeDateFormatter.timeStyle = .none
        relativeDateFormatter.dateStyle = .medium
        relativeDateFormatter.locale = Locale(identifier: "en_GB")
        relativeDateFormatter.doesRelativeDateFormatting = true
        if (onlyToday && relativeDateFormatter.string(from: self.createDate) == "Today"){
            return true
        }
        return false
    }
    
    func chooseThis(isCompleted: Bool) -> Bool {
        return self.isCompleted && self.isCompleted == isCompleted
    }
    
    func chooseThis(isIncompleted: Bool) -> Bool {
        return !self.isCompleted && !self.isCompleted == isIncompleted
    }
    
    func chooseThis(onlyToday:Bool, isCompleted: Bool, isIncompleted: Bool) -> Bool {
        switch (onlyToday, isCompleted, isIncompleted) {
        case (true, false, false):
            return chooseThis(onlyToday: true)
        case (false, true, false):
            return chooseThis(isCompleted: true)
        case (false, false, true):
            return chooseThis(isIncompleted: true)
        case (true, true, true):
            return chooseThis(onlyToday: true)
        case (false, false, false):
            return true
        default:
            return chooseThis(onlyToday: onlyToday) && (chooseThis(isCompleted: isCompleted) || chooseThis(isIncompleted: isIncompleted))
        }
    }
}
