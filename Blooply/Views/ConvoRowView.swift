//
//  ConvoRowView.swift
//  Blooply
//
//  Created by Miguel Ferreira on 12/01/2024.
//

import SwiftUI

struct ConvoRowView: View {
    @Environment(ConvosManager.self) private var convosManager
    
    let convo: Convo
    
    @State private var pressing: Bool = false
    @State private var expanded: Bool = false
    @State private var longPressTimer: Timer? = nil
    
    @State private var animationTimer: Timer? = nil
    @State private var canExpand: Bool = true
    
    var body: some View {
        HStack {
            VStack(spacing: 20) {
                HStack(alignment: .top, spacing: 0) {
                    Text(Image(systemName: convo.icon))
                        .bold()
                    
                    Text(convo.title)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        .padding(.leading)
    //                    .bold()
                    
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                if expanded {
                    HStack(alignment: .top, spacing: 0) {
                        Text(Image(systemName: "arrowshape.turn.up.backward.circle.fill"))
                            .foregroundStyle(.quaternary)
                        
                        VStack(alignment: .leading, spacing: 10) {
                            Text(convo.lastResponse)
                                .foregroundStyle(.secondary)
                             
                            Text("Tap again to open")
                                .font(.caption)
                                .foregroundStyle(.quaternary)
                        }
                        .padding(.horizontal)
                        .padding(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .transition(.opacity)
                    
                }
            }
            
            Text(Image(systemName: "chevron.right"))
                .opacity(0.5)
                .bold()
        }
        .animation(.snappy, value: expanded)
        .padding(.horizontal)
        .padding(.horizontal, 8)
        .blur(radius: pressing ? 2 : 0)
        .scaleEffect(pressing ? 0.96 : 1.0)
        .animation(.snappy, value: pressing)
        .onTapGesture {
            
        }
        .onLongPressGesture(minimumDuration: 1.0, perform: {
            print("onLongPressGesture")
            
            withAnimation {
                self.expanded = !self.expanded
            }
            
            if self.expanded {
                convosManager.setExpandedConvo(convo: convo)
            }
            
        }, onPressingChanged: { value in
            self.pressing = value
        })
//        .simultaneousGesture(
//            // When the user is pressing, and if the pane is not extended, let's blur the row
//            DragGesture(minimumDistance: 0)
//                .onChanged({ pressing in
//                    if canExpand {
//                        self.pressing = true
//                        
//                        longPressTimer = Timer.scheduledTimer(withTimeInterval: 0.8, repeats: false, block: { timer in
//                            canExpand = false
//                            self.pressing = false
//                            withAnimation {
//                                self.expanded = !self.expanded
//                            }
//                            
//                            if self.expanded {
//                                convosManager.setExpandedConvo(convo: convo)
//                            }
//                        })
//                    }
//                })
//                .onEnded { _ in
//                    self.pressing = false
//                    animationTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false, block: { timer in
//                        canExpand = true
//                    })
//                    longPressTimer?.invalidate()
//                    longPressTimer = nil
//                }
//        )
        .onChange(of: convosManager.expandedConvo, { old, new in
            if new != convo {
                withAnimation {
                    self.expanded = false
                }
            }
        })
    }
}

private struct _ConvoRowViewPreview: View {
    @State private var convosManager: ConvosManager = .init()
    var body: some View {
        VStack(spacing: 30) {
            ConvoRowView(convo: .init(timestamp: .now, icon: "desktopcomputer", title: "Understanding Quantum Computing: Basics and Byond", lastResponse: "This is a preview of the last response in this thread."))
                .environment(convosManager)
            
            ConvoRowView(convo: .init(timestamp: .now, icon: "swirl.circle.righthalf.filled", title: "Exploring Space: A Discussion on Mars Colonization", lastResponse: "This is a preview of the last response in this thread."))
                .environment(convosManager)
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    _ConvoRowViewPreview()
}
