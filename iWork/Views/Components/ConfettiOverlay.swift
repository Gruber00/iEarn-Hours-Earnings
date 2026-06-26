import SwiftUI

struct ConfettiOverlay: View {
    let isActive: Bool
    let trigger: Int

    private let symbols = ["sparkle", "star.fill", "circle.fill", "seal.fill"]
    private let colors: [Color] = [.green, .yellow, .blue, .pink, .purple, .orange]

    var body: some View {
        GeometryReader { proxy in
            ZStack {
                ForEach(0..<34, id: \.self) { index in
                    let startX = proxy.size.width * (0.18 + CGFloat((index * 19) % 64) / 100)
                    let endX = startX + CGFloat(((index * 37) % 120) - 60)
                    let endY = proxy.size.height * (0.24 + CGFloat((index * 13) % 58) / 100)

                    Image(systemName: symbols[index % symbols.count])
                        .font(.system(size: CGFloat(10 + (index % 5) * 4), weight: .bold))
                        .foregroundStyle(colors[index % colors.count])
                        .symbolRenderingMode(.hierarchical)
                        .rotationEffect(.degrees(isActive ? Double((index * 31) % 360) : 0))
                        .scaleEffect(isActive ? 1 : 0.35)
                        .opacity(isActive ? 0 : 1)
                        .position(x: isActive ? endX : proxy.size.width / 2, y: isActive ? endY : proxy.size.height / 2)
                        .animation(.easeOut(duration: 0.95).delay(Double(index % 7) * 0.025), value: trigger)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .allowsHitTesting(false)
        .opacity(isActive ? 1 : 0)
        .zIndex(30)
    }
}
