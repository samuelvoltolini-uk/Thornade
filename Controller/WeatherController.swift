import Foundation

class WeatherController: ObservableObject {
    @Published var temperature: Double = 0.0

    func fetchWeather() {
        let apiKey = "b6d39353e34c61f3946bc54d591c1656"
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=London&appid=\(apiKey)&units=metric"
        
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }

            if let weatherResponse = try? JSONDecoder().decode(WeatherResponse.self, from: data) {
                DispatchQueue.main.async {
                    self.temperature = weatherResponse.main.temperature
                }
            }
        }.resume()
    }
}
