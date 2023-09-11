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
    
    var body: some View {
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
        }
        .font(.title2)
        .padding(.vertical, 8)
    }
}

struct NoteItemView_Previews: PreviewProvider {
    
    static var previews: some View {
        Group {
            NoteItemView(item: NoteModel.exampleDone)
            NoteItemView(item: NoteModel.exampleUndone)
        }
        .previewLayout(.sizeThatFits)
    }
}
