//
//  AppContent.swift
//  BasicNoteIOS
//
//  Created by hanbiro on 9/18/23.
//

import SwiftUI

struct AppContainer: View {
    
    @StateObject var homeViewModel: HomeViewModel = HomeViewModel()
    @State var selectedTab: Int = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationView{
                HomeView()
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .environmentObject(homeViewModel)
            .tabItem {
                Image(systemName: "house.fill")
                Text("home_str")
            }
            .tag(0)
            NavigationView {
                SettingView(isToggled: homeViewModel.toggleNotiStatus)
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .environmentObject(homeViewModel)
            .tabItem{
                Image(systemName: "gearshape.fill")
                Text("setting_str")
            }
            .tag(1)
        }
        .environment(\.locale, .init(identifier: homeViewModel.currentLang.value))
    }
}

struct AppContent_Previews: PreviewProvider {
    static var previews: some View {
        AppContainer()
    }
}
