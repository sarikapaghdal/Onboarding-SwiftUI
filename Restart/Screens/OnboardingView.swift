//
//  OnboardingView.swift
//  Restart
//
//  Created by Sarika on 20.02.22.
//

import SwiftUI

struct OnboardingView: View {
    
    @AppStorage("onboarding") var isOnBoardingViewActive : Bool = true
    
    @State private var buttonWidth : Double = UIScreen.main.bounds.width - 80
    @State private var buttonOffSet : CGFloat = 0
    @State private var isAnimating : Bool = false
    @State private var imageOffset : CGSize = .zero //both width and height are zero
    @State private var indicatorOppacity : Double = 1.0
    @State private var textTitle : String = "Share."
    let hapticFeedback = UINotificationFeedbackGenerator()
    
    var body: some View {
        ZStack {
            Color("ColorBlue")
                .ignoresSafeArea(.all, edges: .all)
            VStack(spacing : 20) {
                
                //MARK : Header
                
                Spacer()
                VStack(spacing : 0){
                    Text(textTitle)
                        .font(.system(size: 60))
                        .fontWeight(.heavy)
                        .foregroundColor(.white)
                        .transition(.opacity)
                        .id(textTitle) // unique identification for TextView to tell the compiler that this view is different after its value change and triggers oppacity transition.
                    
                    Text("""
                         It's not how much we give but
                         how much love we put into giving.
                        """)
                        .font(.title3)
                        .fontWeight(.light)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal,10)
                }//:HEADER
                    .opacity(isAnimating ? 1 : 0)
                    .offset(y: isAnimating ? 0 : -40)
                    .animation(.easeOut(duration: 1), value: isAnimating)
                
                //MARK : Center
                ZStack{
        
                    CircleGroupView(shapeColor: .white, shapeOpacity: 0.2)
                    //Paralex effect
                        .offset(x : imageOffset.width * -1)
                        .blur(radius: abs(imageOffset.width / 5))
                        .animation(.easeOut(duration: 1), value: imageOffset)
                    
                    Image("character-1")
                        .resizable()
                        .scaledToFit()
                        .opacity(isAnimating ? 1 : 0)
                        .animation(.easeOut(duration: 0.5), value: isAnimating)
                        .offset(x: imageOffset.width * 1.2, y: 0)
                        .rotationEffect(.degrees(Double(imageOffset.width / 20)))
                        .gesture(
                            DragGesture()
                                .onChanged {gesture in
                                    if abs(imageOffset.width) <= 150 { //limiting the draging of image by some points on screen otherwise user can drag endlessly and image will be invisible.
                                        imageOffset = gesture.translation
                                        
                                        
                                        withAnimation(.linear(duration: 0.25)){
                                            indicatorOppacity = 0
                                            textTitle = "Give."
                                        }
                                    }
                                }
                                .onEnded({ _ in
                                    imageOffset = .zero
                                    
                                    withAnimation(.linear(duration: 0.25)){
                                        indicatorOppacity = 1
                                        textTitle = "share."
                                    }
                                })
                        )
                        .animation(.easeOut(duration: 1), value: imageOffset)
                }
                .overlay(
                    Image(systemName: "arrow.right.arrow.left.circle")
                        .font(.system(size: 44, weight : .ultraLight))
                        .foregroundColor(.white)
                        .offset(y: 0)
                        .opacity(isAnimating ? 1 : 0)
                        .animation(.easeOut(duration: 1).delay(2), value: isAnimating)
                        .opacity(indicatorOppacity)
                    ,alignment: .bottom
                )
                 Spacer()
                //MARK : Footer
                
                ZStack{
                    //Part of the custom button
                    Capsule()
                        .fill(.white.opacity(0.2))
                    Capsule()
                        .fill(.white.opacity(0.2))
                        .padding(8)
                    //1. Background static
                    //2.Call to action(Static)
                    
                    Text("Get Started")
                        .font(.system(.title3,design: .rounded))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .offset(x: 20)
                    //3.Capsule (Dynamic width)
                    HStack{
                    Capsule()
                        .fill(Color("ColorRed"))
                        .frame(width: buttonOffSet + 80)
                    Spacer()
                    }
                    //4. Circle (Draggable)
                        
                    HStack {
                        ZStack{
                            Circle()
                                .fill(Color("ColorRed"))
                            Circle()
                                .fill(.black.opacity(0.15))
                                .padding(8)
                            Image(systemName: "chevron.right.2")
                                .font(.system(size: 24,weight: .bold))
                            }
                            .foregroundColor(.white)
                            .frame(width: 80, height: 80, alignment: .center)
                            .offset(x: buttonOffSet) //automatic view update
                            .gesture(
                                //Draggesture has 2 states! one is gesture taken place and another is drag completed
                                DragGesture()
                                    .onChanged({ gesture in //gesture has info about actual movement
                                        if (gesture.translation.width > 0 && buttonOffSet <= buttonWidth - 80){ //dragging started in the right direction
                                            buttonOffSet = gesture.translation.width
                                        }
                                    })
                                
                                    .onEnded({ _ in
                                        withAnimation(Animation.easeOut(duration: 0.4)){
                                            if (buttonOffSet > buttonWidth / 2) {
                                                hapticFeedback.notificationOccurred(.success)
                                                playSound(sound: "chimeup", Type: "mp3")
                                                buttonOffSet = buttonWidth - 80
                                                isOnBoardingViewActive = false
                                            }
                                            else {
                                                hapticFeedback.notificationOccurred(.warning)
                                                buttonOffSet = 0
                                            }
                                        }
                                    })
                            )//Gesture
                        Spacer()
                    }//:HSTACK
                }//:FOOTER
                    
                .frame(width: buttonWidth, height: 80, alignment: .center)
                .padding()
                .opacity(isAnimating ? 1 : 0)
                .offset(y: isAnimating ? 0 : 40)
                .animation(.easeOut(duration: 1), value: isAnimating)
            }//Vstack
        } //Zstack
        .onAppear {
            isAnimating = true
        }
        .preferredColorScheme(.dark)
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
