//
//  NoteDetailView.swift
//  BasicNoteIOS
//
//  Created by hanbiro - ANHDUC on 9/8/23.
//

import SwiftUI
import SwiftUIImageViewer

struct NoteDetailView: View {
    let item: NoteModel
    let mainColor = Color("MainColor")
    
    @EnvironmentObject var homeViewModel: HomeViewModel
    @State private var isImageViewerPresented = false
    @State private var isEditMode = false
    @State private var isShowSelectTargetDate = true
    
    @State private var alertTitle: String = ""
    @State private var showAlert: Bool = false
    
    @State private var titleTxtField: String = ""
    @State private var descriptionTxtField: String = ""
    
    @State private var isDone: Bool = false
    @State private var isNeedRemind: Bool = false
    
    @State private var targetDateTime: Date = Date.now
    
    init(item: NoteModel) {
        self.item = item
        self._titleTxtField = State(initialValue: item.title)
        self._descriptionTxtField = State(initialValue: item.description)
        self._isDone = State(initialValue: item.isCompleted)
        self._isNeedRemind = State(initialValue: item.isNeedRemind)
        self._targetDateTime = State(initialValue: item.targetDateTime)
    }
    
    var body: some View {
        List{
            Section{
                TextField("Title", text: $titleTxtField, axis: .vertical)
                TextField("Description", text: $descriptionTxtField, axis: .vertical)
            }
            Section("Status"){
                HStack{
                    Text("Completed")
                    Spacer()
                    Text(isDone ? "Done" : "Undone")
                        .padding(.horizontal)
                        .padding(.vertical, 4)
                        .foregroundColor(.white)
                        .background(isDone ? .green : .red)
                        .cornerRadius(10)
                        .onTapGesture {
                            if (isEditMode) {
                                isDone.toggle()
                            }
                        }
                        .animation(Animation.default.speed(1), value: isDone)
                }
                HStack{
                    Text("Remind")
                    Spacer()
                    Text(isNeedRemind ? "Remind" : "No Remind")
                        .padding(.horizontal)
                        .padding(.vertical, 4)
                        .foregroundColor(.white)
                        .background(isNeedRemind ? .blue : .gray)
                        .cornerRadius(10)
                        .onTapGesture {
                            if (isEditMode) {
                                isNeedRemind.toggle()
                            }
                        }
                        .animation(Animation.default.speed(1), value: isNeedRemind)
                }
            }
            HStack{
                Text("Updated Date:")
                    .font(.system(size: 14))
                Spacer()
                Text(item.createDate.formatted(date: .abbreviated, time: .shortened))
            }
            .padding(.horizontal)
            
            ZStack {
                DatePicker("Pick Date:", selection: $targetDateTime, in: Date.now...)
                    .padding(isEditMode ? 8 : 0)
                    .overlay(
                        isEditMode ?  RoundedRectangle(cornerRadius: 10)
                            .stroke(.blue, lineWidth: 2) : nil
                    )
                    .padding(.horizontal,isEditMode ? 16 : 0)
                    .opacity(isEditMode ? 100 : 0)
                if (!isEditMode) {
                    HStack{
                        Text("Target Date:")
                            .font(.system(size: 14))
                        Spacer()
                            Text(targetDateTime.formatted(date: .abbreviated, time: .shortened))
                      
                            
                        
    //                    if (isEditMode) {
    //                        Button {
    //                            withAnimation{
    //                                isShowSelectTargetDate.toggle()
    //                            }
    //                        } label: {
    //                            Image(systemName: "chevron.right")
    //                                .rotationEffect(Angle(degrees: isShowSelectTargetDate ? 90 : 0))
    //                        }
    //                        .animation(Animation.default.speed(1), value: isShowSelectTargetDate)
    //                    }
                     
    //                    .padding(8)
    //                    .overlay(
    //                        RoundedRectangle(cornerRadius: 10)
    //                            .stroke(.blue, lineWidth: 2)
    //                    )
    //                    .padding(.horizontal)
                    }
                    .padding(.horizontal)
    //                if (isShowSelectTargetDate && isEditMode) {
    //                    DatePicker("Select Date:", selection: $targetDateTime, in: Date.now...)
    //                    .labelsHidden()
    //                    .padding(8)
    //                    .overlay(
    //                        RoundedRectangle(cornerRadius: 10)
    //                            .stroke(.blue, lineWidth: 2)
    //                    )
    //                    .padding(.horizontal)
    //                }
                }
               
            }
            .transition(.move(edge: .bottom))
            
            
            
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
        .navigationTitle("View Detail")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: Button(action: {
//            if (isEditMode) {
//                homeViewModel.updateItem(item: item, title: titleTxtField, description: descriptionTxtField, createDate: Date(), isCompleted: isDone, image: item.image, isNeedRemind: isNeedRemind, targetDateTime: targetDateTime)
//            }
            isEditMode.toggle()
        }, label: {
            Text(isEditMode ? "Done" : "Edit")
                .foregroundColor(.accentColor)
        }))
        .alert(isPresented: $showAlert, content: getAlert)
    }
    
    func textIsAppropriate() -> Bool {
        if titleTxtField.count < 3 {
            alertTitle = "Your new todo item must be at least 3 characters long !!! 🥲😳"
            showAlert.toggle()
            return false;
        }
        return true;
    }
    
    func getAlert() -> Alert {
        return Alert(title: Text(alertTitle))
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

