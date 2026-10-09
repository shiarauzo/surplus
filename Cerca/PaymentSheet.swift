import SwiftUI

struct PaymentSheet: View {
    let listing: Listing
    let onConfirm: () -> Void
    let onDismiss: () -> Void

    var body: some View {
        Button(action: onConfirm) {
            sheetContent
        }
        .buttonStyle(.plain)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
        .highPriorityGesture(dismissGesture)
        .accessibilityIdentifier("sheet")
        .accessibilityLabel("Double click to pay")
    }

    private var sheetContent: some View {
        VStack(spacing: 6) {
            Text(listing.dish)
                .font(.system(size: 13))
                .foregroundStyle(Theme.gray)
                .lineLimit(1)

            Text(Restaurant.price)
                .font(.system(size: 26, weight: .bold))
                .foregroundStyle(.white)

            cardStack
                .padding(.top, 4)

            Spacer(minLength: 0)

            Text("Double click to pay")
                .font(.system(size: 12))
                .foregroundStyle(.white)
                .lineLimit(1)
        }
        .padding(.horizontal, 16)
        .padding(.top, 28)
        .padding(.bottom, 8)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
        .contentShape(Rectangle())
    }

    private var cardStack: some View {
        ZStack(alignment: .bottom) {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.white.opacity(0.2))
                .frame(width: 84, height: 44)
                .offset(y: -44)
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(red: 0.043, green: 0.141, blue: 0.878).opacity(0.6))
                .frame(width: 104, height: 52)
                .offset(y: -28)
            RoundedRectangle(cornerRadius: 8)
                .fill(
                    LinearGradient(
                        colors: [Color(white: 0.91), Color(white: 0.08)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 140, height: 72)
                .overlay(alignment: .topLeading) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Visa")
                            .font(.system(size: 12, weight: .semibold))
                        Text("4242")
                            .font(.system(size: 16, weight: .bold))
                    }
                    .foregroundStyle(.white)
                    .padding(12)
                }
        }
        .frame(height: 88)
    }

    private var dismissGesture: some Gesture {
        DragGesture(minimumDistance: 30)
            .onEnded { value in
                if value.translation.height > 36 {
                    onDismiss()
                }
            }
    }
}
