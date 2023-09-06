//
//  ListViewModel.swift
//  BasicNoteIOS
//
//  Created by hanbiro on 9/6/23.
//

import Foundation

/*
 CRUD FUNCTIONS
 
 Create
 Read
 Update
 Delete
 
 */

class ListViewModel:ObservableObject {
    @Published var items: [NoteModel] = []
    
    init() {
        getItems()
    }
    
    func getItems() {
        let newItems = [
            NoteModel(title: "This is the first title!", isCompleted: false),
            NoteModel(title: "This is the second!", isCompleted: true),
            NoteModel(title: "Third!", isCompleted: false),
        ]
        items.append(contentsOf: newItems)
    }
    
    func deleteItem(indexSet: IndexSet) {
        items.remove(atOffsets: indexSet)
    }
    
    func moveItem(from: IndexSet, to: Int) {
        items.move(fromOffsets: from, toOffset: to);
    }
    
    func addItem(title: String) {
        let newItem = NoteModel(title: title, isCompleted: false)
        items.append(newItem)
    }
    
    func updateItem(item: NoteModel) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index] = item.updateCompletion()
        }
    }
}
