import CoreLocation
import MapKit

struct Restaurant: Identifiable, Hashable {
    let id: String
    let name: String
    let mapName: String
    let dish: String
    let minutes: Int
    let latitude: Double
    let longitude: Double
    let showsPhoto: Bool

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    var mapLabel: String {
        "\(mapName), \(minutes) min"
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
            dish: "Arroz con pollo",
            minutes: 4,
            latitude: -12.1196,
            longitude: -77.0282,
            showsPhoto: false
        ),
        Restaurant(
            id: "menu-rosa",
            name: "Menú Rosa",
            mapName: "Rosa",
            dish: "Causa limeña",
            minutes: 10,
            latitude: -12.1262,
            longitude: -77.0348,
            showsPhoto: true
        ),
        Restaurant(
            id: "don-pan",
            name: "Don Pan",
            mapName: "Don Pan",
            dish: "Pan de yema",
            minutes: 14,
            latitude: -12.1304,
            longitude: -77.0266,
            showsPhoto: false
        ),
    ]

    static let region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: -12.1250, longitude: -77.0307),
        span: MKCoordinateSpan(latitudeDelta: 0.016, longitudeDelta: 0.014)
    )
}
