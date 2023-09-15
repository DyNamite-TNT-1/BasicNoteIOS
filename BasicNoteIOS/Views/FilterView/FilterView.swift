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
                    onDismiss()
                }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Done") {
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
                .environmentObject(MainViewModel())
        }
    }
}
