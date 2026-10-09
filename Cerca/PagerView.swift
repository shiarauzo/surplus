import SwiftUI

struct PagerView: View {
    @State private var pageID: Int? = 0
    @State private var paidIDs: Set<String> = []
    @State private var paying: Listing?

    private var places: [Restaurant] {
        Restaurant.visiblePlaces
    }

    private var listings: [Listing] {
        places.flatMap(\.listings)
    }

    private var pageCount: Int {
        listings.isEmpty ? 1 : listings.count + 1
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView(.horizontal) {
                LazyHStack(spacing: 0) {
                    MapPage(places: places)
                        .id(0)
                        .containerRelativeFrame([.horizontal, .vertical])

                    ForEach(Array(listings.enumerated()), id: \.element.id) { offset, listing in
                        RestaurantCard(listing: listing, isPaid: paidIDs.contains(listing.id)) {
                            paying = listing
                        }
                        .id(offset + 1)
                        .containerRelativeFrame([.horizontal, .vertical])
                    }
                }
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.paging)
            .scrollPosition(id: $pageID)
            .scrollIndicators(.hidden)
            .scrollDisabled(listings.isEmpty || paying != nil)

            if !listings.isEmpty, paying == nil {
                PageDots(current: pageID ?? 0, count: pageCount)
                    .padding(.bottom, 8)
                    .allowsHitTesting(false)
            }

            if let paying {
                PaymentSheet(
                    listing: paying,
                    onConfirm: {
                        paidIDs.insert(paying.id)
                        self.paying = nil
                    },
                    onDismiss: {
                        self.paying = nil
                    }
                )
            }
        }
        .animation(.easeOut(duration: 0.2), value: paying?.id)
        .background(Color.black)
        .ignoresSafeArea()
    }
}
