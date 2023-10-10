//
//  HomeViewModel.swift
//  BasicNoteIOS
//
//  Created by hanbiro - ANHDUC on 9/6/23.
//

import Foundation
import SwiftUI
import UserNotifications
/*
 CRUD FUNCTIONS
 
 Create
 Read
 Update
 Delete
 
 */

//HomeViewModel controls 2 views: HomeView & SettingView
class HomeViewModel: ObservableObject {
    /// `[items]` are real items that is saved to and retrieved from local storage(UserDefaults)
    @Published var items: [NoteModel] = [] {
        didSet {//didSet is called whether items is changed
            saveNeedEncodedData(key: self.itemsKey, value: self.items)
            doNotification()
        }
    }
    /**
     `[renderItems]` are the items from [items] that will be displayed on UI.
     It can be all or some, or even none, depending on the user's actions, like: adding, deleting, reading all, searching, filtering...
     */
    @Published var renderItems: [NoteModel] = []
    
    let itemsKey: String = "items_list"
    let localNotiKey:String = "localNotiKey"
    let toggleNotiKey: String = "toggleNotiKey"
    let selectedSortKey: String = "selectedSortKey"
    let selectedFiltersKey: String = "selectedFiltersKey"
    
    var filterDatas = [
        FilterModel(imageName: "bookmark.circle", title: "Today", description: "Reminders's notes are today", type: 0),
        FilterModel(imageName: "checkmark.circle", title: "Done", description: "Notes're completed", type: 1),
        FilterModel(imageName: "circle", title: "Undone", description: "Notes're incompleted",type: -1),
    ]
    
    ///`[filterSelections]` is the list of filter items that are selected by user
    @Published var filterSelections = [FilterModel]() {
        didSet{
            saveNeedEncodedData(key: selectedFiltersKey, value: filterSelections)
        }
    }
    
    var prevFilterSelections = [FilterModel]()
    
    @Published var sortDatas = [
        //        SortModel(title: "By Hand", type: 0, order: 0),
        SortModel(title: "Title Asc", type: 1, order: 1),
        SortModel(title: "Title Desc", type: 1, order: -1),
        SortModel(title: "Updated Asc", type: 2, order: 1),
        SortModel(title: "Updated Desc", type: 2, order: -1),
        SortModel(title: "Remind Asc", type: 3, order: 1),
        SortModel(title: "Remind Desc", type: 3, order: -1)
    ]
    
    ///`[sortSelection]` is one sort item that is selected by user
    @Published var sortSelection: SortModel = SortModel.example {
        didSet{
            saveNeedEncodedData(key: self.selectedSortKey, value: self.sortSelection)
        }
    }
    
    //Setting View
    ///To indicate status of Local Notification
    ///
    ///0: first time to visit app
    ///
    ///1: authorized
    ///
    ///-1: denied
    @Published var localNotiStatus: Int = 0 {
        didSet {//didSet is called whether localNotiStatus is changed
            UserDefaults.standard.set(self.localNotiStatus, forKey: self.localNotiKey)
        }
    }
    
    @Published var toggleNotiStatus: Bool = false {
        didSet {//didSet is called whether toggleNotiStatus is changed
            UserDefaults.standard.set(self.toggleNotiStatus, forKey: self.toggleNotiKey)
        }
    }
    
    init() {
        getSavedSettings()
        getItems()
    }
    
    /// To retrieve real items from local storage
    func getItems() {
        guard
            let data = UserDefaults.standard.data(forKey: self.itemsKey),
            let savedItems = try? JSONDecoder().decode([NoteModel].self, from: data)
        else { return }
        self.items = savedItems
        refreshRenderItem()
    }
    
    /// To save Data that need Encode, like: object, list objects to local storage
    private func saveNeedEncodedData<T : Encodable>(key: String, value: T) {
        if let encodedData = try? JSONEncoder().encode(value) {
            UserDefaults.standard.set(encodedData, forKey: key)
        }
    }
    
    private func getSavedSettings() {
        localNotiStatus = UserDefaults.standard.integer(forKey: self.localNotiKey)
        toggleNotiStatus = UserDefaults.standard.bool(forKey: self.toggleNotiKey)
        guard
            let data = UserDefaults.standard.data(forKey: self.selectedSortKey),
            let savedSortItem = try? JSONDecoder().decode(SortModel.self, from: data)
        else { return }
        let index = sortDatas.firstIndex(where: {
            return $0.type == savedSortItem.type && $0.order == savedSortItem.order
        })
        self.sortDatas[index ?? 3].isSelected = true
        self.sortSelection = sortDatas[index ?? 3]
        
        guard
            let data = UserDefaults.standard.data(forKey: self.selectedFiltersKey),
            let savedSelectedFilters = try? JSONDecoder().decode([FilterModel].self, from: data)
        else { return }
        savedSelectedFilters.forEach{ savedItem in
            let index = filterDatas.firstIndex {
                $0.type == savedItem.type
            }
            if (index != nil) {
                filterDatas[index!].isSelected.toggle()
            }
        }
        refreshFilterSelection(needUpdatePrevSelection: true)
    }
    
    /// To refresh `renderItems` by sort selection and filter selections
    private func refreshRenderItem() {
        var onlyToday: Bool = false
        var isCompleted: Bool = false
        var isIncompleted: Bool = false
        self.filterSelections.forEach {
            switch ($0.type){
            case -1:
                isIncompleted = true
                break
            case 0:
                onlyToday = true
                break
            case 1:
                isCompleted = true
                break
            default:
                break
            }
        }
        self.renderItems =  self.items.filter {
            $0.chooseThis(onlyToday: onlyToday, isCompleted: isCompleted, isIncompleted: isIncompleted)
        }.sorted(by: {
            sortByThis(firstNote: $0, secondNote: $1)
        })
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
     Func "moveItem" not correct, since the sorting feature was added. Don't use it.
     Previously, this feature was made to learn swiftui.
     After adding sort, filter feature. "moveItem" is conflict.
     Solutions:
     + Remove this feature forever.
     + Add a new sorter called "By hand". If move item, apply this sorter. (Refer to IOS Note App)
     Temporarily, disable this to update later.
     */
    func moveItem(from: IndexSet, to: Int) {
        items.move(fromOffsets: from, toOffset: to);
        self.renderItems = self.items
    }
    
    func addItem(title: String, description: String, createDate: Date, image: Data? = nil, isNeedRemind: Bool, remindDateTime: Date, priority: Priority) {
        let newItem = NoteModel(title: title, description: description, createDate: createDate, isCompleted: false, image: image, isNeedRemind: isNeedRemind, remindDateTime: remindDateTime, priority: priority)
        items.append(newItem)
        refreshRenderItem()
    }
    
    /// To update from completed to incomplete, and vice versa.
    /// - Parameters:
    ///     - item: specific item that will be updated.
    func toggleItemCompletion(item: NoteModel) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index] = item.updateCompletion()
        }
        refreshRenderItem()
    }
    
    func updateItem(item: NoteModel, title: String, description: String, createDate: Date, isCompleted: Bool, image: Data?, isNeedRemind: Bool, remindDateTime: Date, priority: Priority) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index] = item.updateNote(title: title, description: description, createDate: createDate, isCompleted: isCompleted, image: image, isNeedRemind: isNeedRemind, remindDateTime: remindDateTime, priority: priority)
        }
        refreshRenderItem()
    }
    
    /// To find all items that contain input query.
    /// - Parameters:
    ///     - query: content you want to search for .
    func searchItems(query: String) {
        let lowerQuery = query.lowercased()
        // Use [tmpItems] to save the items that contain [query]. After that, refresh [renderItems] by [tmpItems]
        let tmpItems: [NoteModel] = query.isEmpty ? self.items : self.items.filter({ item in
            item.title.lowercased().contains(lowerQuery) || item.description.lowercased().contains(lowerQuery)
        })
        renderItems = tmpItems.sorted(by: {
            sortByThis(firstNote: $0, secondNote: $1)
        })
    }
    
    //remakes the published filter selection list
    private func refreshFilterSelection(needUpdatePrevSelection: Bool = false) {
        let result = filterDatas.filter { filter in
            filter.isSelected
        }
        withAnimation {
            filterSelections = result
        }
        if (needUpdatePrevSelection) {
            prevFilterSelections = filterSelections
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
        case (0, 0):
            if let firstIndex = self.items.firstIndex(where: { $0.id == firstNote.id
            }),
               let secondIndex = self.items.firstIndex(where: { $0.id == secondNote.id
               }) {
                return firstIndex < secondIndex
            }
            return false
        case (1, 1):
            return firstNote.title.lowercased() < secondNote.title.lowercased()
        case (1, -1):
            return firstNote.title.lowercased() > secondNote.title.lowercased()
        case (2, 1):
            return firstNote.createDate < secondNote.createDate
        case (2, -1):
            return firstNote.createDate > secondNote.createDate
        case (3, 1):
            return firstNote.remindDateTime < secondNote.remindDateTime
        case (3, -1):
            return firstNote.remindDateTime > secondNote.remindDateTime
        default:
            return firstNote.createDate > secondNote.createDate
        }
    }
    
    ///To filter items
    func filterItems() {
        prevFilterSelections = filterSelections
        refreshRenderItem()
    }
    
    func onToggle(_ toggle: Bool) {
        self.toggleNotiStatus = toggle
        doNotification()
    }
    
    func doNotification() {
        checkPermission()
        if self.toggleNotiStatus {
            switch (self.localNotiStatus) {
            case 0:
                requestPermission()
            case 1:
                scheduleNotification()
            default:
                return
            }
        } else {
            cancelNotification()
        }
    }
    
    func checkPermission() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            if (settings.authorizationStatus == .authorized) {
                DispatchQueue.main.async {
                    self.localNotiStatus = 1
                }
            } else if (settings.authorizationStatus == .denied) {
                DispatchQueue.main.async {
                    self.localNotiStatus = -1
                }
            }
        }
    }
    
    private func requestPermission() {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            if (settings.authorizationStatus == .authorized) {
                print("Notification Permission is authorized");
            } else if (settings.authorizationStatus == .denied){
                print("Notification Permission is denied");
            }
            else {
                UNUserNotificationCenter.current().requestAuthorization(options: options) { (success, error) in
                    if (success) {
                        DispatchQueue.main.async {
                            self.localNotiStatus = 1
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.localNotiStatus = -1
                        }
                    }
                    if let error = error {
                        print("ERROR \(error)")
                    } else {
                        print("SUCCESS \(success)")
                    }
                }
            }
        }
    }
    
    func scheduleNotification() {
        //test notification
//        let content = UNMutableNotificationContent()
//        content.title = "This is my first notification!"
//        content.subtitle = "This was soooo easy!"
//        content.body = "This is body of notification."
//        content.sound = .default
//        content.badge = 1
//
//        var dateComponent = DateComponents()
//        dateComponent.hour = 9
//        dateComponent.minute = 47
//
//        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: false)
//
//        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
//        UNUserNotificationCenter.current().add(request)
        //
        UserDefaults.standard.set(0, forKey: "NotificationCountBadge")
        for index in 0..<self.items.count {
            if (self.items[index].isNeedRemind) {
                let item = self.items[index]
                let content = UNMutableNotificationContent()
                content.title = item.title
                content.body = item.description
                content.sound = .default
                let countBadge = UserDefaults.standard.integer(forKey: "NotificationCountBadge") + 1
                UserDefaults.standard.set(countBadge, forKey: "NotificationCountBadge")
                content.badge = countBadge as NSNumber
                
                //remove notification with the same id, to update it.
                UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [item.id])
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [item.id])
                
                let dateComponent = Calendar.current.dateComponents([.day, .month, .hour, .minute], from: item.remindDateTime)
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: true)
                let request = UNNotificationRequest(identifier: item.id, content: content, trigger: trigger)
                UNUserNotificationCenter.current().add(request)
            }
        }
    }
    
    func cancelNotification() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
    
    func goToSetting() {
        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:]) { success in
            print("Settings opened: \(success)") // Prints true
        }
    }
}
