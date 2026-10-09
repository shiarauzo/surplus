import SwiftUI

struct PagerView: View {
    @State private var pageID: Int? = 0
    @State private var paidIDs: Set<String> = []
    @State private var paying: Restaurant?

    private var places: [Restaurant] {
        Restaurant.visiblePlaces
    }

    private var pageCount: Int {
        places.isEmpty ? 1 : places.count + 1
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView(.horizontal) {
                LazyHStack(spacing: 0) {
                    MapPage(places: places)
                        .id(0)
                        .containerRelativeFrame([.horizontal, .vertical])

                    ForEach(Array(places.enumerated()), id: \.element.id) { offset, place in
                        RestaurantCard(place: place, isPaid: paidIDs.contains(place.id)) {
                            paying = place
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
            .scrollDisabled(places.isEmpty || paying != nil)

            if !places.isEmpty, paying == nil {
                PageDots(current: pageID ?? 0, count: pageCount)
                    .padding(.bottom, 8)
                    .allowsHitTesting(false)
            }

            if let paying {
                PaymentSheet(
                    place: paying,
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
