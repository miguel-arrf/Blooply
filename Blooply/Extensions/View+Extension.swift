//
//  View+Extension.swift
//  Blooply
//
//  Created by Miguel Ferreira on 13/01/2024.
//

import Foundation
import SwiftUI
import Combine

public extension Publishers {
    static var keyboardHeight: AnyPublisher<CGFloat, Never> {
        let willShow = NotificationCenter.default.publisher(for: UIApplication.keyboardWillShowNotification)
            .map { $0.keyboardHeight }
        let willHide = NotificationCenter.default.publisher(for: UIApplication.keyboardWillHideNotification)
            .map { _ in CGFloat(0) }

        return MergeMany(willShow, willHide)
            .eraseToAnyPublisher()
    }
}

public extension Notification {
    var keyboardHeight: CGFloat {
        return (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.height ?? 0
    }
}

public struct KeyboardAvoiding: ViewModifier {
    @State private var keyboardActiveAdjustment: CGFloat = 0

    public func body(content: Content) -> some View {
        content
            .safeAreaInset(edge: .bottom, spacing: keyboardActiveAdjustment) {
                EmptyView().frame(height: 0)
            }
            .onReceive(Publishers.keyboardHeight) {
                self.keyboardActiveAdjustment = min($0, 10)
            }
            .animation(.smooth, value: keyboardActiveAdjustment)
    }
}

public extension View {
    func keyboardAvoiding() -> some View {
        modifier(KeyboardAvoiding())
    }
}


/// https://www.hackingwithswift.com/quick-start/swiftui/how-to-dismiss-the-keyboard-for-a-textfield
#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif
