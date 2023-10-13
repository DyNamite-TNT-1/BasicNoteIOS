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
                Text("notification_desc_str")
                Toggle("notification_str", isOn: $isToggled)
                    .onChange(of: isToggled, perform: {
                        homeViewModel.onToggle($0)
                    })
                    .alert("alert_notification_str", isPresented: bindingShowAlert) {
                        Button("cancel_str") {
                            isToggled = false
                        }
                        Button("goto_setting_str") {
                            isToggled = false
                            homeViewModel.goToSetting()
                        }
                    }
            }
            Section() {
                HStack {
                    Text("language_str")
                        .foregroundColor(.black)
                    Spacer()
                    LanguageView()
                }
            }
        }
        .onAppear{
            homeViewModel.checkPermission()
        }
        .navigationTitle("setting_str")
        .navigationBarTitleDisplayMode(.inline)
        .environment(\.locale, .init(identifier: homeViewModel.currentLang.value))
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SettingView(isToggled: true)
        }
    }
}
