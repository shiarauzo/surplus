import SwiftUI

struct PagerView: View {
    @State private var pageID: Int? = 0

    private var pageCount: Int {
        Restaurant.places.count + 1
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView(.horizontal) {
                LazyHStack(spacing: 0) {
                    MapPage()
                        .id(0)
                        .containerRelativeFrame([.horizontal, .vertical])

                    ForEach(Array(Restaurant.places.enumerated()), id: \.element.id) { offset, place in
                        RestaurantCard(place: place)
                            .id(offset + 1)
                            .containerRelativeFrame([.horizontal, .vertical])
                    }
                }
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.paging)
            .scrollPosition(id: $pageID)
            .scrollIndicators(.hidden)

            PageDots(current: pageID ?? 0, count: pageCount)
                .padding(.bottom, 8)
                .allowsHitTesting(false)
        }
        .background(Color.black)
        .ignoresSafeArea()
    }
}
