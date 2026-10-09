import SwiftUI

struct FoodDeck: View {
    let listings: [Listing]
    let onPass: (Listing) -> Void
    let onTake: (Listing) -> Void

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var drag = CGSize.zero
    @State private var busy = false
    @State private var armedID: String?

    var body: some View {
        ZStack {
            if let top = listings.first {
                Color.clear
                    .contentShape(Rectangle())
                    .gesture(cardDrag(top))
                FoodCard(
                    listing: top,
                    drag: drag,
                    showsPay: armedID == top.id,
                    onPass: { throwCard(top) },
                    onCheck: { arm(top) },
                    onPay: { onTake(top) }
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
                    choose(listing)
                } else if x < -28 || predicted < -70 {
                    throwCard(listing, lift: value.translation.height)
                } else {
                    withAnimation(.spring(duration: 0.2, bounce: 0.12)) {
                        drag = .zero
                    }
                }
            }
    }

    private func choose(_ listing: Listing) {
        if armedID == listing.id {
            onTake(listing)
        } else {
            arm(listing)
        }
        withAnimation(.spring(duration: 0.2, bounce: 0.12)) {
            drag = .zero
        }
    }

    private func arm(_ listing: Listing) {
        withAnimation(.easeOut(duration: 0.2)) {
            armedID = listing.id
        }
    }

    private func throwCard(_ listing: Listing, lift: CGFloat = 0) {
        guard !busy else { return }
        if reduceMotion {
            onPass(listing)
            return
        }
        busy = true
        withAnimation(.easeOut(duration: 0.18)) {
            drag = CGSize(width: -420, height: lift * 0.35)
        }
        Task {
            try? await Task.sleep(for: .milliseconds(180))
            var transaction = Transaction()
            transaction.disablesAnimations = true
            withTransaction(transaction) {
                drag = .zero
                busy = false
                if armedID == listing.id {
                    armedID = nil
                }
            }
            onPass(listing)
        }
    }
}

struct FoodCard: View {
    let listing: Listing
    let drag: CGSize
    var showsGuides = true
    var showsPay = false
    let onPass: () -> Void
    let onCheck: () -> Void
    let onPay: () -> Void

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
                if showsPay {
                    Button(action: onPay) {
                        HStack(spacing: 3) {
                            Image(systemName: "apple.logo")
                            Text("Pay")
                                .lineLimit(1)
                        }
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(.black)
                        .frame(width: 118, height: 32)
                        .background(Color.white, in: Capsule())
                    }
                    .buttonStyle(PressedScale())
                    .accessibilityIdentifier("pay")
                    .accessibilityLabel("Pay")
                    .transition(.opacity.combined(with: .scale(scale: 0.96)))
                } else {
                    guideButton(
                        symbol: "checkmark",
                        color: Theme.take,
                        label: "Take",
                        identifier: "take",
                        emphasized: drag.width > 24,
                        action: onCheck
                    )
                }
            }
            .animation(.easeOut(duration: 0.2), value: showsPay)
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
