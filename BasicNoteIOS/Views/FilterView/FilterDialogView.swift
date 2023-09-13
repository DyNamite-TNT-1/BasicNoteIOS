//
//  FilterView.swift
//  BasicNoteIOS
//
//  Created by hanbiro on 9/12/23.
//

import SwiftUI

struct FilterDialogView: View {
    
    @Binding var isActive: Bool
    let buttonTitle: String
    let action: () -> Void
    @EnvironmentObject var mainViewModel: MainViewModel
    @State private var offset: CGFloat = 1000
    
    var body: some View {
        ZStack {
            Color(.black)
                .opacity(0.5)
                .onTapGesture {
                    close()
                }
            VStack {
                Text("Filter Dialog")
                    .font(.title2)
                    .bold()
                    .padding()
                FilterBar()
                List {
                    ForEach(0..<mainViewModel.filterDatas.count, id: \.self) {index in
                        FilterTag(filterData: mainViewModel.filterDatas[index])
                            .onTapGesture {
                                mainViewModel.toggleFilter(at: index)
                            }
                    }
                }
                Button {
                    action()
                    close()
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundColor(.red)
                        Text(buttonTitle)
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                    }
                    .padding()
                }
            }
            .frame(height: 300)
            .padding()
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .overlay(alignment: .topTrailing){
                Button{
                    close()
                } label: {
                    Image(systemName: "xmark")
                        .font(.title2)
                        .fontWeight(.medium)
                }
                .tint(.black)
                .padding()
            }
            .shadow(radius: 20)
            .padding(30)
            .offset(x:0, y: offset)
            .onAppear {
                withAnimation(.spring()) {
                    offset = 0
                }
            }
        }
        .ignoresSafeArea()
    }
    
    func close() {
        withAnimation(.spring()) {
            offset = 1000
            isActive = false
        }
    }
}

struct FilterView_Previews: PreviewProvider {
    static var previews: some View {
        FilterDialogView(isActive: .constant(true), buttonTitle: "Filter",action: {})
            .environmentObject(MainViewModel())
    }
}
