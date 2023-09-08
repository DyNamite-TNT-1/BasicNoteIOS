//
//  ListRowView.swift
//  BasicNoteIOS
//
//  Created by hanbiro on 9/6/23.
//

import SwiftUI

struct NoteItemView: View {
    let item: NoteModel
    var onToggleDone: (()->Void)?
    @State var onShowDetail: Bool = false
    
    var body: some View {
        NavigationView {
            HStack {
                Image(systemName: item.isCompleted ? "checkmark.circle" : "circle")
                    .foregroundColor(item.isCompleted ? .green : .red)
                    .onTapGesture {
                        onToggleDone?()
                    }
                
                VStack(alignment: .leading){
                    Text(item.title)
                        .font(.system(size: 18, weight: .semibold))
                    if !item.desctiption.isEmpty {
                        Text(item.desctiption)
                            .font(.body)
                    }
                    Text(item.createDate.formatted(date: .abbreviated, time: .shortened))
                        .font(.footnote)
                }
                .onTapGesture {
                    onShowDetail.toggle()
                }
                NavigationLink("", destination: NoteDetailView(item: item), isActive: $onShowDetail).hidden()
            }
            .font(.title2)
            .padding(.vertical, 8)
        }
    }
}

struct NoteItemView_Previews: PreviewProvider {
    static var item1 = NoteModel(title: "First item!", desctiption: "This is description! You need to do follow step by step. If not, you will fail.", createDate: Date(), isCompleted: false);
    static var item2 = NoteModel(title: "Second item!", desctiption: "This is description! You need to do follow step by step. If not, you will fail.", createDate: Date(), isCompleted: true);
    
    static var previews: some View {
        Group {
            NoteItemView(item: item1)
            NoteItemView(item: item2)
        }
        .previewLayout(.sizeThatFits)
    }
}
