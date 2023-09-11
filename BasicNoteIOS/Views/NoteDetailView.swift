//
//  NoteDetailView.swift
//  BasicNoteIOS
//
//  Created by hanbiro on 9/8/23.
//

import SwiftUI
import SwiftUIImageViewer

struct NoteDetailView: View {
    let item: NoteModel
    let mainColor = Color("MainColor")
    
    @State private var isImageViewerPresented = false
    
    var body: some View {
        VStack{
            HStack{
                Text("Status:")
                    .font(.footnote)
                Spacer()
                Text(item.isCompleted ? "Done" : "Undone")
                    .padding(.horizontal)
                    .padding(.vertical, 2)
                    .background(item.isCompleted ? .green : .red)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            HStack{
                Text("Created/Updated Date:")
                    .font(.footnote)
                Spacer()
                Text(item.createDate.formatted(date: .abbreviated, time: .shortened))
            }
            .padding(.horizontal)
            Text(item.desctiption.isEmpty ? "<No description here>" : item.desctiption)
                .frame(maxWidth: .infinity)
                .padding(8)
                .background(.gray)
                .cornerRadius(10)
                .padding(.horizontal)
                .padding(.vertical, 2)
                .multilineTextAlignment(.leading)
            
            if let selectedPhotoData = item.image, let uiImage = UIImage(data: selectedPhotoData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxHeight: 200)
                    .clipShape(
                        RoundedRectangle(cornerRadius: 10, style: .continuous))
                    .zIndex(-1)
                    .padding()
                    .onTapGesture {
                        isImageViewerPresented = true
                    }
                    .fullScreenCover(isPresented: $isImageViewerPresented) {
                        SwiftUIImageViewer(image: Image(uiImage: uiImage))
                            .overlay(alignment: .topTrailing) {
                                Button{
                                    isImageViewerPresented = false
                                } label: {
                                    Image(systemName: "xmark")
                                        .font(.headline)
                                }
                                .buttonStyle(.bordered)
                                .clipShape(Circle())
                                .tint(.purple)
                                .padding()
                            }
                    }
            }
            Spacer()
        }
        .navigationTitle(item.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct NoteDetailView_Previews: PreviewProvider {
    
    static var previews: some View {
        Group
        {
            NavigationStack {
                NoteDetailView(item: NoteModel.exampleDone)
            }
            NavigationStack {
                NoteDetailView(item: NoteModel.exampleUndone)
            }
        }
    }
}

