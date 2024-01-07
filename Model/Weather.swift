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

struct HourlyWeather: Decodable {
    var dt: Int
    var temp: Double
    var weather: [WeatherCondition]

    enum CodingKeys: String, CodingKey {
        case dt, temp, weather
    }
}

struct WeatherResponse: Decodable {
    var current: Weather
    var hourly: [HourlyWeather]
}
