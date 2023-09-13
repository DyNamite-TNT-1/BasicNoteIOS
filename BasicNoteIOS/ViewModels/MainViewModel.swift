//
//  MainViewModel.swift
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
        FilterModel(imageName: "airplane", title: "Travel"),
        FilterModel(imageName: "tag.fill", title: "Price"),
        FilterModel(imageName: "bed.double.fill", title: "Product"),
        FilterModel(imageName: "car.fill", title: "Vehicle"),
    ]
    
    @Published var filterSelections = [FilterModel]()
    
    var sortDatas = [
//        SortModel(title: "None", type: 0, order: 0),
        SortModel(title: "Title Asc", type: 1, order: 1),
        SortModel(title: "Title Desc", type: 1, order: -1),
        SortModel(title: "Date Asc", type: 2, order: 1),
        SortModel(title: "Date Desc", type: 2, order: -1, isSelected:  true),
    ]
    
    @Published var sortSelection: SortModel = SortModel.example
    
    init() {
        getItems()
    }
    
    func getItems() {
        guard
            let data = UserDefaults.standard.data(forKey: itemsKey),
            let savedItems = try? JSONDecoder().decode([NoteModel].self, from: data)
        else { return }
        self.items = savedItems
        self.sortSelection = self.sortDatas.first(where: { $0.type == 2 && $0.order == -1}) ?? SortModel(title: "Date Desc", type: 2, order: -1) //init sort by date desc
        refreshRenderItem()
    }
    
    func refreshRenderItem() {
        self.renderItems = self.items.sorted(by: {
            sortByThis(firstNote: $0, secondNote: $1)
        })
    }
    
    /*
     Because delete item on renderItem(UI), so firstly, find the item on [items], then delete on [items]
     */
    func deleteItem(indexSet: IndexSet) {
        indexSet.forEach { index in
            items.remove(at: items.firstIndex(where: {
                $0.id == renderItems[index].id
            })!)
        }
        refreshRenderItem()
    }
    
    /*
     This func not correct, since the sorting feature was added.
     Previously, this feature was made to learn swiftui. So, this no need in business.
     Solutions:
        + Remove this forever.
        + Add a new sorter called "None". If move item, apply this sorter.
     Last updated: temporarily, disable this to update later.
     */
    func moveItem(from: IndexSet, to: Int) {
        items.move(fromOffsets: from, toOffset: to);
        self.renderItems = self.items
    }
    
    func addItem(title: String, description: String, createDate: Date, image: Data? = nil) {
        let newItem = NoteModel(title: title, desctiption: description, createDate: createDate, isCompleted: false, image: image)
        items.append(newItem)
        refreshRenderItem()
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
        let tmpItems: [NoteModel] = query.isEmpty ? self.items : self.items.filter({ item in
            item.title.lowercased().contains(lowerQuery) || item.desctiption.lowercased().contains(lowerQuery)
        })
        self.renderItems = tmpItems.sorted(by: {
            sortByThis(firstNote: $0, secondNote: $1)
        })
    }
    
    //remakes the published filter selection list
    private func refreshFilterSelection() {
        let result = filterDatas.filter { filter in
            filter.isSelected
        }
        withAnimation {
            filterSelections = result
        }
    }
    
    //toggle the selection of the filter at the given index
    func toggleFilter(at index: Int) {
        guard index >= 0 && index < filterDatas.count else { return }
        filterDatas[index].isSelected.toggle()
        refreshFilterSelection()
    }
    
    //clears the selected filters
    func clearSelection() {
        for index in 0..<filterDatas.count {
            filterDatas[index].isSelected = false
        }
        refreshFilterSelection()
    }
    
    //remakes the published sort selection
    private func refreshSortSelection() {
        let result = sortDatas.first { sort in
            sort.isSelected
        }
        withAnimation {
            sortSelection = result!
        }
    }
    
    //toggle ONE selection of the sort at the given index
    func toggleSort(at index: Int) {
        guard index >= 0 && index < sortDatas.count else { return }
        for index in 0..<sortDatas.count {
            sortDatas[index].isSelected = false
        }
        sortDatas[index].isSelected.toggle()
        refreshSortSelection()
        refreshRenderItem()
    }
    
    private func sortByThis(firstNote: NoteModel, secondNote: NoteModel) -> Bool {
        switch (self.sortSelection.type, self.sortSelection.order) {
        case (1, 1):
            return firstNote.title.lowercased() < secondNote.title.lowercased()
        case (1, -1):
            return firstNote.title.lowercased() > secondNote.title.lowercased()
        case (2, 1):
            return firstNote.createDate < secondNote.createDate
        case (2, -1):
            return firstNote.createDate > secondNote.createDate
        default:
            return firstNote.createDate > secondNote.createDate
        }
    }
}
