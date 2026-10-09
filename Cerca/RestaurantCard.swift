import SwiftUI

struct RestaurantCard: View {
    let listing: Listing
    let isPaid: Bool
    let onPay: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("A \(listing.minutes) min")
                .font(.system(size: 13))
                .foregroundStyle(Theme.gray)
                .frame(maxWidth: .infinity, alignment: .leading)

            if listing.showsPhoto {
                Image("Causa")
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
