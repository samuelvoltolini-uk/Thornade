import Foundation

struct Weather: Decodable {
    var temperature: Double

    enum CodingKeys: String, CodingKey {
        case temperature = "temp"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        temperature = try container.decode(Double.self, forKey: .temperature)
    }
}

struct WeatherResponse: Decodable {
    var main: Weather
}
