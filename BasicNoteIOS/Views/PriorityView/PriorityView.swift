//
//  PriorityView.swift
//  BasicNoteIOS
//
//  Created by hanbiro on 10/6/23.
//

import SwiftUI

struct PriorityView: View {
    
    @Binding var selectedPriority: Priority
    
    var body: some View {
        Menu {
            Button {
                selectedPriority = Priority.allCases[0]
            } label: {
                if (selectedPriority == Priority.allCases[0]) {
                    Label(Priority.allCases[0].localizedString(), systemImage: "checkmark")
                } else {
                    Text(Priority.allCases[0].localizedString())
                }
            }
            Divider()
            ForEach(1..<Priority.allCases.count, id: \.self){index in
                Button {
                    selectedPriority = Priority.allCases[index]
                } label: {
                    if (selectedPriority == Priority.allCases[index]) {
                        Label(Priority.allCases[index].localizedString(), systemImage: "checkmark")
                    } else {
                        Text(Priority.allCases[index].localizedString())
                    }
                }
            }
        } label: {
            HStack{
                Text(selectedPriority.localizedString())
                Image(systemName: "arrow.up.and.down")
            }
            .foregroundColor(.gray)
        }
    }
}

struct PriorityView_Previews: PreviewProvider {
    static var previews: some View {
        PriorityView(selectedPriority:.constant(Priority.medium))
    }
}
