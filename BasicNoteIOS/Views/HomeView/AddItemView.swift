//
//  AddView.swift
//  BasicNoteIOS
//
//  Created by hanbiro - ANHDUC on 9/6/23.
//

import SwiftUI
import PhotosUI

struct AddItemView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var homeView: HomeViewModel
    @State var titleTxtField: String = ""
    @State var descriptionTxtField: String = ""
    
    @State var alertTitle: LocalizedStringKey = ""
    @State var showAlert: Bool = false
    
    @State var selectedPhoto: PhotosPickerItem?
    @State var selectedPhotoData: Data?
    
    @State var isToggledRemind: Bool = true
    @State var remindDateTime: Date = Date.now
    
    @State var selectedPriority: Priority = .none
    
    var body: some View {
        
        List {
            Section("title_str") {
                TextField("enter_title_str", text: $titleTxtField)
            }
            Section("description_str") {
                TextField("enter_description_str", text: $descriptionTxtField, axis: .vertical)
            }
            
            Section("priority_str") {
                HStack {
                    Text("priority_str")
                        .foregroundColor(.black)
                    Spacer()
                    PriorityView(selectedPriority: $selectedPriority)
                }
            }
            
            Section("reminder_str") {
                Toggle("remind_ask_need_str", isOn: $isToggledRemind)
                VStack(alignment: .leading) {
                    Text("remind_schedule_str")
                        .foregroundColor(.black)
                    DatePicker("Schedule", selection: $remindDateTime, in: Date.now...)
                        .labelsHidden()
                }
            }
            Section("image_str") {
                if let selectedPhotoData, let uiImage = UIImage(data: selectedPhotoData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(maxHeight: 300)
                        .clipShape(
                            RoundedRectangle(cornerRadius: 10, style: .continuous))
                        .zIndex(-1)
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
        .navigationTitle(Text("add_note_str"))
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing:
                                Button("save_str") {saveButtonPressed()})
        .alert(isPresented: $showAlert, content: getAlert)
        .task(id: selectedPhoto) {
            if let data = try? await selectedPhoto?.loadTransferable(type: Data.self){
                selectedPhotoData = data
            }
        }
    }
    
    func saveButtonPressed() {
        if textIsAppropriate() {
            homeView.addItem(title: titleTxtField, description: descriptionTxtField, createDate: Date(), image: selectedPhotoData, isNeedRemind: isToggledRemind, remindDateTime: remindDateTime, priority: selectedPriority)
            //to pop view
            presentationMode.wrappedValue.dismiss()
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

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView{
                AddItemView()
            }
            .preferredColorScheme(.light)
            .environmentObject(HomeViewModel())
            NavigationView{
                AddItemView()
            }
            .preferredColorScheme(.dark)
            .environmentObject(HomeViewModel())
        }
    }
}
