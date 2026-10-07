import SwiftUI

struct RestaurantCard: View {
    let place: Restaurant

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            TimelineView(.everyMinute) { context in
                Text(context.date, format: .dateTime.hour().minute())
                    .font(.system(size: 12))
                    .foregroundStyle(Theme.gray)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }

            Text("A \(place.minutes) min")
                .font(.system(size: 14))
                .foregroundStyle(Theme.gray)

            if place.showsPhoto {
                Image("Causa")
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity)
                    .frame(height: 78)
                    .clipShape(RoundedRectangle(cornerRadius: 10))

                Text(place.dish)
                    .font(.system(size: 16))
                    .foregroundStyle(Theme.name)
            } else {
                Text(place.dish)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(.white)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Text(place.name)
                .font(.system(size: 14))
                .foregroundStyle(Theme.gray)

            Spacer(minLength: 0)

            Text(Restaurant.price)
                .font(.system(size: 15, weight: .bold))
                .foregroundStyle(.white)
        }
        .padding(.horizontal, 12)
        .padding(.top, 8)
        .padding(.bottom, 22)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(Color.black)
    }
}
