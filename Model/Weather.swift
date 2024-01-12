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
    var id: Int
}

struct HourlyWeather: Decodable {
    var dt: Int
    var temp: Double
    var weather: [WeatherCondition]
    var rain: [String: Double]?
    var snow: [String: Double]?
    var wind_speed: Double
    var clouds: Int
    var uvi: Double
    var feels_like: Double
    var humidity: Int
    var visibility: Int
    var pressure: Int
    var dew_point: Double
    var pop: Double

    enum CodingKeys: String, CodingKey {
        case dt, temp, weather, rain, snow, wind_speed, clouds, uvi, feels_like, humidity, visibility, pressure, dew_point, pop
    }
}

extension HourlyWeather: Identifiable {
    var id: Int { dt }
}

struct DailyWeather: Decodable {
    var dt: Int
    var temp: Temperature
    var weather: [WeatherConditionDaily]

    struct Temperature: Decodable {
        var day: Double
        var min: Double
        var max: Double
    }
}

struct WeatherConditionDaily: Decodable {
    var id: Int
    var main: String
    var description: String
    var icon: String
}

struct WeatherResponse: Decodable {
    var current: Weather
    var hourly: [HourlyWeather]
    var daily: [DailyWeather]
}


