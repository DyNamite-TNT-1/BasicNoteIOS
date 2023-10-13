//
//  LanguageView.swift
//  BasicNoteIOS
//
//  Created by hanbiro on 10/13/23.
//

import SwiftUI

struct LanguageView: View {
    
    @EnvironmentObject var homeViewModel: HomeViewModel
    
    var body: some View {
        Menu {
            ForEach(0..<homeViewModel.supportLanguages.count, id: \.self){index in
                Button {
                    homeViewModel.changeLang(newLang: homeViewModel.supportLanguages[index])
                } label: {
                    if (homeViewModel.currentLang == homeViewModel.supportLanguages[index]) {
                        Label(homeViewModel.supportLanguages[index].title, systemImage: "checkmark")
                    } else {
                        Text(homeViewModel.supportLanguages[index].title)
                    }
                }
            }
        } label: {
            HStack{
                Text(homeViewModel.currentLang.title)
                Image(systemName: "arrow.up.and.down")
            }
            .foregroundColor(.gray)
        }
    }
}

struct LanguageView_Previews: PreviewProvider {
    static var previews: some View {
        LanguageView()
    }
}
