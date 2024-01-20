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
    
//    @State private var scrollOffset = CGPoint.zero
    @State private var offsetDownBottomBarView: Bool = false
    @State private var lastOffsetWhenBottomBarWasChanged: Double = .zero
    
    @State private var selectedOption: OptionSelected?
    @State private var compressionSpacing: Double = 0
    @State private var canCompress: Bool = true
    
    var body: some View {
        NavigationStack {
            ScrollViewWithOffsetTracking { offset in
                
                print("offset: \(offset)")
                
                if offset.y > 100 && canCompress == true {
                    canCompress = false
                    if compressionSpacing == 40 {
                        withAnimation(.easeInOut(duration: 0.6)) {
                            compressionSpacing = 0
                        }
                    } else {
                        withAnimation(.bouncy) {
                            compressionSpacing = 40
                        }
                    }
                } else if offset.y <= 0 {
                 canCompress = true
                }
                
                // Can be optimized
                if offset.y - lastOffsetWhenBottomBarWasChanged < -40 {
                    if !offsetDownBottomBarView {
                        withAnimation(.bouncy) {
                            offsetDownBottomBarView = true
                        }
                    }
                    
                    lastOffsetWhenBottomBarWasChanged = offset.y
                } else if abs( offset.y - lastOffsetWhenBottomBarWasChanged) > 40 {
                    
                    if offsetDownBottomBarView {
                        withAnimation(.bouncy) {
                            offsetDownBottomBarView = false
                        }
                    }
                    
                    lastOffsetWhenBottomBarWasChanged = offset.y
                }
                
            } content: {
                VStack(alignment: .leading, spacing: 50 - compressionSpacing) {
                    ForEach(convos) { convo in
                        ConvoRowView(convo: convo)
                            .transition(.opacity.combined(with: .scale(scale: 0.9)).combined(with: .offset(x: -100)))
                            .environment(convosManager)
                            .id(convo)
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
                .padding(.bottom, 200)
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
//            for _ in 0...30 {
//                addItem()
//            }
            for convo in gptConvos {
                withAnimation {
                    modelContext.insert(convo)
                }
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

let gptConvos = [
    Convo(
        timestamp: Date(),
        icon: "brain.head.profile",
        title: "AI Mastery",
        lastResponse: "Taking design to the next level with cognitive assistance."
    ),
    Convo(
        timestamp: Date(),
        icon: "pencil.and.outline",
        title: "Dream Design",
        lastResponse: "Building visions with Saint Laurent Del Rey's inspirations."
    ),
    Convo(
        timestamp: Date(),
        icon: "paintbrush.pointed",
        title: "Color Theory",
        lastResponse: "AI suggests a palette inspired by Jordan Singer's taste."
    ),
    Convo(
        timestamp: Date(),
        icon: "rectangle.grid.1x2.fill",
        title: "Layout Logic",
        lastResponse: "Figuring out Figma fundamentals."
    ),
    Convo(
        timestamp: Date(),
        icon: "lightbulb.fill",
        title: "Idea Illumination",
        lastResponse: "When AI lights up the path to innovation."
    ),
    Convo(
        timestamp: Date(),
        icon: "lasso.and.sparkles",
        title: "Pixel Perfect",
        lastResponse: "AI's precision is as sharp as Laurent's style."
    ),
    Convo(
        timestamp: Date(),
        icon: "waveform.path.ecg",
        title: "Heartbeat of Design",
        lastResponse: "Putting a pulse on trends with neural networks."
    ),
    Convo(
        timestamp: Date(),
        icon: "photo.artframe",
        title: "Aesthetic Algorithm",
        lastResponse: "What would singer.ai paint in this frame?"
    ),
    Convo(
        timestamp: Date(),
        icon: "cpu",
        title: "Process: Creativity",
        lastResponse: "Powering through projects with AI as my copilot."
    ),
    Convo(
        timestamp: Date(),
        icon: "person.crop.circle.badge.checkmark",
        title: "Verified Visionary",
        lastResponse: "Jordan Singer's algorithmic autograph."
    ),
    Convo(
        timestamp: Date(),
        icon: "bolt.fill",
        title: "Energy of Excitement",
        lastResponse: "The spark that started it all - Saint Laurent Del Rey's mockup."
    ),
    Convo(
        timestamp: Date(),
        icon: "arrow.forward.square",
        title: "Future Forward",
        lastResponse: "AI predicts the next big thing in user interfaces."
    ),
    Convo(
        timestamp: Date(),
        icon: "slider.horizontal.3",
        title: "Adjusting Aesthetics",
        lastResponse: "Fine-tuning the user experience with a digital touch."
    ),
    Convo(
        timestamp: Date(),
        icon: "eyeglasses",
        title: "Insightful Interface",
        lastResponse: "Seeing the design world through AI lenses."
    ),
    Convo(
        timestamp: Date(),
        icon: "chart.bar.doc.horizontal",
        title: "Analytics of Artistry",
        lastResponse: "Charting the impact of design with AI."
    ),
    Convo(
        timestamp: Date(),
        icon: "magnifyingglass",
        title: "Detail Detective",
        lastResponse: "AI's attention to detail rivals that of Saint Laurent Del Rey."
    ),
    Convo(
        timestamp: Date(),
        icon: "link.badge.plus",
        title: "Connected Creativity",
        lastResponse: "Linking Jordan Singer's principles to my project."
    ),
    Convo(
        timestamp: Date(),
        icon: "scribble.variable",
        title: "Design Doodles",
        lastResponse: "Random AI sketches paving the way for masterpieces."
    ),
    Convo(
        timestamp: Date(),
        icon: "doc.on.clipboard",
        title: "Briefing the Bot",
        lastResponse: "AI, grasp the essence of this mockup!"
    ),
    Convo(
        timestamp: Date(),
        icon: "swift",
        title: "Swiftly Styled",
        lastResponse: "Coding a sleek UI as smooth as Saint Laurent's sketches."
    ),
    Convo(
          timestamp: Date().addingTimeInterval(-3600), // 1 hour ago
          icon: "text.bubble.fill",
          title: "Chatter with Chatbots",
          lastResponse: "Dissecting the dialogue with advanced AI."
      ),
      Convo(
          timestamp: Date().addingTimeInterval(-7200), // 2 hours ago
          icon: "network",
          title: "Linked by Logic",
          lastResponse: "Jordan Singer's designs connected in an AI web."
      ),
      Convo(
          timestamp: Date().addingTimeInterval(-10800), // 3 hours ago
          icon: "paintpalette.fill",
          title: "Palette Prodigy",
          lastResponse: "Crafting color schemes with computational creativity."
      ),
      Convo(
          timestamp: Date().addingTimeInterval(-14400), // 4 hours ago
          icon: "app.connected.to.app.below.fill",
          title: "Intertwined Interfaces",
          lastResponse: "AI and design in a harmonious dance."
      ),
      Convo(
          timestamp: Date().addingTimeInterval(-18000), // 5 hours ago
          icon: "figure.walk.diamond.fill",
          title: "Design's Runway",
          lastResponse: "AI struts on the runway of Saint Laurent Del Rey's aesthetic."
      ),
      Convo(
          timestamp: Date().addingTimeInterval(-21600), // 6 hours ago
          icon: "cube.transparent.fill",
          title: "Dimensional Design",
          lastResponse: "Venturing into 3D interfaces with AI-driven insights."
      ),
      Convo(
          timestamp: Date().addingTimeInterval(-25200), // 7 hours ago
          icon: "function",
          title: "Function meets Form",
          lastResponse: "Algorithmic artistry shaping the future of UX."
      ),
      Convo(
          timestamp: Date().addingTimeInterval(-28800), // 8 hours ago
          icon: "rectangle.3.offgrid.fill",
          title: "Boxes & Beyond",
          lastResponse: "Thinking outside the box with Jordan Singer's philosophy."
      ),
      Convo(
          timestamp: Date().addingTimeInterval(-32400), // 9 hours ago
          icon: "circle.grid.cross.fill",
          title: "Pattern Perfection",
          lastResponse: "AI decodes design patterns in Saint Laurent's mockups."
      ),
      Convo(
          timestamp: Date().addingTimeInterval(-36000), // 10 hours ago
          icon: "eyebrow",
          title: "Expressive Interfaces",
          lastResponse: "Crafting emotive UI that sings with personality."
      )
]
