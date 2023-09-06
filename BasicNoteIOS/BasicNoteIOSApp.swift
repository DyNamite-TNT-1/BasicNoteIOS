//
//  BasicNoteIOSApp.swift
//  BasicNoteIOS
//
//  Created by hanbiro on 9/6/23.
//

import SwiftUI

@main
struct BasicNoteIOSApp: App {
    
    @StateObject var listViewModel: ListViewModel = ListViewModel()
    
    var body: some Scene {
        WindowGroup {
            NavigationView{
                ListView()
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .environmentObject(listViewModel)
        }
    }
}
