//
//  FilterTag.swift
//  BasicNoteIOS
//
//  Created by hanbiro - ANHDUC on 9/12/23.
//

import SwiftUI

struct FilterTag: View {
    
    var filterData: FilterModel
    
    var body: some View {
        Label(filterData.title, systemImage: filterData.imageName)
            .font(.caption)
            .padding(4)
            .padding(.horizontal, 4)
            .foregroundColor(.white)
            .background(RoundedRectangle(cornerRadius: 8)
                .foregroundColor(filterData.isSelected ? .accentColor : Color.black.opacity(0.6)))
            /*
             transition, this is where the withAnimation comes into play. This transition will be applied when the FilterTag is appears (inserted into the display list) and when it disappears (removed from the display list). Let's test animation in FilterView.swift.
            */
            .transition(.asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .leading)))
    }
}

struct FilterTag_Previews: PreviewProvider {
    
    static var previews: some View {
        FilterTag(filterData: FilterModel.example)
    }
}
