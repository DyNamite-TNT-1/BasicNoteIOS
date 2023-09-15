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
        FilterModel(imageName: "bookmark.circle", title: "Today", type: 0),
        FilterModel(imageName: "checkmark.circle", title: "Done", type: 1),
        FilterModel(imageName: "circle", title: "Undone", type: -1),
    ]
    
    @Published var filterSelections = [FilterModel]()
    
    var prevFilterSelections = [FilterModel]()
    
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
    
    func saveItem() {
        if let encodedData = try? JSONEncoder().encode(items) {
            UserDefaults.standard.set(encodedData, forKey: itemsKey)
        }
    }
    
    func refreshRenderItem(notUseParamNotes: Bool = true, notes: [NoteModel] = []) {
        if (notUseParamNotes) {
            self.renderItems = self.items.sorted(by: {
                sortByThis(firstNote: $0, secondNote: $1)
            })
        } else {
            self.renderItems = notes.sorted(by: {
                sortByThis(firstNote: $0, secondNote: $1)
            })
        }
    }
    
    ///To delete Item at specificed positions.
    ///- Parameters:
    ///     - indexSet: set of index of the items.
    ///
    ///Because delete item of `renderItems` is just on UI, so firstly, find and delete that item in `items`, then refresh `renderItems`
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
    
    /// To update from completed to incomplete, and vice versa.
    /// - Parameters:
    ///     - item: specific item that will be updated.
    func updateItem(item: NoteModel) {
        /*
         When toggle done/undone, no need to re-assign the whole [items] to [renderItems].
         Instead, update the item if the item is in [renderItems].
         */
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index] = item.updateCompletion()
        }
        if let index = renderItems.firstIndex(where: { $0.id == item.id }) {
            renderItems[index] = item.updateCompletion()
        }
    }
    
    /// To find all items that contain input query.
    /// - Parameters:
    ///     - query: content you want to search for .
    func searchItems(query: String) {
        let lowerQuery = query.lowercased()
        /// Use [tmpItems] to save the items that contain `[query]`. After that, refresh [renderItems] by [tmpItems]
        let tmpItems: [NoteModel] = query.isEmpty ? self.items : self.items.filter({ item in
            item.title.lowercased().contains(lowerQuery) || item.desctiption.lowercased().contains(lowerQuery)
        })
        refreshRenderItem(notUseParamNotes: false, notes: tmpItems)
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
    func clearFilterSelection() {
        for index in 0..<filterDatas.count {
            filterDatas[index].isSelected = false
        }
        refreshFilterSelection()
    }
    
    func onDismissFilter() {
        filterSelections = prevFilterSelections
        for index in 0..<self.filterDatas.count {
            if (filterSelections.contains(where: {
                self.filterDatas[index].id == $0.id
            })) {
                self.filterDatas[index].isSelected = true
            } else {
                self.filterDatas[index].isSelected = false
            }
        }
    }
    
    //remakes the published sort selection
    private func refreshSortSelection() {
        let result = sortDatas.first { sort in
            sort.isSelected
        }
        sortSelection = result!
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
    
    /*
     To compare two NoteModel items by [sortSelection].
     */
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
    
    ///To filter items
    func filterItems() {
        prevFilterSelections = filterSelections
        var isToday: Bool = false
        var isCompleted: Bool = false
        var isIncompleted: Bool = false
        self.filterSelections.forEach {
            switch ($0.type){
            case -1:
                isIncompleted = true
                break
            case 0:
                isToday = true
                break
            case 1:
                isCompleted = true
                break
            default:
                break
            }
        }
        refreshRenderItem(notUseParamNotes: false, notes: self.items.filter {
            $0.chooseThis(isToday: isToday, isCompleted: isCompleted, isIncompleted: isIncompleted)
        })
    }
}
