//
//  ListView.swift
//  BasicNoteIOS
//
//  Created by hanbiro on 9/6/23.
//

import SwiftUI

struct MainView: View {
    
    @EnvironmentObject var listViewModel: MainViewModel
    @State private var query = ""
    
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
                    .onMove(perform: listViewModel.moveItem)
                }
                .searchable(text: $query, prompt: "Find a note")
                .onChange(of: query) { newQuery in
                    listViewModel.searchItems(query: newQuery)
                }
            }
        }
        .navigationTitle("Todo List 📝")
        .navigationBarItems(leading: EditButton(), trailing:
                                NavigationLink("Add", destination: AddItemView())
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
