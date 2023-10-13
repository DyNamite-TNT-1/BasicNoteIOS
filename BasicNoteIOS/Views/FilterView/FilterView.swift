//
//  FilterView.swift
//  BasicNoteIOS
//
//  Created by hanbiro on 9/12/23.
//

import SwiftUI

struct FilterView: View {
    
    @Environment(\.dismiss) private var dismiss
    let onDone: () -> Void
    let onDismiss: () -> Void
    @EnvironmentObject var homeViewModel: HomeViewModel
    
    var body: some View {
        VStack {
            FilterBar()
                .padding(.horizontal)
            List {
                ForEach(0..<homeViewModel.filterDatas.count, id: \.self) {index in
                    HStack{
                        FilterTag(filterData: homeViewModel.filterDatas[index])
                        Spacer()
                        Text(homeViewModel.filterDatas[index].localizedDescription())
                            .font(.system(size: 12))
                    }
                    .onTapGesture {
                        homeViewModel.toggleFilter(at: index)
                    }
                }
            }
            .listStyle(.plain)
        }
        .navigationTitle("filter_str")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("dismiss_str") {
                    dismiss()
                    onDismiss()
                }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("done_str") {
                    dismiss()
                    onDone()
                }
            }
        }
    }
}

struct FilterView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            FilterView(onDone: {}, onDismiss: {})
                .environmentObject(HomeViewModel())
        }
    }
}
