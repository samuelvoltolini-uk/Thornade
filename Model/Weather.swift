import Foundation

struct Weather: Decodable {
    var temperature: Double
    var weather: [WeatherCondition]
    var windSpeed: Double
    var humidity: Int

    enum CodingKeys: String, CodingKey {
        case temperature = "temp"
        case weather
        case windSpeed = "wind_speed"
        case humidity = "humidity"
    }
}

struct WeatherCondition: Decodable {
    var icon: String
    var description: String
}

struct WeatherResponse: Decodable {
    var current: Weather
}
