//
//  NoteDetailView.swift
//  BasicNoteIOS
//
//  Created by hanbiro on 9/8/23.
//

import SwiftUI

struct NoteDetailView: View {
    let item: NoteModel
    let mainColor = Color("MainColor")
    
    var body: some View {
        VStack(alignment: .leading){
            Text(item.title)
                .font(.title)
            HStack{
                Text("Create Date")
                    .font(.subheadline)
                Text(item.createDate.formatted(date: .abbreviated, time: .shortened))
            }
            Text("Description")
                .font(.footnote)
            Text(item.desctiption)
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity,
            alignment: .topLeading)
        
    }
}

struct NoteDetailView_Previews: PreviewProvider {
    static var item1 = NoteModel(title: "First item!", desctiption: "This is description! You need to do follow step by step. If not, you will fail.", createDate: Date(), isCompleted: false);
    
    static var previews: some View {
        NoteDetailView(item: item1)
    }
}
