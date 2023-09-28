//
//  NoteDetailView.swift
//  BasicNoteIOS
//
//  Created by hanbiro - ANHDUC on 9/8/23.
//

import SwiftUI
import PhotosUI
import SwiftUIImageViewer

struct NoteDetailView: View {
    let item: NoteModel
    let mainColor = Color("MainColor")
    
    @EnvironmentObject var homeViewModel: HomeViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var isImageViewerPresented = false
    
    @State private var alertTitle: String = ""
    @State private var showAlert: Bool = false
    @State private var showConfirmDialog: Bool = false
    
    @State private var titleTxtField: String = ""
    @State private var descriptionTxtField: String = ""
    
    @State private var isDone: Bool = false
    @State private var isNeedRemind: Bool = false
    
    @State private var isShowedRemindDate = false
    @State private var isShowedRemindTime = false
    @State private var remindDateTime: Date = Date.now
    
    @State var selectedPhoto: PhotosPickerItem?
    @State var selectedPhotoData: Data?
    
    init(item: NoteModel) {
        self.item = item
        self._titleTxtField = State(initialValue: item.title)
        self._descriptionTxtField = State(initialValue: item.description)
        self._isDone = State(initialValue: item.isCompleted)
        self._isNeedRemind = State(initialValue: item.isNeedRemind)
        self._isShowedRemindDate = State(initialValue: false)
        self._isShowedRemindTime = State(initialValue: false)
        self._remindDateTime = State(initialValue: item.remindDateTime)
        self._selectedPhotoData = State(initialValue: item.image)
    }
    
    var btnBack : some View {
        Button(action: {
            if (checkAlreadyEdited()) {
                showConfirmDialog.toggle()
            } else {
                self.presentationMode.wrappedValue.dismiss()
            }
        }) {
            Text("Cancel")
        }
    }
    
    func checkAlreadyEdited() -> Bool {
        if (item.title != titleTxtField ||
            item.description != descriptionTxtField ||
            item.isCompleted != isDone ||
            item.isNeedRemind != isNeedRemind ||
            item.remindDateTime != remindDateTime ||
            item.image != selectedPhotoData) {
            return true
        } else {
            return false
        }
    }
    
    var body: some View {
        List{
            Section{
                TextField("Title", text: $titleTxtField, axis: .vertical)
                TextField("Description", text: $descriptionTxtField, axis: .vertical)
            }
            Section{
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
                            withAnimation {
                                isDone.toggle()
                            }
                        }
                }
                HStack{
                    Text("Updated:")
                    Spacer()
                    Text(item.createDate.formatted(date: .abbreviated, time: .shortened))
                }
            }
            Section("Remind Schedule") {
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
                            withAnimation{
                                isNeedRemind.toggle()
                                isShowedRemindTime = false
                                isShowedRemindDate = false
                            }
                        }
                }
                //Remind Date
                Button {
                    withAnimation {
                        isShowedRemindDate.toggle()
                    }
                } label: {
                    HStack{
                        Image(systemName: "calendar")
                            .resizable()
                            .frame(width: 18.0, height: 18.0)
                            .foregroundColor(Color.white)
                            .padding(6)
                            .background(isNeedRemind ? Color.red : Color.gray)
                            .cornerRadius(8)
                        VStack(alignment: .leading) {
                            Text("Target Date")
                                .foregroundColor(.black)
                            if (isNeedRemind) {
                                Text(remindDateTime, style: .date)
                                    .font(.footnote)
                            }
                        }
                    }
                }
                .disabled(!isNeedRemind)
                if (isShowedRemindDate) {
                    DatePicker("Pick Date:",selection: $remindDateTime, displayedComponents: .date)
                        .labelsHidden()
                        .datePickerStyle(.graphical)
                }
                //Remind Time
                Button {
                    withAnimation {
                        isShowedRemindTime.toggle()
                    }
                } label: {
                    HStack{
                        Image(systemName: "clock.fill")
                            .resizable()
                            .frame(width: 18.0, height: 18.0)
                            .foregroundColor(Color.white)
                            .padding(6)
                            .background(isNeedRemind ? Color.accentColor : Color.gray)
                            .cornerRadius(8)
                        VStack(alignment: .leading) {
                            Text("Target Time")
                                .foregroundColor(.black)
                            if (isNeedRemind) {
                                Text(remindDateTime, style: .time)
                                    .font(.footnote)
                            }
                        }
                    }
                }
                .disabled(!isNeedRemind)
                if (isShowedRemindTime) {
                    DatePicker("Pick Time:",selection: $remindDateTime, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                        .datePickerStyle(WheelDatePickerStyle())
                }
            }
            
            Section("Image") {
                if let selectedPhotoData = self.selectedPhotoData, let uiImage = UIImage(data: selectedPhotoData) {
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
                PhotosPicker(selection: $selectedPhoto,
                             matching: .images,
                             photoLibrary: .shared()) {
                    Label(selectedPhotoData != nil ? "Change Image" : "Add Image", systemImage: "photo")
                }
                if selectedPhotoData != nil {
                    Button(role: .destructive) {
                        withAnimation{
                            selectedPhoto = nil
                            selectedPhotoData = nil
                        }
                    } label: {
                        Label("Remove Image", systemImage: "xmark")
                            .foregroundStyle(.red)
                    }
                }
            }
        }
        .navigationTitle("View Detail")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: btnBack, trailing: Button(action: {
            homeViewModel.updateItem(item: item, title: titleTxtField, description: descriptionTxtField, createDate: Date(), isCompleted: isDone, image: selectedPhotoData, isNeedRemind: isNeedRemind, remindDateTime: remindDateTime)
            self.presentationMode.wrappedValue.dismiss()
        }, label: {
            Text("Save")
                .foregroundColor(.accentColor)
        }))
        .alert(isPresented: $showAlert, content: getAlert)
        .confirmationDialog("Cancel Confirmation", isPresented: $showConfirmDialog) {
            Button(role: .destructive) {
                self.presentationMode.wrappedValue.dismiss()
            } label: {
                Text("Cancel changes")
            }
        } message: {
            Text("You cannot undo this action")
        }
        .task(id: selectedPhoto) {
            if let data = try? await selectedPhoto?.loadTransferable(type: Data.self){
                selectedPhotoData = data
            }
        }
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

