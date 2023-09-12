//
//  ListViewModel.swift
//  BasicNoteIOS
//
//  Created by hanbiro on 9/6/23.
//

import Foundation
import SwiftUI
/*
 CRUD FUNCTIONS
 
 Create
 Read
 Update
 Delete
 
 */

class MainViewModel: ObservableObject {
    //[items] are real items that is saved to and retrieved from local storage(UserDefaults)
    @Published var items: [NoteModel] = [] {
        didSet {//didSet is called whether items is changed
            saveItem()
        }
    }
    /*
     [renderItems] are the items from [items] that will be displayed on UI.
     It can be all or some, or even none, depending on the user's actions.
     Like: adding, deleting, reading all, searching, filtering...
     */
    @Published var renderItems: [NoteModel] = []
    
    let itemsKey: String = "items_list"
    
    var filterDatas = [
        FilterData(imageName: "airplane", title: "Travel"),
        FilterData(imageName: "tag.fill", title: "Price"),
        FilterData(imageName: "bed.double.fill", title: "Product"),
        FilterData(imageName: "car.fill", title: "Vehicle"),
    ]
    
    @Published var selection = [FilterData]()
    
    init() {
        getItems()
    }
    
    func getItems() {
        guard
            let data = UserDefaults.standard.data(forKey: itemsKey),
            let savedItems = try? JSONDecoder().decode([NoteModel].self, from: data)
        else { return }
        self.items = savedItems
        self.renderItems = self.items
    }
    
    func deleteItem(indexSet: IndexSet) {
        items.remove(atOffsets: indexSet)
        self.renderItems = self.items
    }
    
    func moveItem(from: IndexSet, to: Int) {
        items.move(fromOffsets: from, toOffset: to);
        self.renderItems = self.items
    }
    
    func addItem(title: String, description: String, createDate: Date, image: Data? = nil) {
        let newItem = NoteModel(title: title, desctiption: description, createDate: createDate, isCompleted: false, image: image)
        items.append(newItem)
        self.renderItems = self.items
    }
    
    /*
     When toggle done/undone, no need to re-assign the whole [items] to [renderItems].
     Instead, update the item if the item is in [renderItems].
     */
    func updateItem(item: NoteModel) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index] = item.updateCompletion()
        }
        if let index = renderItems.firstIndex(where: { $0.id == item.id }) {
            renderItems[index] = item.updateCompletion()
        }
    }
    
    func saveItem() {
        if let encodedData = try? JSONEncoder().encode(items) {
            UserDefaults.standard.set(encodedData, forKey: itemsKey)
        }
    }
    
    func searchItems(query: String) {
        let lowerQuery = query.lowercased()
        self.renderItems = query.isEmpty ? self.items : self.items.filter({ item in
            item.title.lowercased().contains(lowerQuery) || item.desctiption.lowercased().contains(lowerQuery)
        })
    }
    
    //remakes the published selection list
    private func refreshSelection() {
        let result = filterDatas.filter { filter in
            filter.isSelected
        }
        withAnimation {
            selection = result
        }
    }
    
    //toggle the selection of the filter at the given index
    func toggleFilter(at index: Int) {
        guard index >= 0 && index < filterDatas.count else { return }
        filterDatas[index].isSelected.toggle()
        refreshSelection()
    }
    
    //clears the selected filters
    func clearSelection() {
        for index in 0..<filterDatas.count {
            filterDatas[index].isSelected = false
        }
        refreshSelection()
    }
}
