import Foundation
import CoreLocation

class WeatherController: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    @Published var temperature: Double = 0.0
    @Published var conditionDescription: String = ""
    @Published var locationName: String = "Loading..."
    @Published var conditionIcon: String = ""
    @Published var windSpeed : Double = 0.0
    @Published var humidity : Int = 0
    @Published var hourlyForecast: [HourlyWeather] = []
    
    private let locationManager = CLLocationManager()

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            fetchWeather(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
                guard let self = self, error == nil else { return }
                if let placemark = placemarks?.first, let town = placemark.locality {
                    DispatchQueue.main.async {
                        self.locationName = town
                    }
                }
            }

            locationManager.stopUpdatingLocation()
        }
    }

    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let apiKey = "b6d39353e34c61f3946bc54d591c1656"
        let urlString = "https://api.openweathermap.org/data/3.0/onecall?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)&units=imperial"
        
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }

            if let weatherResponse = try? JSONDecoder().decode(WeatherResponse.self, from: data) {
                DispatchQueue.main.async {
                    self.temperature = weatherResponse.current.temperature
                    self.conditionDescription = weatherResponse.current.weather.first?.description ?? ""
                    self.conditionIcon = weatherResponse.current.weather.first?.icon ?? ""
                    self.windSpeed = weatherResponse.current.windSpeed
                    self.humidity = weatherResponse.current.humidity
                    self.hourlyForecast = weatherResponse.hourly
                }
            }
            
        }.resume()
    }
}


