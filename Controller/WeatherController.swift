import Foundation
import CoreLocation

class WeatherController: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    @Published var temperature: Double = 0.0
    @Published var conditionDescription: String = ""
    @Published var locationName: String = "Loading..."
    @Published var conditionIcon: String = ""
    @Published var id: Int = 0
    @Published var windSpeed : Double = 0.0
    @Published var humidity : Int = 0
    @Published var hourlyForecast: [HourlyWeather] = []
    @Published var feelsLike : Double = 0.0
    
    @Published var dailyForecast: [DailyWeather] = []
    
    var lastLatitude: CLLocationDegrees?
    var lastLongitude: CLLocationDegrees?
    
    @Published var sunriseTime: Int = 0
    @Published var sunsetTime: Int = 0
    
    @Published var visibility: Double = 0.0
    @Published var pressure: Int = 0
    @Published var dew_point: Double = 0.0
    @Published var uvi: Double = 0.0
    
    @Published var clouds: Int = 0
    @Published var wind_deg: Int = 0
    @Published var wind_gust: Double = 0.0
    
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
                    self.id = weatherResponse.current.weather.first?.id ?? 0
                    self.windSpeed = weatherResponse.current.windSpeed
                    self.humidity = weatherResponse.current.humidity
                    self.hourlyForecast = weatherResponse.hourly
                    self.feelsLike = weatherResponse.current.feelsLike
                    self.sunriseTime = weatherResponse.current.sunrise
                    self.sunsetTime = weatherResponse.current.sunset
                    self.visibility = weatherResponse.current.visibility
                    self.pressure = weatherResponse.current.pressure
                    self.dew_point = weatherResponse.current.dew_point
                    self.uvi = weatherResponse.current.uvi
                    self.clouds = weatherResponse.current.clouds
                    self.wind_deg = weatherResponse.current.wind_deg
                    self.wind_gust = weatherResponse.current.wind_gust ?? 0.0
                    self.lastLatitude = latitude
                    self.lastLongitude = longitude
                    self.dailyForecast = weatherResponse.daily
                }
            }
            
        }.resume()
    }
    
    func refreshWeather() {
        guard let latitude = lastLatitude, let longitude = lastLongitude else {
            print("No last known location available.")
            return
        }

        fetchWeather(latitude: latitude, longitude: longitude)
    }
    
    func formatDate(timestamp: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE" // Format for day of the week
        return dateFormatter.string(from: date)
    }
}


