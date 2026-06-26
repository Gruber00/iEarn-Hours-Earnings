import Foundation
import Observation
import SwiftUI

@MainActor
@Observable
final class CelebrationService {
    var isSuccessVisible = false
    var isConfettiVisible = false
    var hapticTrigger = 0
    var confettiTrigger = 0

    func playSuccessfulSaveSequence(dismiss: DismissAction) async {
        hapticTrigger += 1

        withAnimation(.bouncy(duration: 0.36, extraBounce: 0.22)) {
            isSuccessVisible = true
        }

        try? await Task.sleep(for: .milliseconds(250))

        withAnimation(.easeOut(duration: 0.2)) {
            isConfettiVisible = true
            confettiTrigger += 1
        }

        try? await Task.sleep(for: .milliseconds(800))

        withAnimation(.easeOut(duration: 0.35)) {
            isSuccessVisible = false
        }

        try? await Task.sleep(for: .milliseconds(350))

        withAnimation(.easeOut(duration: 0.25)) {
            isConfettiVisible = false
        }

        dismiss()
    }
}
