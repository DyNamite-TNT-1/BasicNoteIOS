//
//  ListView.swift
//  BasicNoteIOS
//
//  Created by hanbiro - ANHDUC on 9/6/23.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var homeViewModel: HomeViewModel
    @State private var query = ""
    @State var isShowFilterSheet: Bool = false
    
    var body: some View {
        ZStack {
            if homeViewModel.items.isEmpty {
                NoNoteDataView()
                    .transition(AnyTransition.opacity.animation(.easeIn))
            } else {
                List {
                    ForEach(homeViewModel.renderItems) {
                        item in
                        NavigationLink {
                            NoteDetailView(item: item)
                        } label: {
                            NoteItemRowView(item: item, onToggleDone: {
                                withAnimation(.linear) {
                                    homeViewModel.toggleItemCompletion(item: item)
                                }
                            })
                        }
                    }
                    .onDelete(perform: homeViewModel.deleteItem)
                    //disable onMove due to conflict with sorting, review the business later
                    //                    .onMove(perform: homeViewModel.moveItem)
                }
                .searchable(text: $query, placement: .navigationBarDrawer(displayMode: .always), prompt: "Find a note")
                .onChange(of: query) { newQuery in
                    homeViewModel.searchItems(query: newQuery)
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
        .safeAreaInset(edge: .bottom, alignment: .trailing) {
            Button {
                isShowFilterSheet.toggle()
            } label: {
                Label("Filter", systemImage: "line.3.horizontal.decrease.circle")
                    .bold()
                    .font(.title2)
                    .padding(8)
                    .background(.gray.opacity(0.1),
                                in: Capsule())
                    .padding(.trailing, 8)
                    .symbolVariant(.circle.fill)
            }
            .padding(.bottom, 8)
            .overlay(alignment: .topLeading) {
                Text("\(homeViewModel.filterSelections.count)")
                    .font(.footnote)
                    .foregroundColor(.white)
                    .frame(width: 28, height: 28)
                    .background(.blue, in: Capsule())
                    .offset(x: -10, y: -15)
                    .opacity(homeViewModel.filterSelections.isEmpty ? 0 : 1)
            }
            
        }
        .sheet(isPresented: $isShowFilterSheet) {
            NavigationStack {
                FilterView(onDone: {
                    homeViewModel.filterItems()
                }, onDismiss: {
                    homeViewModel.onDismissFilter()
                })
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HomeView()
        }
        .environmentObject(HomeViewModel())
    }
}
