//
//  PriorityView.swift
//  BasicNoteIOS
//
//  Created by hanbiro on 10/6/23.
//

import SwiftUI

struct PriorityView: View {
    
    @State private var selectedPriority: Priority = .none
    
    var body: some View {
        Menu {
            ForEach(0..<Priority.allCases.count, id: \.self){index in
                Button {
                    selectedPriority = Priority.allCases[index]
                } label: {
                    if (selectedPriority == Priority.allCases[index]) {
                        Label(Priority.allCases[index].rawValue, systemImage: "checkmark")
                    } else {
                        Text(Priority.allCases[index].rawValue)
                    }
                }
            }
        } label: {
            HStack{
                Text("Mức ưu tiên")
                    .foregroundColor(.black)
                Spacer()
                HStack{
                    Text(selectedPriority.rawValue)
                    Image(systemName: "arrow.up.and.down")
                }
                .foregroundColor(.gray)
            }
        }
    }
}

struct PriorityView_Previews: PreviewProvider {
    static var previews: some View {
        PriorityView()
    }
}
