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
                VStack(alignment: .leading){
                    Text(item.title)
                        .font(.system(size: 18, weight: .semibold))
                    if !item.description.isEmpty {
                        Text(item.description)
                            .font(.body)
                    }
                    Text(item.remindDateTime.formatted(date: .abbreviated, time: .shortened))
                        .font(.footnote)
                        .foregroundColor(item.isNeedRemind ? .accentColor : .gray)
                }
            }
            
            if let selectedPhotoData = item.image,
               let uiImage = UIImage(data: selectedPhotoData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxHeight: 120)
                    .clipShape(
                        RoundedRectangle(cornerRadius: 10, style: .continuous))
                    .zIndex(-1)
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
