//
//  SortView.swift
//  BasicNoteIOS
//
//  Created by hanbiro on 9/13/23.
//

import SwiftUI

struct SortView: View {
    
    @EnvironmentObject var mainViewModel: MainViewModel
    
    var body: some View {
        Menu {
            ForEach(0..<mainViewModel.sortDatas.count, id: \.self){index in
                Button {
                    mainViewModel.toggleSort(at: index)
                } label: {
                    if mainViewModel.sortDatas[index].isSelected {
                            Label(mainViewModel.sortDatas[index].title, systemImage: "checkmark")
                    } else {
                        Text(mainViewModel.sortDatas[index].title)
                    }
                    
                }
            }
        } label: {
            Label(mainViewModel.sortSelection.title, systemImage: "arrow.up.arrow.down.circle")
        }

    }
}

struct SortView_Previews: PreviewProvider {
    static var previews: some View {
        SortView()
            .environmentObject(MainViewModel())
    }
}
