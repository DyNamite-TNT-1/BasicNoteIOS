//
//  SortView.swift
//  BasicNoteIOS
//
//  Created by hanbiro on 9/13/23.
//

import SwiftUI

struct SortView: View {
    
    @EnvironmentObject var listViewModel: MainViewModel
    
    var body: some View {
        Menu {
            ForEach(0..<listViewModel.sortDatas.count, id: \.self){index in
                Button {
                    listViewModel.toggleSort(at: index)
                } label: {
                    if listViewModel.sortDatas[index].isSelected {
                            Label(listViewModel.sortDatas[index].title, systemImage: "checkmark")
                    } else {
                        Text(listViewModel.sortDatas[index].title)
                    }
                    
                }
            }
        } label: {
            Label(listViewModel.sortSelection.title, systemImage: "arrow.up.arrow.down.circle")
        }

    }
}

struct SortView_Previews: PreviewProvider {
    static var previews: some View {
        SortView()
            .environmentObject(MainViewModel())
    }
}
