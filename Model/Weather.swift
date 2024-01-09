import Foundation

struct Weather: Decodable {
    var temperature: Double
        var weather: [WeatherCondition]
        var windSpeed: Double
        var humidity: Int
        var feelsLike: Double
        var sunrise: Int
        var sunset: Int
        var visibility: Double
        var pressure: Int
        var dew_point: Double
        var uvi: Double
        var clouds: Int
        var wind_deg: Int
        var wind_gust: Double?

    enum CodingKeys: String, CodingKey {
        case temperature = "temp"
        case weather
        case windSpeed = "wind_speed"
        case humidity = "humidity"
        case feelsLike = "feels_like"
        case sunrise = "sunrise"
        case sunset = "sunset"
        case visibility = "visibility"
        case pressure = "pressure"
        case dew_point = "dew_point"
        case uvi = "uvi"
        case clouds = "clouds"
        case wind_deg = "wind_deg"
        case wind_gust = "wind_gust"
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
