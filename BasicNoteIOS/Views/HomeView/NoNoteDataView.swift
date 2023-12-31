//
//  NoItemView.swift
//  BasicNoteIOS
//
//  Created by hanbiro - ANHDUC on 9/6/23.
//

import SwiftUI

struct NoNoteDataView: View {
    
    @State var animate: Bool = false
    let secondaryAccentColor = Color("SecondaryAccentColor")
    
    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                Text("no_item_title_str")
                    .font(.title)
                    .fontWeight(.semibold)
                Text("no_item_subtitle_str")
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 20)
                NavigationLink(destination: AddItemView(), label: {
                    Text("add_something_str")
                        .foregroundColor(.white)
                        .font(.headline)
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .background(animate ? secondaryAccentColor : Color.accentColor)
                        .cornerRadius(10)
                })
                .padding(.horizontal, animate ? 30 : 50)
                .shadow(
                    color: animate ? secondaryAccentColor.opacity(0.7) : Color.accentColor.opacity(0.7),
                    radius: animate ? 30 : 10,
                    x: 0.0,
                    y: animate ? 50 : 30)
                .scaleEffect(animate ? 1.1 : 1.0)
                .offset(y: animate ? -7 : 0)
            }
            .frame(maxWidth: 400)
            .padding(40)
            .onAppear(perform: addAnimation)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    func addAnimation() {
        guard !animate else {return}
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation(
                Animation
                    .easeInOut(duration: 2.0)
                    .repeatForever()
            ) {
                animate.toggle()
            }
        }
    }
}

struct NoNoteDataView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            NoNoteDataView()
                .navigationTitle("Title")
        }
    }
}
