//
//  ContentView.swift
//  Blooply
//
//  Created by Miguel Ferreira on 12/01/2024.
//

import SwiftUI
import SwiftData
import ScrollKit
import Combine

enum OptionSelected: Identifiable {
    var id: Self {
        return self
    }
    
    case gallery, camera, keyboard, voice, audio
}

struct AudioSheetView: View {
    
    var onClose: () -> Void
    
    var body: some View {
        Rectangle()
            .foregroundStyle(.blue)
            .frame(height: 300)
            .transition(.move(edge: .bottom))
            .overlay(alignment: .topTrailing, content: {
                Text(Image(systemName: "xmark"))
                    .padding()
                    .onTapGesture {
                        onClose()
                    }
            })
    }
}

struct VoiceSheetView: View {
    
    var onClose: () -> Void
    
    var body: some View {
        Rectangle()
            .foregroundStyle(.blue)
            .frame(height: 300)
            .transition(.move(edge: .bottom))
            .overlay(alignment: .topTrailing, content: {
                Text(Image(systemName: "xmark"))
                    .padding()
                    .onTapGesture {
                        onClose()
                    }
            })
    }
}

struct GallerySheetView: View {
    
    var onClose: () -> Void
    
    var body: some View {
        Rectangle()
            .foregroundStyle(.blue)
            .frame(height: 300)
            .transition(.move(edge: .bottom))
            .overlay(alignment: .topTrailing, content: {
                Text(Image(systemName: "xmark"))
                    .padding()
                    .onTapGesture {
                        onClose()
                    }
            })
    }
}



struct KeyBoardSheetView: View {
    @Environment(ConvosManager.self) private var convosManager

    @State private var convoText: String = ""
    
    enum FocusedField {
            case firstName, lastName
        }
    
    @FocusState private var focusedField: FocusedField?

    var onClose: () -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                
                VStack(alignment: .leading) {
                    Text("New Thread")
                        .fontWeight(.medium)
                    Text("GPT-4")
                        .foregroundStyle(.secondary)
                    
                    TextField("Convo", text: $convoText)
                        .focused($focusedField, equals: .firstName)
                    
                }
                .onChange(of: focusedField, { old, new in
                    convosManager.setTextfieldIsPressed(new != nil)
                })
                
                Spacer()
                
                
            }
            
            Spacer()
        }
        .padding()
        .padding()
        .frame(height: 400)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            Color.init(white: 0.15)
        )
        .clipShape(RoundedRectangle(cornerRadius: 36))
        .transition(.move(edge: .bottom))
        .overlay(alignment: .topTrailing, content: {
            Text(Image(systemName: "xmark"))
                .padding()
                .padding()
                .onTapGesture {
                    onClose()
                }
        })
        .keyboardAvoiding()
    }
}


struct ContentView: View {
    @Environment(ConvosManager.self) private var convosManager
    @Environment(\.modelContext) private var modelContext
    @Query private var convos: [Convo]
    
    @State private var scrollOffset = CGPoint.zero
    @State private var offsetDownBottomBarView: Bool = false
    @State private var lastOffsetWhenBottomBarWasChanged: Double = .zero
    
    @State private var selectedOption: OptionSelected?
    
    
    var body: some View {
        NavigationStack {
            ScrollViewWithOffsetTracking { offset in
                self.scrollOffset = offset
                
                // Can be optimized
                if scrollOffset.y - lastOffsetWhenBottomBarWasChanged < -40 {
                    
                    if !offsetDownBottomBarView {
                        withAnimation(.bouncy) {
                            offsetDownBottomBarView = true
                        }
                    }
                    
                    lastOffsetWhenBottomBarWasChanged = scrollOffset.y
                } else if abs( scrollOffset.y - lastOffsetWhenBottomBarWasChanged) > 40 {
                    
                    if offsetDownBottomBarView {
                        withAnimation(.bouncy) {
                            offsetDownBottomBarView = false
                        }
                    }
                    
                    lastOffsetWhenBottomBarWasChanged = scrollOffset.y
                }
                
            } content: {
                VStack(alignment: .leading, spacing: 50) {
                    ForEach(convos) { convo in
                        ConvoRowView(convo: convo)
                            .transition(.opacity.combined(with: .scale(scale: 0.9)).combined(with: .offset(x: -100)))
                            .environment(convosManager)
                        //                    NavigationLink(value: item, label: {
                        //                        HStack {
                        //                            Text(Image(systemName: item.icon))
                        //                            Text(item.title)
                        //                        }
                        //                    })
                    }
                    .onDelete(perform: deleteItems)
                    
                    Spacer()
                }
                .padding(.top, 40)
                .animation(.smooth, value: convos)
            }
            .scrollBounceBehavior(.basedOnSize)
//            .toolbar {
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    EditButton()
//                }
//                ToolbarItem {
//                    Button(action: addItem) {
//                        Label("Add Item", systemImage: "plus")
//                    }
//                }
//            }
            .navigationDestination(for: Convo.self) { item in
                Text("Select an item")
            }
            .navigationTitle("Convos")
        }
        .overlay(alignment: .bottom, content: {
            LinearGradient(stops: [.init(color: .black, location: 0.4), .init(color: .clear, location: 1.0)], startPoint: .bottom, endPoint: .top)
                .ignoresSafeArea()
                .frame(height: 360)
                .allowsHitTesting(false)
                .offset(y: 40)
//                .opacity(selectedOption == nil ? 1 : 0)
                .offset(y: offsetDownBottomBarView ? 70 : 0)
        })
        .overlay(content: {
            Color.black
                .opacity(selectedOption == nil ? 0 : 0.4)
                .onTapGesture(perform: {
                    withAnimation {
                        selectedOption = nil
                    }
                })
        })
        .overlay(alignment: .bottom, content: {
            CameraSheetView(showing: selectedOption == .camera, onClose: {
                withAnimation(.snappy) {
                    selectedOption = nil
                }
            })
            .id("cameraView")
        })
        .overlay(alignment: .bottom, content: {
            VStack {
                Spacer()
                
                switch selectedOption {
                case .gallery:
                    GallerySheetView(onClose: {
                        withAnimation(.snappy) {
                            selectedOption = nil
                        }
                    })
                case .camera:
//                    CameraSheetView(onClose: {
//                        withAnimation(.snappy) {
//                            selectedOption = nil
//                        }
//                    })
                    EmptyView()
                case .keyboard:
                    KeyBoardSheetView(onClose: {
                        hideKeyboard()
                        withAnimation(.snappy) {
                            selectedOption = nil
                        }
                    })
                case .voice:
                    VoiceSheetView(onClose: {
                        withAnimation(.snappy) {
                            selectedOption = nil
                        }
                    })
                case .audio:
                    AudioSheetView(onClose: {
                        withAnimation(.snappy) {
                            selectedOption = nil
                        }
                    })
                case nil:
                    EmptyView()
                }
                
               
                
            }
//            .ignoresSafeArea()
            .ignoresSafeArea(.container)
            .animation(.snappy, value: selectedOption)
        })
       
        .overlay(alignment: .bottom, content: {
            BottomBarView(isDown: offsetDownBottomBarView, hasOpenSheet: selectedOption != nil, onOptionSelected: { optionSelected in
                withAnimation(.snappy) {
                    self.selectedOption = optionSelected
                }
            })
            .opacity(selectedOption == nil ? 1 : 0.8)
            .offset(y: offsetDownBottomBarView ? 70 : 0)
            .ignoresSafeArea()
            .offset(y: convosManager.textfieldIsPressed ? -26 : 0)
        })
        .preferredColorScheme(.dark)
        .onAppear {
            for _ in 0...30 {
                addItem()
            }
        }
    }
    
    private func addItem() {
        withAnimation {
            let newItem = Convo.init(timestamp: .now, icon: "desktopcomputer", title: "Understanding Quantum Computing: Basics and Byond", lastResponse: "This is a preview of the last response in this thread.")
            modelContext.insert(newItem)
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(convos[index])
            }
        }
    }
}

struct _Preview: View {
    @State private var convosManager = ConvosManager()
    var body: some View {
        ContentView()
            .modelContainer(for: Convo.self, inMemory: true)
            .environment(convosManager)
    }
}

#Preview {
    _Preview()
}
