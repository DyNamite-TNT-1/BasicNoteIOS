//
//  SettingView.swift
//  BasicNoteIOS
//
//  Created by hanbiro on 9/18/23.
//

import SwiftUI
import UserNotifications

struct SettingView: View {
    
    @EnvironmentObject var homeViewModel: HomeViewModel
    @State private var isToggled: Bool = false
    
    init(isToggled: Bool) {
        self._isToggled = State(initialValue: isToggled)
    }
    
    var body: some View {
        let bindingShowAlert = Binding<Bool> {
            return homeViewModel.toggleNotiStatus && self.homeViewModel.localNotiStatus == -1
        } set: {
            _ in
            //nothing to do
        }
        List {
            Section() {
                Text("This will enable push notifications that items need reminding.")
                Toggle("Notifications", isOn: $isToggled)
                    .onChange(of: isToggled, perform: {
                        homeViewModel.onToggle($0)
                    })
                    .alert("You didn't allow notifications. Go to Settings to allow it.", isPresented: bindingShowAlert) {
                        Button("Cancel") {
                            isToggled = false
                        }
                        Button("Go to Settings") {
                            isToggled = false
                            homeViewModel.goToSetting()
                        }
                    }
            }
        }
        .onAppear{
            UIApplication.shared.applicationIconBadgeNumber = 0
            homeViewModel.checkPermission()
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SettingView(isToggled: true)
        }
    }
}
