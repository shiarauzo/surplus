import CoreLocation
import MapKit

struct Dish: Identifiable, Hashable {
    let id: String
    let name: String
    let showsPhoto: Bool
}

struct Listing: Identifiable, Hashable {
    let id: String
    let dish: String
    let showsPhoto: Bool
    let restaurantID: String
    let restaurantName: String
    let minutes: Int
}

struct Restaurant: Identifiable, Hashable {
    let id: String
    let name: String
    let mapName: String
    let minutes: Int
    let latitude: Double
    let longitude: Double
    let dishes: [Dish]

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    var mapLabel: String {
        "\(mapName), \(minutes) min"
    }

    var listings: [Listing] {
        dishes.map { dish in
            Listing(
                id: dish.id,
                dish: dish.name,
                showsPhoto: dish.showsPhoto,
                restaurantID: id,
                restaurantName: name,
                minutes: minutes
            )
        }
    }

    static let price = "S/ 8.50"

    static var visiblePlaces: [Restaurant] {
        if ProcessInfo.processInfo.arguments.contains("--empty") {
            return []
        }
        return places
    }

    static let user = CLLocationCoordinate2D(latitude: -12.1218, longitude: -77.0299)

    static let places: [Restaurant] = [
        Restaurant(
            id: "la-olla",
            name: "La olla",
            mapName: "La olla",
            minutes: 4,
            latitude: -12.1196,
            longitude: -77.0282,
            dishes: [
                Dish(id: "arroz-con-pollo", name: "Arroz con pollo", showsPhoto: false),
                Dish(id: "aji-de-gallina", name: "Ají de gallina", showsPhoto: false),
            ]
        ),
        Restaurant(
            id: "menu-rosa",
            name: "Menú Rosa",
            mapName: "Rosa",
            minutes: 10,
            latitude: -12.1262,
            longitude: -77.0348,
            dishes: [
                Dish(id: "causa", name: "Causa limeña", showsPhoto: true),
            ]
        ),
        Restaurant(
            id: "don-pan",
            name: "Don Pan",
            mapName: "Don Pan",
            minutes: 14,
            latitude: -12.1304,
            longitude: -77.0266,
            dishes: [
                Dish(id: "pan-de-yema", name: "Pan de yema", showsPhoto: false),
            ]
        ),
    ]

    static let region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: -12.1250, longitude: -77.0307),
        span: MKCoordinateSpan(latitudeDelta: 0.016, longitudeDelta: 0.014)
    )
}
