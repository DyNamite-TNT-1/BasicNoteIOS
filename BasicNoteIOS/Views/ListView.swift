//
//  ListView.swift
//  BasicNoteIOS
//
//  Created by hanbiro on 9/6/23.
//

import SwiftUI

struct ListView: View {
    @State var items: [NoteModel] = [
        NoteModel(title: "This is the first title!", isCompleted: false),
        NoteModel(title: "This is the second!", isCompleted: true),
        NoteModel(title: "Third!", isCompleted: false),
        ]
        
        var body: some View {
            List {
                ForEach(items) {
                    item in
                    ListRowView(item: item)
                }
                .onDelete(perform: deleteItem)
                .onMove(perform: moveItem)
            }
            //        .listStyle(PlainListStyle())
            .navigationTitle("Todo List 📝")
            .navigationBarItems(leading: EditButton(), trailing: NavigationLink("Add", destination: AddView()))
        }
        
        func deleteItem(indexSet: IndexSet) {
            items.remove(atOffsets: indexSet)
        }
        
        func moveItem(from: IndexSet, to: Int) {
            items.move(fromOffsets: from, toOffset: to);
        }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ListView()
        }
    }
}
