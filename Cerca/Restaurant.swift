import CoreLocation
import MapKit

struct Dish: Identifiable, Hashable {
    let id: String
    let name: String
    let photo: String
}

struct Pedido: Identifiable, Hashable {
    let number: String
    let dish: String
    let restaurantName: String
    let price: String
    let when: String

    var id: String { number }
}

struct Listing: Identifiable, Hashable {
    let id: String
    let dish: String
    let photo: String
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
                photo: dish.photo,
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

    // Plate photos are cropped from Wikimedia Commons. See PhotoCredits.txt.
    static let places: [Restaurant] = [
        Restaurant(
            id: "la-olla",
            name: "The pot",
            mapName: "The pot",
            minutes: 4,
            latitude: -12.1196,
            longitude: -77.0282,
            dishes: [
                Dish(id: "arroz-con-pollo", name: "Chicken and rice", photo: "ArrozConPollo"),
                Dish(id: "aji-de-gallina", name: "Aji chicken", photo: "AjiDeGallina"),
            ]
        ),
        Restaurant(
            id: "menu-rosa",
            name: "Rosa",
            mapName: "Rosa",
            minutes: 10,
            latitude: -12.1262,
            longitude: -77.0348,
            dishes: [
                Dish(id: "causa", name: "Potato causa", photo: "Causa"),
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
                Dish(id: "pan-de-yema", name: "Egg bread", photo: "PanDeYema"),
            ]
        ),
        Restaurant(
            id: "muelle",
            name: "The dock",
            mapName: "Dock",
            minutes: 6,
            latitude: -12.1232,
            longitude: -77.0332,
            dishes: [
                Dish(id: "ceviche", name: "Ceviche", photo: "Ceviche"),
                Dish(id: "escabeche", name: "Pickled fish", photo: "Escabeche"),
            ]
        ),
        Restaurant(
            id: "brasa",
            name: "The grill",
            mapName: "Grill",
            minutes: 7,
            latitude: -12.1208,
            longitude: -77.0315,
            dishes: [
                Dish(id: "pollo-a-la-brasa", name: "Roast chicken", photo: "PolloALaBrasa"),
                Dish(id: "anticuchos", name: "Beef skewers", photo: "Anticuchos"),
                Dish(id: "lomo-saltado", name: "Stir-fried beef", photo: "LomoSaltado"),
                Dish(id: "papa-huancaina", name: "Huancaina potatoes", photo: "PapaHuancaina"),
            ]
        ),
        Restaurant(
            id: "chifa",
            name: "The wok",
            mapName: "Wok",
            minutes: 9,
            latitude: -12.1288,
            longitude: -77.0312,
            dishes: [
                Dish(id: "arroz-chaufa", name: "Fried rice", photo: "ArrozChaufa"),
                Dish(id: "tallarin-saltado", name: "Stir-fried noodles", photo: "TallarinSaltado"),
            ]
        ),
        Restaurant(
            id: "esquina",
            name: "The corner",
            mapName: "Corner",
            minutes: 12,
            latitude: -12.1222,
            longitude: -77.0258,
            dishes: [
                Dish(id: "rocoto-relleno", name: "Stuffed pepper", photo: "RocotoRelleno"),
                Dish(id: "tacu-tacu", name: "Rice and beans", photo: "TacuTacu"),
                Dish(id: "seco-de-cordero", name: "Lamb stew", photo: "SecoDeCordero"),
                Dish(id: "olluquito", name: "Ulluco stew", photo: "Olluquito"),
            ]
        ),
        Restaurant(
            id: "puesto",
            name: "The stall",
            mapName: "Stall",
            minutes: 16,
            latitude: -12.1274,
            longitude: -77.0246,
            dishes: [
                Dish(id: "pan-con-chicharron", name: "Pork sandwich", photo: "PanConChicharron"),
                Dish(id: "juane", name: "Jungle tamale", photo: "Juane"),
            ]
        ),
        Restaurant(
            id: "dulce",
            name: "The bakery",
            mapName: "Bakery",
            minutes: 18,
            latitude: -12.1182,
            longitude: -77.0264,
            dishes: [
                Dish(id: "picarones", name: "Squash fritters", photo: "Picarones"),
                Dish(id: "suspiro", name: "Lima dessert", photo: "SuspiroLimeno"),
            ]
        ),
    ]

    static let region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: -12.1250, longitude: -77.0307),
        span: MKCoordinateSpan(latitudeDelta: 0.016, longitudeDelta: 0.014)
    )
}
