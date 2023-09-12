//
//  FilterView.swift
//  BasicNoteIOS
//
//  Created by hanbiro on 9/12/23.
//

import SwiftUI

struct FilterView: View {
    
    @EnvironmentObject var listViewModel: MainViewModel
    
    var body: some View {
        VStack {
            FilterBar()
            List {
                ForEach(0..<listViewModel.filterDatas.count, id: \.self) {index in
                    FilterTag(filterData: listViewModel.filterDatas[index])
                        .onTapGesture {
                            listViewModel.toggleFilter(at: index)
                        }
                }
            }
        }
        .padding()
    }
}

struct FilterView_Previews: PreviewProvider {
    static var previews: some View {
        FilterView()
            .environmentObject(MainViewModel())
    }
}
