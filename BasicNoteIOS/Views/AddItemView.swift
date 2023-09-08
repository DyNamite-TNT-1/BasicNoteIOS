//
//  AddView.swift
//  BasicNoteIOS
//
//  Created by hanbiro on 9/6/23.
//

import SwiftUI

struct AddItemView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var listViewModel: MainViewModel
    @State var titleTxtField: String = ""
    @State var descriptionTxtField: String = ""
    
    @State var alertTitle: String = ""
    @State var showAlert: Bool = false
    
    var body: some View {
        ScrollView{
            VStack {
                TextField("Type title here...", text: $titleTxtField)
                    .padding(.horizontal)
                    .frame(height: 55)
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(10)
                TextField("Type description here...", text: $descriptionTxtField, axis: .vertical)
                    .padding()
                    .frame(height: 100, alignment: .top)
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(10)
                Button(action: saveButtonPressed, label: {
                    Text("Save".uppercased())
                        .foregroundColor(.white)
                        .font(.headline)
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .background(Color.accentColor)
                        .cornerRadius(10)
                })
            }.padding(14)
        }.navigationTitle("Add an Item 🖊")
            .alert(isPresented: $showAlert, content: getAlert)
    }
    
    func saveButtonPressed() {
        if textIsAppropriate() {
            listViewModel.addItem(title: titleTxtField, description: descriptionTxtField, createDate: Date())
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
