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
        .accessibilityIdentifier("hoja")
        .accessibilityLabel("Doble clic para pagar")
    }

    private var sheetContent: some View {
        VStack(spacing: 6) {
            VStack(alignment: .leading, spacing: 2) {
                Text("Visa")
                    .font(.system(size: 12))
                Text("4242")
                    .font(.system(size: 18, weight: .bold))
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(12)
            .frame(height: 68)
            .background(
                Color(red: 0.102, green: 0.145, blue: 0.275),
                in: RoundedRectangle(cornerRadius: 12)
            )

            Text(listing.dish)
                .font(.system(size: 13))
                .foregroundStyle(Theme.gray)
                .lineLimit(1)

            Text(Restaurant.price)
                .font(.system(size: 26, weight: .bold))
                .foregroundStyle(.white)

            Spacer(minLength: 0)

            Text("Doble clic para pagar")
                .font(.system(size: 12))
                .foregroundStyle(.white)
                .lineLimit(1)
        }
        .padding(16)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
        .contentShape(Rectangle())
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
