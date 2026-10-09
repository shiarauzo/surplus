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
                if screen == .deck, !listings.isEmpty {
                    mapButton
                }
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
                            EmptyDeck(onBack: { screen = .map })
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
                price: Restaurant.price,
                when: Self.pickupClock()
            ),
            at: 0
        )
        paidIDs.insert(paying.id)
        self.paying = nil
        screen = .boletas
    }

    private static func pickupClock() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "h:mm a"
        formatter.amSymbol = "am"
        formatter.pmSymbol = "pm"
        return formatter.string(from: Date())
    }
}

struct EmptyDeck: View {
    var onBack: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Text("No restaurants nearby")
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .accessibilityIdentifier("deck-empty")
            Button(action: onBack) {
                Text("Back")
                    .font(.system(size: 14))
                    .foregroundStyle(.white)
                    .lineLimit(1)
                    .frame(width: 118, height: 32)
                    .overlay {
                        Capsule().stroke(Color.white, lineWidth: 1)
                    }
            }
            .buttonStyle(PressedScale())
            .accessibilityIdentifier("back")
        }
        .padding(.horizontal, 16)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
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
        VStack(spacing: 4) {
            receipt
                .padding(.top, 18)
            Spacer(minLength: 0)
            PageDots(current: 2, count: 3)
        }
        .padding(.horizontal, 18)
        .padding(.top, 8)
        .padding(.bottom, 10)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
        .accessibilityElement(children: .contain)
        .accessibilityIdentifier("boleta")
    }

    private var receipt: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(pedido.price)
                .font(.system(size: 26, weight: .black))
                .padding(.bottom, 4)
            Text(pedido.dish)
                .font(.system(size: 16))
                .lineLimit(2)
            Text(pedido.when)
                .font(.system(size: 16))
                .lineLimit(1)
            Text(pedido.restaurantName)
                .font(.system(size: 13))
                .foregroundStyle(Theme.link)
                .underline()
                .lineLimit(1)
        }
        .foregroundStyle(.black)
        .padding(.horizontal, 14)
        .padding(.top, 18)
        .padding(.bottom, 22)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white, in: ReceiptShape())
    }
}

struct ReceiptShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let tooth: CGFloat = 8
        let count = 10
        let step = rect.width / CGFloat(count)
        path.move(to: .zero)
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: rect.height - tooth))
        for index in stride(from: count, through: 0, by: -1) {
            let x = CGFloat(index) * step
            let y = index.isMultiple(of: 2) ? rect.height : rect.height - tooth
            path.addLine(to: CGPoint(x: x, y: y))
        }
        path.closeSubpath()
        return path
    }
}
