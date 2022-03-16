//
//  HomeView.swift
//  Restart
//
//  Created by Sarika on 20.02.22.
//

import SwiftUI

struct HomeView: View {
    
    @AppStorage("onboarding") var isOnBoardingViewActive : Bool = false
    @State private var isAnimating : Bool = false
    
    var body: some View {
        VStack(spacing : 20) {
            //MARK: HEADER
            Spacer()
            ZStack {
                CircleGroupView(shapeColor: .gray, shapeOpacity: 0.2)
                Image("character-2")
                    .resizable()
                    .scaledToFit()
                    .padding()
                    .offset(y: isAnimating ? 35 : -35)
                    .animation(Animation
                                .easeInOut(duration: 4)
                                .repeatForever()
                               ,value: isAnimating
                    )
            }
            
            
            //MARK: CENTER
            Text("The time that leads to mastery is dependent on the intensit yof our focus.")
                .font(.title3)
                .fontWeight(.light)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding()
            //MARK: FOOTER
             Spacer()
            
            
            Button(action: {
                withAnimation {
                    isOnBoardingViewActive = true
                }
            }) {
                
                Image(systemName: "arrow.triangle.2.circlepath.circle.fill")
                    .imageScale(.large)
                Text("Restart")
                    .font(.system(.title3, design: .rounded))
                    .fontWeight(.bold)
            }//BUTTON
            
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.capsule)
            .controlSize(.large)
            
        }//VSTACK
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7, execute: {
                isAnimating = true
            })
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
