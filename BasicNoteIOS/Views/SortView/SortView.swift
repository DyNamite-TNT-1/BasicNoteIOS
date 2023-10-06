//
//  SortView.swift
//  BasicNoteIOS
//
//  Created by hanbiro on 9/13/23.
//

import SwiftUI

struct SortView: View {
    
    @EnvironmentObject var homeViewModel: HomeViewModel
    
    var body: some View {
        Menu {
            ForEach(0..<homeViewModel.sortDatas.count, id: \.self){index in
                Button {
                    homeViewModel.toggleSort(at: index)
                } label: {
                    if homeViewModel.sortDatas[index].isSelected {
                            Label(homeViewModel.sortDatas[index].title, systemImage: "checkmark")
                    } else {
                        Text(homeViewModel.sortDatas[index].title)
                    }
                }
            }
        } label: {
            Label(homeViewModel.sortSelection.title, systemImage: "arrow.up.arrow.down.circle")
        }
    }
}

struct SortView_Previews: PreviewProvider {
    static var previews: some View {
        SortView()
            .environmentObject(HomeViewModel())
    }
}
