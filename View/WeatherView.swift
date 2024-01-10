import SwiftUI

struct WeatherView: View {
    
    @StateObject var weatherController = WeatherController()
    
    var currentDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM"
        return "Today, \(dateFormatter.string(from: Date()))"
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                ScrollView {
                    VStack {
                        Text(currentDate)
                            .font(Font.custom("Poppins-Regular", size: 14))
                            .kerning(1)
                            .foregroundColor(Color(red: 0.74, green: 0.74, blue: 0.76))
                            .padding(.bottom, 5)
                            .padding(.top, 5)
                        
                        Image(weatherController.id > 710 || weatherController.id < 300 ? "\(weatherController.conditionIcon)" : "\(weatherController.id)")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 300, height: 300)
                            .padding(.top, 20)
                        
                        Text(weatherController.conditionDescription.capitalizedFirstLetter())
                            .font(Font.custom("Poppins-Bold", size: 30))
                            .kerning(1)
                            .multilineTextAlignment(.center)
                        
                        HStack {
                            
                            ZStack {
                                Rectangle()
                                    .foregroundColor(.clear)
                                    .frame(width: 118, height: 76)
                                    .background(.quinary)
                                    .cornerRadius(10)
                                
                                VStack {
                                    Text("Wind Speed")
                                        .font(Font.custom("Poppins-Regular", size: 12))
                                        .kerning(1)
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(Color(red: 0.74, green: 0.74, blue: 0.76))
                                    
                                    Text("\(weatherController.windSpeed, specifier: "%.1f")")
                                        .font(Font.custom("Poppins-Bold", size: 18))
                                        .kerning(1)
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(Color.accentColor)
                                        .padding(.top, 1)
                                }
                            }
                            
                            Spacer()
                            
                            ZStack {
                                Rectangle()
                                    .foregroundColor(.clear)
                                    .frame(width: 118, height: 76)
                                    .background(.quinary)
                                    .cornerRadius(10)
                                
                                VStack {
                                    Text("Temperature")
                                        .font(Font.custom("Poppins-Regular", size: 12))
                                        .kerning(1)
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(Color(red: 0.74, green: 0.74, blue: 0.76))
                                    
                                    Text("\((weatherController.temperature - 32) * 5 / 9, specifier: "%.1f")°")
                                        .font(Font.custom("Poppins-Bold", size: 18))
                                        .kerning(1)
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(Color.accentColor)
                                        .padding(.top, 1)
                                }
                            }
                            
                            Spacer()
                            
                            ZStack {
                                Rectangle()
                                    .foregroundColor(.clear)
                                    .frame(width: 118, height: 76)
                                    .background(.quinary)
                                    .cornerRadius(10)
                                
                                VStack {
                                    Text("Moisture")
                                        .font(Font.custom("Poppins-Regular", size: 12))
                                        .kerning(1)
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(Color(red: 0.74, green: 0.74, blue: 0.76))
                                    
                                    Text("\(weatherController.humidity)%")
                                        .font(Font.custom("Poppins-Bold", size: 18))
                                        .kerning(1)
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(Color.accentColor)
                                        .padding(.top, 1)
                                }
                            }
                            
                        }
                        .padding()
                        
                        VStack {
                            Text("Next 24 Hours")
                                .font(Font.custom("Poppins-Medium", size: 14))
                                .kerning(1)
                                .foregroundColor(Color(red: 0.74, green: 0.74, blue: 0.76))
                                .padding(.bottom, 5)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 15) {
                                    ForEach(weatherController.hourlyForecast.prefix(24), id: \.dt) { hourlyWeather in
                                        HourlyForecastView(hourlyWeather: hourlyWeather)
                                    }
                                }
                            }
                        }
                        .padding(.top)
                        .padding(.leading)
                        
                        Spacer()
                        
                    }
                    
                }
                .refreshable {
                    weatherController.refreshWeather()
                } 
            }
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: .infinity)
            .background(Color(red: 0.12, green: 0.12, blue: 0.12))
            .navigationBarTitleDisplayMode(.inline)
                        .toolbar {
                            ToolbarItem(placement: .principal) {
                                CustomTitleView(title: "Weather Forecast")
                            }
                        }
        }
        
    }
}

struct HourlyForecastView: View {
    
    let hourlyWeather: HourlyWeather
    
    var body: some View {
        VStack {
            Text(formattedTime(for: hourlyWeather.dt))
                .font(Font.custom("Poppins-Regular", size: 12))
                .kerning(1)
                .multilineTextAlignment(.center)
                .foregroundColor(Color(red: 0.74, green: 0.74, blue: 0.76))


            Image(imageNameForWeatherCondition(hourlyWeather.weather.first))
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
            
            Text("\((hourlyWeather.temp - 32) * 5 / 9, specifier: "%.0f")°")
                .font(Font.custom("Poppins-Bold", size: 16))
                .kerning(1)
                .multilineTextAlignment(.center)
                .foregroundColor(Color(red: 0.74, green: 0.74, blue: 0.76))
        }
        .frame(width: 74, height: 112)
        .background(.quinary)
        .cornerRadius(10)
    }
    
    func formattedTime(for timestamp: Int) -> String {
        let date = Date(timeIntervalSince1970: Double(timestamp))
        let formatter = DateFormatter()
        formatter.dateFormat = "H:mm"
        return formatter.string(from: date)
    }
    
    func imageNameForWeatherCondition(_ weatherCondition: WeatherCondition?) -> String {
        guard let condition = weatherCondition else {
            return "" // Replace with your default image name
        }
        
        if condition.id > 710 || condition.id < 300 {
            print(condition.id)
            return condition.icon + "H"
        } else {
            print(condition.id)
            return String(condition.id) + "H"
        }
    }
}

extension String {
    func capitalizedFirstLetter() -> String {
        return self.lowercased().split(separator: " ").map { $0.capitalized }.joined(separator: " ")
    }
}

struct CustomTitleView: View {
    
    @StateObject var weatherController = WeatherController()
    var title: String

    var body: some View {
        Text(weatherController.locationName)
            .font(Font.custom("Poppins-Bold", size: 24))
            .kerning(1)
    }
}

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView()
    }
}

