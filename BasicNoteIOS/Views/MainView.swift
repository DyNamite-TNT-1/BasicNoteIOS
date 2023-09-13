//
//  ListView.swift
//  BasicNoteIOS
//
//  Created by hanbiro - ANHDUC on 9/6/23.
//

import SwiftUI

struct MainView: View {
    
    @EnvironmentObject var mainViewModel: MainViewModel
    @State private var query = ""
    @State var isShowFilterSheet: Bool = false
    
    var body: some View {
        ZStack {
            if mainViewModel.items.isEmpty {
                NoNoteDataView()
                    .transition(AnyTransition.opacity.animation(.easeIn))
            } else {
                List {
                    ForEach(mainViewModel.renderItems) {
                        item in
                        NavigationLink {
                            NoteDetailView(item: item)
                        } label: {
                            NoteItemRowView(item: item, onToggleDone: {
                                withAnimation(.linear) {
                                    mainViewModel.updateItem(item: item)
                                }
                            })
                        }
                    }
                    .onDelete(perform: mainViewModel.deleteItem)
                    //disable onMove due to conflict with sorting, review the business later
                    //                    .onMove(perform: mainViewModel.moveItem)
                }
                .searchable(text: $query, placement: .navigationBarDrawer(displayMode: .always), prompt: "Find a note")
                .onChange(of: query) { newQuery in
                    mainViewModel.searchItems(query: newQuery)
                }
                .animation(.default, value: query)
            }
        }
        .navigationTitle("Todo List 📝")
        .navigationBarItems(leading: EditButton(),
                            trailing:
                                HStack{
            NavigationLink {
                AddItemView()
            } label: {
                Label("Add", systemImage: "plus.circle")
            }
            SortView()
        })
        .safeAreaInset(edge: .bottom, alignment: .leading) {
            Button {
                isShowFilterSheet.toggle()
            } label: {
                Label("Filter", systemImage: "line.3.horizontal.decrease.circle")
                    .bold()
                    .font(.title2)
                    .padding(8)
                    .background(.gray.opacity(0.1),
                                in: Capsule())
                    .padding(.leading, 8)
                    .symbolVariant(.circle.fill)
            }
        }
        .sheet(isPresented: $isShowFilterSheet) {
            NavigationStack {
                FilterView(buttonTitle: "Filter", action: {})
            }
        }
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
