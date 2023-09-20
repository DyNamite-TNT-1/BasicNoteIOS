//
//  SettingView.swift
//  BasicNoteIOS
//
//  Created by hanbiro on 9/18/23.
//

import SwiftUI
import UserNotifications

struct SettingView: View {
    
    @EnvironmentObject var settingViewModel: SettingViewModel
    @State private var isToggled: Bool = false
    
    var body: some View {
        let bindingShowAlert = Binding<Bool> {
            return self.isToggled && self.settingViewModel.localNotiStatus == -1
        } set: {
            _ in
        }
        List {
            Section() {
                Toggle("Notifications", isOn: $isToggled)
                    .onChange(of: isToggled, perform: {
                        settingViewModel.onToggle($0)
                    })
                    .alert("You didn't allow notifications. Go to Settings to allow it.", isPresented: bindingShowAlert) {
                        Button("Cancel") {
                            isToggled = false
                        }
                        Button("Go to Settings") {
                            isToggled = false
                            settingViewModel.goToSetting()
                        }
                    }
            }
        }
        .onAppear{
            UIApplication.shared.applicationIconBadgeNumber = 0
            settingViewModel.checkAuthorization()
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SettingView()
        }
    }
}
