//
//  AddView.swift
//  BasicNoteIOS
//
//  Created by hanbiro on 9/6/23.
//

import SwiftUI
import PhotosUI

struct AddItemView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var listViewModel: MainViewModel
    @State var titleTxtField: String = ""
    @State var descriptionTxtField: String = ""
    
    @State var alertTitle: String = ""
    @State var showAlert: Bool = false
    
    @State var selectedPhoto: PhotosPickerItem?
    @State var selectedPhotoData: Data?
    
    var body: some View {
        List {
            Section("Todo title") {
                TextField("Type title here...", text: $titleTxtField)
            }
            Section("Todo description") {
                TextField("Type description here...", text: $descriptionTxtField, axis: .vertical)
            }
            Section("Image") {
                
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
                    Label("Add Image", systemImage: "photo")
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
        .navigationTitle("Note your note🖊")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing:
                                Button("Save") {saveButtonPressed()})
        .alert(isPresented: $showAlert, content: getAlert)
        .toolbar {}
        .task(id: selectedPhoto) {
            if let data = try? await selectedPhoto?.loadTransferable(type: Data.self){
                selectedPhotoData = data
            }
        }
    }
    
    func saveButtonPressed() {
        if textIsAppropriate() {
            listViewModel.addItem(title: titleTxtField, description: descriptionTxtField, createDate: Date(), image: selectedPhotoData)
            //to pop view
            presentationMode.wrappedValue.dismiss()
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

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView{
                AddItemView()
            }
            .preferredColorScheme(.light)
            .environmentObject(MainViewModel())
            NavigationView{
                AddItemView()
            }
            .preferredColorScheme(.dark)
            .environmentObject(MainViewModel())
        }
    }
}
