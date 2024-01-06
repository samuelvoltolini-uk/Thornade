import Foundation

struct Weather: Decodable {
    var temperature: Double
    var weather: [WeatherCondition]

    enum CodingKeys: String, CodingKey {
        case temperature = "temp"
        case weather
    }
}

struct WeatherCondition: Decodable {
    var description: String
}

struct WeatherResponse: Decodable {
    var current: Weather
}
