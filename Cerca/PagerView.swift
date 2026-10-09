import SwiftUI

private enum Screen: Hashable {
    case map
    case deck
    case boletas
}

struct PagerView: View {
    @State private var screen: Screen? = .map
    @State private var paidIDs: Set<String> = []
    @State private var skippedIDs: Set<String> = []
    @State private var pedidos: [Pedido] = []
    @State private var paying: Listing?

    private var places: [Restaurant] {
        Restaurant.visiblePlaces.filter { place in
            place.listings.contains { !paidIDs.contains($0.id) }
        }
    }

    private var listings: [Listing] {
        places.flatMap(\.listings).filter { listing in
            !paidIDs.contains(listing.id) && !skippedIDs.contains(listing.id)
        }
    }

    var body: some View {
        ZStack(alignment: .topLeading) {
            if screen == .map || places.isEmpty {
                MapPage(places: places) {
                    screen = .deck
                }
            } else {
                buyPager
                mapButton
            }

            if let paying {
                PaymentSheet(
                    listing: paying,
                    onConfirm: confirm,
                    onDismiss: { self.paying = nil }
                )
            }
        }
        .animation(.easeOut(duration: 0.2), value: screen)
        .animation(.easeOut(duration: 0.2), value: paying?.id)
        .animation(.easeOut(duration: 0.2), value: listings.isEmpty)
        .background(Color.black)
        .ignoresSafeArea()
    }

    private var buyPager: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal) {
                LazyHStack(spacing: 0) {
                    Group {
                        if listings.isEmpty {
                            EmptyDeck()
                                .transition(.opacity.combined(with: .scale(scale: 0.96)))
                        } else {
                            FoodDeck(listings: listings, onPass: pass, onTake: take)
                        }
                    }
                    .id(Screen.deck)
                    .containerRelativeFrame([.horizontal, .vertical])

                    BoletasPage(pedidos: pedidos)
                        .id(Screen.boletas)
                        .containerRelativeFrame([.horizontal, .vertical])
                }
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.paging)
            .scrollPosition(id: $screen)
            .scrollIndicators(.hidden)
            .scrollDisabled((screen == .deck && !listings.isEmpty) || paying != nil)
            .onChange(of: screen) { _, new in
                guard let new, new != .map else { return }
                proxy.scrollTo(new, anchor: .center)
            }
        }
    }

    private var mapButton: some View {
        Button {
            screen = .map
        } label: {
            Image(systemName: "map")
                .font(.system(size: 14, weight: .bold))
                .foregroundStyle(.white)
                .frame(width: 32, height: 32)
                .background(Color.white.opacity(0.16), in: Circle())
        }
        .buttonStyle(PressedScale())
        .accessibilityIdentifier("back-map")
        .accessibilityLabel("Map")
        .padding(.leading, 12)
        .padding(.top, 6)
    }

    private func pass(_ listing: Listing) {
        skippedIDs.insert(listing.id)
    }

    private func take(_ listing: Listing) {
        paying = listing
    }

    private func confirm() {
        guard let paying else { return }
        pedidos.insert(
            Pedido(
                number: String(120 + pedidos.count),
                dish: paying.dish,
                restaurantName: paying.restaurantName,
                price: Restaurant.price
            ),
            at: 0
        )
        paidIDs.insert(paying.id)
        self.paying = nil
        screen = .boletas
    }
}

struct EmptyDeck: View {
    var body: some View {
        VStack(spacing: 6) {
            Text("Nothing left")
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(.white)
            Text("No surplus")
                .font(.system(size: 13))
                .foregroundStyle(Theme.gray)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
        .accessibilityElement(children: .combine)
        .accessibilityIdentifier("deck-empty")
        .accessibilityLabel("Nothing left. No surplus")
    }
}

struct BoletasPage: View {
    let pedidos: [Pedido]

    var body: some View {
        if let pedido = pedidos.first {
            BoletaCard(pedido: pedido)
        } else {
            Text("No orders")
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.black)
                .accessibilityIdentifier("no-orders")
        }
    }
}

struct BoletaCard: View {
    let pedido: Pedido

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(pedido.number)
                .font(.system(size: 13, weight: .bold))
            Text(pedido.price)
                .font(.system(size: 26, weight: .bold))
            Text(pedido.dish)
                .font(.system(size: 15, weight: .bold))
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)
            Text(pedido.restaurantName)
                .font(.system(size: 13))
                .foregroundStyle(Color.black.opacity(0.55))
            Spacer(minLength: 0)
            Text("Pick it up")
                .font(.system(size: 13, weight: .bold))
                .lineLimit(1)
        }
        .foregroundStyle(.black)
        .padding(14)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(Color.white, in: RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal, 16)
        .padding(.vertical, 28)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
    }
}
