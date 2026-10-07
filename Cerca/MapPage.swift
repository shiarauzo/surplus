import MapKit
import SwiftUI

struct MapPage: View {
    var body: some View {
        Map(initialPosition: .region(Restaurant.region)) {
            Annotation("Tu ubicación", coordinate: Restaurant.user) {
                Circle()
                    .fill(Color.white)
                    .frame(width: 12, height: 12)
                    .overlay {
                        Circle().stroke(Theme.blue, lineWidth: 3)
                    }
            }

            ForEach(Restaurant.places) { place in
                Annotation(place.mapLabel, coordinate: place.coordinate) {
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
        .mapStyle(.standard(emphasis: .muted, pointsOfInterest: .excludingAll, showsTraffic: false))
        .environment(\.colorScheme, .dark)
        .allowsHitTesting(false)
        .overlay(alignment: .bottom) {
            LinearGradient(
                colors: [.clear, .black.opacity(0.92)],
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: 52)
            .allowsHitTesting(false)
        }
    }
}
