import SwiftUI

struct PaymentSheet: View {
    let listing: Listing
    let onConfirm: () -> Void
    let onDismiss: () -> Void

    @State private var cardID: String? = PayCard.samples[0].id

    var body: some View {
        VStack(spacing: 6) {
            Text(listing.dish)
                .font(.system(size: 13))
                .foregroundStyle(Theme.gray)
                .lineLimit(1)

            Text(Restaurant.price)
                .font(.system(size: 26, weight: .bold))
                .foregroundStyle(.white)

            cardCarousel
                .padding(.top, 4)

            PageDots(current: cardIndex, count: PayCard.samples.count)
        }
        .padding(.top, 28)
        .padding(.bottom, 10)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
        .simultaneousGesture(dismissGesture)
    }

    private var cardIndex: Int {
        PayCard.samples.firstIndex { $0.id == cardID } ?? 0
    }

    private var cardCarousel: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 12) {
                ForEach(PayCard.samples) { card in
                    Button(action: onConfirm) {
                        cardFace(card)
                    }
                    .buttonStyle(PressedScale())
                    .accessibilityIdentifier(card.id == PayCard.samples[0].id ? "sheet" : card.id)
                    .accessibilityLabel(card.network)
                }
            }
            .scrollTargetLayout()
            .padding(.horizontal, 22)
        }
        .scrollTargetBehavior(.viewAligned)
        .scrollPosition(id: $cardID)
        .scrollIndicators(.hidden)
        .frame(height: 96)
    }

    private func cardFace(_ card: PayCard) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(card.network)
                .font(.system(size: 12, weight: .semibold))
                .lineLimit(1)
            Text(card.last4)
                .font(.system(size: 16, weight: .bold))
                .lineLimit(1)
            Spacer(minLength: 0)
        }
        .foregroundStyle(.white)
        .padding(12)
        .frame(width: 140, height: 96, alignment: .topLeading)
        .background(
            LinearGradient(colors: [card.top, card.bottom], startPoint: .topLeading, endPoint: .bottomTrailing),
            in: RoundedRectangle(cornerRadius: 12)
        )
    }

    private var dismissGesture: some Gesture {
        DragGesture(minimumDistance: 30)
            .onEnded { value in
                if value.translation.height > 36, abs(value.translation.height) > abs(value.translation.width) {
                    onDismiss()
                }
            }
    }
}

private struct PayCard: Identifiable {
    let id: String
    let network: String
    let last4: String
    let top: Color
    let bottom: Color

    static let samples = [
        PayCard(
            id: "visa",
            network: "Visa",
            last4: "4242",
            top: Color(white: 0.72),
            bottom: Color(white: 0.16)
        ),
        PayCard(
            id: "mastercard",
            network: "Mastercard",
            last4: "5555",
            top: Color(red: 0.16, green: 0.20, blue: 0.34),
            bottom: Color(red: 0.05, green: 0.07, blue: 0.16)
        ),
        PayCard(
            id: "amex",
            network: "Amex",
            last4: "0005",
            top: Color(red: 0.04, green: 0.32, blue: 0.30),
            bottom: Color(red: 0.02, green: 0.10, blue: 0.12)
        )
    ]
}
