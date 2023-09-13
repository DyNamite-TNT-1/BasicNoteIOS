//
//  FilterBar.swift
//  BasicNoteIOS
//
//  Created by hanbiro on 9/12/23.
//

import SwiftUI

struct FilterBar: View {
    
    @EnvironmentObject var mainViewModel: MainViewModel
    
    var body: some View {
        HStack {
            Image(systemName: "line.3.horizontal.decrease.circle")
                .foregroundColor(.gray)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack{
                    ForEach(mainViewModel.filterSelections) {item in
                        FilterTag(filterData: item)
                    }
                }
            }
            Spacer()
            Button {
                mainViewModel.clearSelection()
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.black.opacity(0.6))
            }
        }
        .frame(height: 20)
        .padding(6)
        .background(RoundedRectangle(cornerRadius: 8)
            .foregroundColor(.gray.opacity(0.5)))
    }
}

struct FilterBar_Previews: PreviewProvider {
    static var previews: some View {
        FilterBar()
        .environmentObject(MainViewModel())
    }
}
