//
//  ListRowView.swift
//  BasicNoteIOS
//
//  Created by hanbiro on 9/6/23.
//

import SwiftUI

struct NoteItemView: View {
    let item: NoteModel
    
    var body: some View {
        HStack {
            Image(systemName: item.isCompleted ? "checkmark.circle" : "circle")
                .foregroundColor(item.isCompleted ? .green : .red)
            Text(item.title)
            Spacer()
        }
        .font(.title2)
        .padding(.vertical, 8)
    }
}

struct ListRowView_Previews: PreviewProvider {
    static var item1 = NoteModel(title: "First item!", isCompleted: false);
    static var item2 = NoteModel(title: "Second item!", isCompleted: true);
    
    static var previews: some View {
        Group {
            NoteItemView(item: item1)
            NoteItemView(item: item2)
        }
        .previewLayout(.sizeThatFits)
    }
}
