//
//  ListRowView.swift
//  BasicNoteIOS
//
//  Created by hanbiro - ANHDUC on 9/6/23.
//

import SwiftUI

struct NoteItemRowView: View {
    let item: NoteModel
    var onToggleDone: (()->Void)?
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: item.isCompleted ? "checkmark.circle" : "circle")
                    .foregroundColor(item.isCompleted ? .green : .red)
                    .onTapGesture {
                        onToggleDone?()
                    }
                VStack(alignment: .leading, spacing: 0){
                    HStack{
                        if !item.priorityIcon.isEmpty {
                            Image(systemName: item.priorityIcon)
                                .font(.system(size: 16))
                                .foregroundColor(.red)
                        }
                        Text(item.title)
                            .font(.system(size: 18, weight: .semibold))
                    }
                    if !item.description.isEmpty {
                        Text(item.description)
                            .font(.body)
                    }
                    HStack{
                        Text(item.remindDateTime, style: .time)
                            .font(.footnote)
                            .foregroundColor(item.isNeedRemind ? .accentColor : .gray)
                        Text(item.remindDateTime, style: .date)
                            .font(.footnote)
                            .foregroundColor(item.isNeedRemind ? .accentColor : .gray)
                        if (item.image != nil) {
                            Image(systemName: "photo.on.rectangle.angled")
                                .resizable()
                                .foregroundColor(.blue)
                                .frame(width: 16, height: 16)
                        }
                    }
                }
            }
        }
        .font(.title2)
        .padding(.vertical, 8)
    }
}

struct NoteItemView_Previews: PreviewProvider {
    
    static var previews: some View {
        Group {
            NoteItemRowView(item: NoteModel.exampleDone)
            NoteItemRowView(item: NoteModel.exampleUndone)
        }
        .previewLayout(.sizeThatFits)
    }
}
