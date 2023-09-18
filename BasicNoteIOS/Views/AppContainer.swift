//
//  AppContent.swift
//  BasicNoteIOS
//
//  Created by hanbiro on 9/18/23.
//

import SwiftUI

struct AppContainer: View {
    
    @StateObject var homeViewModel: HomeViewModel = HomeViewModel()
    @StateObject var settingViewModel: SettingViewModel = SettingViewModel()
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
                Text("Home")
            }
            .tag(0)
            NavigationView {
                SettingView()
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .environmentObject(settingViewModel)
            .tabItem{
                Image(systemName: "gearshape.fill")
                Text("Setting")
            }
            .tag(1)
        }
    }
}

struct AppContent_Previews: PreviewProvider {
    static var previews: some View {
        AppContainer()
    }
}
