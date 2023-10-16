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
    
    @State private var alertTitle: LocalizedStringKey = ""
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
    
    @State var selectedPriority: Priority
    
    
    
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
        self._selectedPriority = State(initialValue: item.priority)
    }
    
    var btnBack : some View {
        Button(action: {
            if (checkAlreadyEdited()) {
                showConfirmDialog.toggle()
            } else {
                self.presentationMode.wrappedValue.dismiss()
            }
        }) {
            Text("cancel_str")
        }
    }
    
    func checkAlreadyEdited() -> Bool {
        if (item.title != titleTxtField ||
            item.description != descriptionTxtField ||
            item.isCompleted != isDone ||
            item.isNeedRemind != isNeedRemind ||
            item.remindDateTime != remindDateTime ||
            item.image != selectedPhotoData ||
            item.priority != selectedPriority) {
            return true
        } else {
            return false
        }
    }
    
    var body: some View {
        let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
            formatter.locale = Locale(identifier: homeViewModel.currentLang.value)
            return formatter
        }()
        List{
            Section{
                TextField("enter_title_str", text: $titleTxtField, axis: .vertical)
                TextField("enter_description_str", text: $descriptionTxtField, axis: .vertical)
            }
            Section{
                HStack{
                    Text("complete_title_str")
                    Spacer()
                    Text(isDone ? "done_filter_title_str" : "undone_filter_title_str")
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
                    Text("update_title_str")
                    Spacer()
                    Text(dateFormatter.string(from: item.createDate))
                        .font(.footnote)
                }
                HStack {
                    Text("priority_str")
                        .foregroundColor(.black)
                    Spacer()
                    PriorityView(
                    selectedPriority: $selectedPriority)
                }
            }
            Section("remind_schedule_str") {
                HStack{
                    Text("remind_ask_need_str")
                    Spacer()
                    Text(isNeedRemind ? "remind_str" : "no_remind_str")
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
                            Text("target_date_str")
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
                            Text("target_time_str")
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
            
            Section("image_str") {
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
                    Label(selectedPhotoData != nil ? "change_image_str" : "add_image_str", systemImage: "photo")
                }
                if selectedPhotoData != nil {
                    Button(role: .destructive) {
                        withAnimation{
                            selectedPhoto = nil
                            selectedPhotoData = nil
                        }
                    } label: {
                        Label("remove_image_str", systemImage: "xmark")
                            .foregroundStyle(.red)
                    }
                }
            }
        }
        .navigationTitle("view_detail_str")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: btnBack, trailing: Button(action: {
            if textIsAppropriate() {
                homeViewModel.updateItem(item: item, title: titleTxtField, description: descriptionTxtField, createDate: Date(), isCompleted: isDone, image: selectedPhotoData, isNeedRemind: isNeedRemind, remindDateTime: remindDateTime, priority: selectedPriority
                )
                self.presentationMode.wrappedValue.dismiss()
            }
        }, label: {
            Text("save_str")
                .foregroundColor(.accentColor)
        }))
        .alert(isPresented: $showAlert, content: getAlert)
        .confirmationDialog("cancel_confirmation_str", isPresented: $showConfirmDialog) {
            Button(role: .destructive) {
                self.presentationMode.wrappedValue.dismiss()
            } label: {
                Text("cancel_change_str")
            }
        } message: {
            Text("cannot_undo_action_str")
        }
        .task(id: selectedPhoto) {
            if let data = try? await selectedPhoto?.loadTransferable(type: Data.self){
                selectedPhotoData = data
            }
        }
    }
    
    func textIsAppropriate() -> Bool {
        if titleTxtField.count < 3 {
            alertTitle = "warning_length_title_str"
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

