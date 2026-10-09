import SwiftUI

struct FoodDeck: View {
    let listings: [Listing]
    let onPass: (Listing) -> Void
    let onTake: (Listing) -> Void

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var drag = CGSize.zero
    @State private var busy = false

    var body: some View {
        ZStack {
            if let top = listings.first {
                Color.clear
                    .contentShape(Rectangle())
                    .gesture(cardDrag(top))
                FoodCard(
                    listing: top,
                    drag: drag,
                    onPass: { throwCard(top, passing: true) },
                    onTake: { throwCard(top, passing: false) }
                )
                .offset(drag)
                .rotationEffect(.degrees(Double(drag.width / 22)))
            }
        }
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
    let onPass: () -> Void
    let onTake: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 4) {
                Spacer(minLength: 0)
                Image(systemName: "location.fill")
                    .font(.system(size: 12))
                Text("\(listing.minutes) min")
                    .font(.system(size: 13))
            }
            .foregroundStyle(Theme.gray)
            .padding(.trailing, 46)

            if !listing.photo.isEmpty {
                Image(listing.photo)
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity)
                    .frame(height: 64)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(listing.dish)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.white)
                    .lineLimit(1)
                Text(listing.restaurantName)
                    .font(.system(size: 13))
                    .foregroundStyle(Theme.gray)
                    .lineLimit(1)
            }
            .padding(.top, 4)

            Text(Restaurant.price)
                .font(.system(size: 15, weight: .black))
                .foregroundStyle(.white)
                .padding(.top, 4)

            Spacer(minLength: 0)
        }
        .padding(.horizontal, 12)
        .padding(.top, 8)
        .padding(.bottom, 52)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(Color.black)
        .allowsHitTesting(false)
        .overlay(alignment: .bottom) {
            if showsGuides {
                guideRow
            }
        }
    }

    private var guideRow: some View {
        VStack(spacing: 4) {
            HStack(spacing: 9) {
                guideButton(
                    symbol: "xmark",
                    color: Theme.pass,
                    label: "Pass",
                    identifier: "pass",
                    emphasized: drag.width < -24,
                    action: onPass
                )
                Spacer(minLength: 0)
                Button(action: onTake) {
                    HStack(spacing: 3) {
                        Image(systemName: "apple.logo")
                        Text("Pay")
                            .lineLimit(1)
                    }
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.black)
                    .frame(width: 118, height: 32)
                    .background(Color.white, in: Capsule())
                    .scaleEffect(drag.width > 24 ? 1.06 : 1)
                }
                .buttonStyle(PressedScale(resting: drag.width > 24 ? 1.06 : 1))
                .accessibilityIdentifier("take")
                .accessibilityLabel("Pay")
            }
            PageDots(current: 1, count: 3)
                .frame(maxWidth: .infinity)
        }
        .padding(.horizontal, 12)
        .padding(.bottom, 10)
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
