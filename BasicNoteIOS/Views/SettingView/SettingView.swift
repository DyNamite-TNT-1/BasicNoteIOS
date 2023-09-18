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
    @State private var isShowAlert: Bool = false
    
    var body: some View {
        List {
            Section() {
                Toggle("Notifications", isOn: $isToggled)
                    .onChange(of: isToggled, perform: { newValue in
                        settingViewModel.checkAuthorization()
                        print("execute")
                        if settingViewModel.localNotiStatus == -1 {
                            isShowAlert = true
                        }
                        //                        settingViewModel.onToggle($0)
                    })
                //                    .disabled(settingViewModel.localNotiStatus == -1)
                //                    .onTapGesture {
                //                        if (settingViewModel.checkAuthorization()) {
                //                            return
                //                        }
                //                        if (settingViewModel.localNotiStatus == -1) {
                //                            isShowAlert = true
                //                        }
                //                    }
                    .alert("You didn't allow notifications. Go to Settings to allow it.", isPresented: $isShowAlert) {
                        Button("Cancel") {
                            isShowAlert = false
                        }
                        Button("Go to Settings") {
                            isShowAlert = false
                            settingViewModel.goToSetting()
                        }
                    }
                Button("Push Sheduled Notification") {
                    NotificationManager.instance.scheduleNotification()
                }
            }
        }
        .onAppear{
            UIApplication.shared.applicationIconBadgeNumber = 0
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
