import SwiftUI

struct RestaurantCard: View {
    let place: Restaurant
    let isPaid: Bool
    let onPay: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("A \(place.minutes) min")
                .font(.system(size: 13))
                .foregroundStyle(Theme.gray)
                .frame(maxWidth: .infinity, alignment: .leading)

            if place.showsPhoto {
                Image("Causa")
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity)
                    .frame(height: 64)
                    .clipShape(RoundedRectangle(cornerRadius: 10))

                Text(place.dish)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.white)
                    .lineLimit(1)
            } else {
                Text(place.dish)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundStyle(.white)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Text(place.name)
                .font(.system(size: 13))
                .foregroundStyle(Theme.gray)
                .lineLimit(1)

            Spacer(minLength: 0)

            Text(Restaurant.price)
                .font(.system(size: 15, weight: .bold))
                .foregroundStyle(.white)

            if isPaid {
                Text("Listo")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundStyle(Theme.blue)
                    .frame(maxWidth: .infinity)
                    .frame(height: 28)
                    .accessibilityIdentifier("listo")
                    .accessibilityLabel("Listo")
            } else {
                Button(action: onPay) {
                    Text("Apple Pay")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundStyle(.black)
                        .lineLimit(1)
                        .frame(maxWidth: .infinity)
                        .frame(height: 28)
                        .background(Color.white, in: Capsule())
                }
                .buttonStyle(.plain)
                .accessibilityIdentifier("pagar")
                .accessibilityLabel("Apple Pay")
            }
        }
        .padding(.horizontal, 12)
        .padding(.top, 8)
        .padding(.bottom, 22)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(Color.black)
    }
}
