//
//  BottomBarView.swift
//  Blooply
//
//  Created by Miguel Ferreira on 12/01/2024.
//

import Foundation
import SwiftUI

struct BottomBarView: View {
    var isDown: Bool = false
    var hasOpenSheet: Bool = false
    
    var onOptionSelected: (OptionSelected) -> Void
    
    @State private var galleryRippleYOffset: Double = 0
    @State private var cameraRippleYOffset: Double = 0
    @State private var keyboardRippleYOffset: Double = 0
    @State private var voiceRippleYOffset: Double = 0
    @State private var audioRippleYOffset: Double = 0

    var body: some View {
        let _ = Self._printChanges()
        
        VStack(spacing: 26) {
            
            Text("How can I help you?")
                .foregroundStyle(isDown ? .primary : .tertiary)
                .fontWeight(isDown ? .bold : .regular)
                .animation(.easeInOut, value: isDown)
                .padding(.bottom, isDown ? 26 : 0)
                .opacity(hasOpenSheet ? 0 : 0.8)
                .onTapGesture {
                    onOptionSelected(.keyboard)
                    onKeyboardOptionSelected()
                }
                .frame(maxWidth: .infinity, alignment: .center)
            
            HStack {
                Spacer()
                
                Text(Image(systemName: "photo.stack.fill"))
                    .foregroundStyle(.white)
                    .offset(y: galleryRippleYOffset)

                    .transaction { transaction in
                        transaction.animation = transaction.animation?.delay(0.12)
                    }
                    .offset(y: isDown ? 100 : 0)
                    .onTapGesture {
                        onOptionSelected(.gallery)
                        onGalleryOptionSelected()
                    }
                
               Spacer()
                
                Text(Image(systemName: "camera.fill"))
                    .foregroundStyle(.white)
                    .offset(y: cameraRippleYOffset)

                    .transaction { transaction in
                        transaction.animation = transaction.animation?.delay(0.09)
                    }
                    .offset(y: isDown ? 100 : 0)
                    .onTapGesture {
                        onOptionSelected(.camera)
                        onCameraOptionSelected()
                    }
                
                Spacer()
                
                Text(Image(systemName: "keyboard.fill"))
                    .foregroundStyle(.white)
                    .offset(y: keyboardRippleYOffset)

                    .transaction { transaction in
                        transaction.animation = transaction.animation?.delay(0.06)
                    }
                    .offset(y: isDown ? 100 : 0)
                    .onTapGesture {
                        onOptionSelected(.keyboard)
                        onKeyboardOptionSelected()
                    }
                
                Spacer()
                
                Text(Image(systemName: "waveform.badge.mic"))
                    .foregroundStyle(.white)
                    .offset(y: audioRippleYOffset)

                    .transaction { transaction in
                        transaction.animation = transaction.animation?.delay(0.03)
                    }
                    .offset(y: isDown ? 100 : 0)
                    .onTapGesture {
                        onOptionSelected(.voice)
                        onAudioOptionSelected()
                    }
                
                Spacer()
                
                Text(Image(systemName: "headphones"))
                    .foregroundStyle(.white)
                    .offset(y: voiceRippleYOffset)

                    .transaction { transaction in
                        transaction.animation = transaction.animation?.delay(0.0)
                    }
                    .offset(y: isDown ? 100 : 0)
                    .onTapGesture {
                        onOptionSelected(.audio)
                        onVoiceOptionSelected()
                    }
                
                Spacer()
            }
            .font(.title2)
            .fontWeight(.bold)
        }
    }
    
    func onKeyboardOptionSelected() {
        withAnimation(.bouncy) {
            galleryRippleYOffset = 5
            cameraRippleYOffset = 2
            keyboardRippleYOffset = -5
            audioRippleYOffset = 2
            voiceRippleYOffset = 5
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4, execute: {
            resetRippleEffect()
        })
    }
    
    func onGalleryOptionSelected() {
        withAnimation(.bouncy) {
            galleryRippleYOffset = -5
            cameraRippleYOffset = 5
            keyboardRippleYOffset = 4
            audioRippleYOffset = 3
            voiceRippleYOffset = 2
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4, execute: {
            resetRippleEffect()
        })
    }
    
    func onCameraOptionSelected() {
        withAnimation(.bouncy) {
            galleryRippleYOffset = 5
            cameraRippleYOffset = -5
            keyboardRippleYOffset = 5
            audioRippleYOffset = 4
            voiceRippleYOffset = 3
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4, execute: {
            resetRippleEffect()
        })
    }
    
    func onAudioOptionSelected() {
        withAnimation(.bouncy) {
            galleryRippleYOffset = 3
            cameraRippleYOffset = -4
            keyboardRippleYOffset = 5
            audioRippleYOffset = -5
            voiceRippleYOffset = 5
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4, execute: {
            resetRippleEffect()
        })
    }
    
    func onVoiceOptionSelected() {
        withAnimation(.bouncy) {
            galleryRippleYOffset = 2
            cameraRippleYOffset = 3
            keyboardRippleYOffset = 4
            audioRippleYOffset = 5
            voiceRippleYOffset = -5
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4, execute: {
            resetRippleEffect()
        })
    }
    
    func resetRippleEffect() {
        withAnimation(.bouncy) {
            galleryRippleYOffset = 0
            cameraRippleYOffset = 0
            keyboardRippleYOffset = 0
            audioRippleYOffset = 0
            voiceRippleYOffset = 0
        }
    }
    
}

private struct _BottomBarViewPreview: View {
    @State private var isDown: Bool = false
    
    var body: some View {
        ZStack {
            Color.pink
                .ignoresSafeArea()
            
            Button("Down", action: {
                withAnimation(.bouncy) {
                    isDown.toggle()
                }
            })
            .buttonStyle(.bordered)
            .tint(.gray)
        }
        .overlay(alignment: .bottom, content: {
            BottomBarView(isDown: isDown, onOptionSelected: {_ in})
                .preferredColorScheme(.dark)
                .offset(y: isDown ? 70 : 0)
        })
        .animation(/*@START_MENU_TOKEN@*/.easeIn/*@END_MENU_TOKEN@*/, value: isDown)
    }
}

#Preview {
   _BottomBarViewPreview()
}
