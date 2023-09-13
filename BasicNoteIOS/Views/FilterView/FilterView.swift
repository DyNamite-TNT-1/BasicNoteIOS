//
//  FilterView.swift
//  BasicNoteIOS
//
//  Created by hanbiro on 9/12/23.
//

import SwiftUI

struct FilterView: View {
    
    @Environment(\.dismiss) private var dismiss
    let buttonTitle: String
    let action: () -> Void
    @EnvironmentObject var mainViewModel: MainViewModel
    
    var body: some View {
        VStack {
            FilterBar()
                .padding(.horizontal)
            List {
                ForEach(0..<mainViewModel.filterDatas.count, id: \.self) {index in
                    FilterTag(filterData: mainViewModel.filterDatas[index])
                        .onTapGesture {
                            mainViewModel.toggleFilter(at: index)
                        }
                }
            }
            .listStyle(.plain)
        }
        .navigationTitle("Filter")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Dismiss") {
                    dismiss()
                }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Done") {
                    action()
                    dismiss()
                }
            }
        }
    }
}

struct FilterView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            FilterView(buttonTitle: "Filter",action: {})
                .environmentObject(MainViewModel())
        }
    }
}
