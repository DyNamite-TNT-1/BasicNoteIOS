//
//  FilterBar.swift
//  BasicNoteIOS
//
//  Created by hanbiro on 9/12/23.
//

import SwiftUI

struct FilterBar: View {
    
    @EnvironmentObject var homeViewModel: HomeViewModel
    
    var body: some View {
        HStack {
            Image(systemName: "line.3.horizontal.decrease.circle")
                .foregroundColor(.gray)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack{
                    ForEach(homeViewModel.filterSelections) {item in
                        FilterTag(filterData: item)
                    }
                }
            }
            Spacer()
            Button {
                homeViewModel.clearFilterSelection()
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.black.opacity(0.6))
            }
        }
        .frame(height: 28)
        .padding(6)
        .background(RoundedRectangle(cornerRadius: 8)
            .foregroundColor(.gray.opacity(0.5)))
    }
}

struct FilterBar_Previews: PreviewProvider {
    static var previews: some View {
        FilterBar()
        .environmentObject(HomeViewModel())
    }
}
