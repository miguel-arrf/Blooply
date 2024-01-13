//
//  CameraSheetView.swift
//  Blooply
//
//  Created by Miguel Ferreira on 13/01/2024.
//

import SwiftUI
import Camera_SwiftUI
import AVFoundation
import Combine

final class CameraModel: ObservableObject {
    
    private let service = CameraService()
    
    @Published var photo: Photo!
    
    @Published var showAlertError = false
    
    @Published var isFlashOn = false
    
    @Published var willCapturePhoto = false
    
    var alertError: AlertError!
    
    var session: AVCaptureSession
    
    private var subscriptions = Set<AnyCancellable>()
    
    init() {
        self.session = service.session
        
        service.$photo.sink { [weak self] (photo) in
            guard let pic = photo else { return }
            self?.photo = pic
        }
        .store(in: &self.subscriptions)
        
        service.$shouldShowAlertView.sink { [weak self] (val) in
            self?.alertError = self?.service.alertError
            self?.showAlertError = val
        }
        .store(in: &self.subscriptions)
        
        service.$flashMode.sink { [weak self] (mode) in
            self?.isFlashOn = mode == .on
        }
        .store(in: &self.subscriptions)
        
        service.$willCapturePhoto.sink { [weak self] (val) in
            self?.willCapturePhoto = val
        }
        .store(in: &self.subscriptions)
    }
    
    func configure() {
        service.checkForPermissions()
        service.configure()
    }
    
    func capturePhoto() {
        print("capturingPhoto")
        service.capturePhoto()
    }
    
    func flipCamera() {
        service.changeCamera()
    }
    
    func zoom(with factor: CGFloat) {
        service.set(zoom: factor)
    }
    
    func switchFlash() {
        service.flashMode = service.flashMode == .on ? .off : .on
    }
}


struct CameraSheetView: View {
    @StateObject var model = CameraModel()
    
    var showing: Bool = false
    var onClose: () -> Void
    
    var body: some View {
        Rectangle()
            .foregroundStyle(.clear)
        
            .overlay(alignment: .bottom, content: {
                if showing {
                    VStack(alignment: .leading) {
                        Rectangle()
                            .overlay(content: {
                                CameraPreview(session: model.session)
//                                    .scaledToFill()
//                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
//                                    .frame(minWidth: UIScreen.main.bounds.width*1.5)
//                                    .onAppear {
//                                        model.configure()
//                                    }
                                    .scaleEffect(1.4)
                                    .onAppear {
                                        model.configure()
                                    }
                            })
                            .clipped()
                    }
                    .frame(height: 600)
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
                    .overlay(alignment: .bottom, content: {
                        Rectangle()
                            .foregroundStyle(.thinMaterial)
                            .frame(height: 90)
                            .ignoresSafeArea()
                    })
//                    .overlay(alignment: .bottom, content: {
//                        VariableBlurView(direction: .blurredBottomClearTop)
//                            .frame(height: 100)
//                            .ignoresSafeArea()
//                    })
                }
            })
            .ignoresSafeArea()
    }
}

#Preview {
    CameraSheetView(onClose: {})
}
