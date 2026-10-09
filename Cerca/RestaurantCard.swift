import SwiftUI

struct FoodDeck: View {
    let listings: [Listing]
    let onPass: (Listing) -> Void
    let onTake: (Listing) -> Void

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var drag = CGSize.zero
    @State private var busy = false

    private var reveal: CGFloat {
        min(abs(drag.width) / 90, 1)
    }

    var body: some View {
        ZStack {
            if listings.count > 1 {
                FoodCard(listing: listings[1], drag: .zero, showsGuides: false, behind: true, onPass: {}, onTake: {})
                    .scaleEffect(0.96 + (0.04 * reveal))
                    .offset(y: 22)
                    .allowsHitTesting(false)
            }

            if let top = listings.first {
                ZStack {
                    Color.clear
                        .contentShape(Rectangle())
                        .gesture(cardDrag(top))
                    FoodCard(
                        listing: top,
                        drag: drag,
                        onPass: { throwCard(top, passing: true) },
                        onTake: { throwCard(top, passing: false) }
                    )
                }
                .padding(.bottom, 26)
                .offset(drag)
                .rotationEffect(.degrees(Double(drag.width / 22)))
            }
        }
        .padding(8)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
    }

    private func cardDrag(_ listing: Listing) -> some Gesture {
        DragGesture(minimumDistance: 2)
            .onChanged { value in
                guard !busy else { return }
                drag = value.translation
            }
            .onEnded { value in
                guard !busy else { return }
                let x = value.translation.width
                let predicted = value.predictedEndTranslation.width
                if x > 28 || predicted > 70 {
                    throwCard(listing, passing: false, lift: value.translation.height)
                } else if x < -28 || predicted < -70 {
                    throwCard(listing, passing: true, lift: value.translation.height)
                } else {
                    withAnimation(.spring(duration: 0.2, bounce: 0.12)) {
                        drag = .zero
                    }
                }
            }
    }

    private func throwCard(_ listing: Listing, passing: Bool, lift: CGFloat = 0) {
        guard !busy else { return }
        if reduceMotion {
            if passing {
                onPass(listing)
            } else {
                onTake(listing)
            }
            return
        }
        busy = true
        let width: CGFloat = passing ? -420 : 420
        withAnimation(.easeOut(duration: 0.18)) {
            drag = CGSize(width: width, height: lift * 0.35)
        }
        Task {
            try? await Task.sleep(for: .milliseconds(180))
            var transaction = Transaction()
            transaction.disablesAnimations = true
            withTransaction(transaction) {
                drag = .zero
                busy = false
            }
            if passing {
                onPass(listing)
            } else {
                onTake(listing)
            }
        }
    }
}

struct FoodCard: View {
    let listing: Listing
    let drag: CGSize
    var showsGuides = true
    var behind = false
    let onPass: () -> Void
    let onTake: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("\(listing.minutes) min")
                .font(.system(size: 13))
                .foregroundStyle(Theme.gray)
                .padding(.leading, 40)
                .frame(maxWidth: .infinity, alignment: .leading)

            if !listing.photo.isEmpty {
                Image(listing.photo)
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity)
                    .frame(height: 64)
                    .clipShape(RoundedRectangle(cornerRadius: 10))

                Text(listing.dish)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.white)
                    .lineLimit(1)
            } else {
                Text(listing.dish)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundStyle(.white)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Text(listing.restaurantName)
                .font(.system(size: 13))
                .foregroundStyle(Theme.gray)
                .lineLimit(1)

            Spacer(minLength: 0)

            Text(Restaurant.price)
                .font(.system(size: 15, weight: .bold))
                .foregroundStyle(.white)
        }
        .padding(.horizontal, 12)
        .padding(.top, 8)
        .padding(.bottom, 64)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(
            Color(white: behind ? 0.22 : 0.1),
            in: RoundedRectangle(cornerRadius: 20, style: .continuous)
        )
        .overlay {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(Color.white.opacity(behind ? 0.45 : 0.16), lineWidth: behind ? 2 : 1)
        }
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .allowsHitTesting(false)
        .overlay(alignment: .bottom) {
            if showsGuides {
                guideRow
            }
        }
    }

    private var guideRow: some View {
        HStack {
                guideButton(
                    symbol: "xmark",
                    color: Theme.pass,
                    label: "Pass",
                    identifier: "pass",
                    emphasized: drag.width < -24,
                    action: onPass
                )
                Spacer()
                guideButton(
                    symbol: "checkmark",
                    color: Theme.take,
                    label: "Take",
                    identifier: "take",
                    emphasized: drag.width > 24,
                    action: onTake
                )
            }
            .padding(.horizontal, 12)
            .padding(.bottom, 22)
    }

    private func guideButton(
        symbol: String,
        color: Color,
        label: String,
        identifier: String,
        emphasized: Bool,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            Image(systemName: symbol)
                .font(.system(size: 14, weight: .bold))
                .foregroundStyle(.white)
                .frame(width: 32, height: 32)
                .background(color, in: Circle())
                .scaleEffect(emphasized ? 1.12 : 1)
        }
        .buttonStyle(PressedScale(resting: emphasized ? 1.12 : 1))
        .accessibilityIdentifier(identifier)
        .accessibilityLabel(label)
    }
}
