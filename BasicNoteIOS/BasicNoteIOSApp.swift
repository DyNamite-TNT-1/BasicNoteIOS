//
//  BasicNoteIOSApp.swift
//  BasicNoteIOS
//
//  Created by hanbiro - ANHDUC on 9/6/23.
//

import SwiftUI

@main
struct BasicNoteIOSApp: App {
    
    @StateObject var mainViewModel: MainViewModel = MainViewModel()
    
    var body: some Scene {
        WindowGroup {
            NavigationView{
                MainView()
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .environmentObject(mainViewModel)
        }
    }
}
