import MapKit
import SwiftUI

struct MapPage: View {
    var places: [Restaurant]
    var onFoods: () -> Void

    @State private var position: MapCameraPosition = .region(Restaurant.region)

    var body: some View {
        if places.isEmpty {
            VStack(spacing: 6) {
                Text("Nothing nearby")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(.white)
                Text("No listings")
                    .font(.system(size: 13))
                    .foregroundStyle(Theme.gray)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.black)
            .accessibilityElement(children: .combine)
            .accessibilityIdentifier("empty")
            .accessibilityLabel("Nothing nearby. No listings")
        } else {
            map
        }
    }

    private var map: some View {
        Map(position: $position) {
            Annotation("", coordinate: Restaurant.user) {
                Circle()
                    .fill(Color.white)
                    .frame(width: 12, height: 12)
                    .overlay {
                        Circle().stroke(Theme.blue, lineWidth: 3)
                    }
            }

            ForEach(places) { place in
                Annotation("", coordinate: place.coordinate) {
                    HStack(spacing: 4) {
                        Circle()
                            .fill(Theme.pin)
                            .frame(width: 8, height: 8)
                        Text(place.mapLabel)
                            .font(.system(size: 10, weight: .bold))
                            .foregroundStyle(.white)
                            .lineLimit(1)
                    }
                    .padding(.horizontal, 6)
                    .padding(.vertical, 3)
                    .background(Color(red: 0.063, green: 0.063, blue: 0.082), in: RoundedRectangle(cornerRadius: 8))
                    .overlay {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                    }
                }
            }
        }
        .mapStyle(.standard(pointsOfInterest: .excludingAll, showsTraffic: false))
        .environment(\.colorScheme, .dark)
        .accessibilityIdentifier("map")
        .overlay(alignment: .bottom) {
            Button(action: onFoods) {
                Text("Foods")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.white)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity)
                    .frame(height: 36)
                    .background(Theme.blue, in: Capsule())
            }
            .buttonStyle(PressedScale())
            .accessibilityIdentifier("foods")
            .padding(.horizontal, 16)
            .padding(.bottom, 12)
        }
    }
}
