import SwiftUI

struct PageDots: View {
    let current: Int
    let count: Int

    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<count, id: \.self) { index in
                Capsule()
                    .fill(index == current ? Color.white : Color.white.opacity(0.4))
                    .frame(width: index == current ? 14 : 6, height: 6)
            }
        }
        .accessibilityLabel("Página \(current + 1) de \(count)")
    }
}
