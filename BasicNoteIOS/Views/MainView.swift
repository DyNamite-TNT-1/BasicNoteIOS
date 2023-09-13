//
//  ListView.swift
//  BasicNoteIOS
//
//  Created by hanbiro - ANHDUC on 9/6/23.
//

import SwiftUI

struct MainView: View {
    
    @EnvironmentObject var listViewModel: MainViewModel
    @State private var query = ""
    @State var isShowFilterDialog: Bool = false
    
    var body: some View {
        ZStack {
            if listViewModel.items.isEmpty {
                NoNoteDataView()
                    .transition(AnyTransition.opacity.animation(.easeIn))
            } else {
                List {
                    ForEach(listViewModel.renderItems) {
                        item in
                        NavigationLink {
                            NoteDetailView(item: item)
                        } label: {
                            NoteItemRowView(item: item, onToggleDone: {
                                withAnimation(.linear) {
                                    listViewModel.updateItem(item: item)
                                }
                            })
                        }
                    }
                    .onDelete(perform: listViewModel.deleteItem)
                    //disable onMove due to conflict with sorting, review the business later
//                    .onMove(perform: listViewModel.moveItem)
                }
                .searchable(text: $query, placement: .navigationBarDrawer(displayMode: .always), prompt: "Find a note")
                .onChange(of: query) { newQuery in
                    listViewModel.searchItems(query: newQuery)
                }
                .animation(.default, value: query)
            }
            if isShowFilterDialog {
                FilterDialogView(isActive: $isShowFilterDialog, buttonTitle: "Filter", action: {})
            }
        }
        .navigationTitle("Todo List 📝")
        .navigationBarItems(leading: EditButton(),
                            trailing:
                                HStack{
            Button("Filter") {
                isShowFilterDialog.toggle()
            }
            NavigationLink {
                AddItemView()
            } label: {
                Label("Add", systemImage: "plus.circle")
            }
            SortView()
            
        }
        )
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MainView()
        }
        .environmentObject(MainViewModel())
    }
}
