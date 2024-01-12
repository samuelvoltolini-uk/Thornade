import SwiftUI

struct NextDaysWeatherView: View {
    
    @StateObject var weatherController = WeatherController()
    
    var body: some View {
        NavigationView {
            ZStack {
                ScrollView {
                    VStack {
                        ForEach(0..<min(8, weatherController.dailyForecast.count), id: \.self) { index in
                            let dayWeather = weatherController.dailyForecast[index]
                            let weatherConditionDaily = dayWeather.weather.first

                            GeometryReader { geometry in
                                ZStack {
                                    Rectangle()
                                        .foregroundColor(.clear)
                                        .frame(height: 60)
                                        .background(.quinary)
                                        .cornerRadius(10)

                                    HStack {
                                        Text(weatherController.formatDate(timestamp: dayWeather.dt))
                                            .font(Font.custom("Poppins-Regular", size: 12))
                                            .kerning(1)
                                            .foregroundColor(Color(red: 0.74, green: 0.74, blue: 0.76))
                                            .padding(.leading, 10)

                                        Spacer()

                                        Text("\(weatherController.convertToFahrenheit(fahrenheit: dayWeather.temp.min), specifier: "%.0f")°")
                                            .font(Font.custom("Poppins-Bold", size: 14))
                                            .kerning(1)
                                            .foregroundColor(Color(red: 0.74, green: 0.74, blue: 0.76))

                                        TemperatureBar(minTemp: weatherController.convertToFahrenheit(fahrenheit: dayWeather.temp.min), maxTemp: weatherController.convertToFahrenheit(fahrenheit: dayWeather.temp.max))
                                            .frame(width: 110, height: 5)
                                            .cornerRadius(5)

                                        Text("\(weatherController.convertToFahrenheit(fahrenheit: dayWeather.temp.max), specifier: "%.0f")°")
                                            .font(Font.custom("Poppins-Bold", size: 14))
                                            .kerning(1)
                                            .foregroundColor(Color(red: 0.74, green: 0.74, blue: 0.76))
                                            .padding(.trailing, 10)
                                    }

                                    // Centered Image
                                    if let conditionDaily = weatherConditionDaily {
                                        Image(weatherController.getImageForWeather(condition: conditionDaily))
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 35, height: 35)
                                            .position(x: geometry.size.width / 2.5, y: geometry.size.height / 2)
                                    }
                                }
                            }
                            .frame(height: 60)
                            .padding(.bottom, 5)
                            .padding(.horizontal)
                        }
                    }
                    .padding(.top, 20)
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

struct TemperatureBar: View {
    var minTemp: Double
    var maxTemp: Double

    private func color(for temperature: Double) -> Color {
        switch temperature {
        case ..<(-15): return Color(red: 0.0, green: 0.0, blue: 0.5) // Dark Blue
        case -15..<(-10): return Color(red: 0.0, green: 0.0, blue: 0.75) // Medium Blue
        case -10..<(-5): return Color(red: 0.0, green: 0.0, blue: 1.0) // Blue
        case -5..<0: return Color(red: 0.5, green: 0.5, blue: 1.0) // Light Blue
        case 0..<5: return Color(red: 0.75, green: 0.75, blue: 1.0) // Very Light Blue
        case 5..<10: return Color(red: 0.0, green: 1.0, blue: 0.0) // Green
        case 10..<15: return Color(red: 1.0, green: 1.0, blue: 0.0) // Yellow
        case 15..<20: return Color(red: 1.0, green: 0.5, blue: 0.0) // Orange
        case 20..<25: return Color(red: 1.0, green: 0.0, blue: 0.0) // Red
        case 25..<30: return Color(red: 1.0, green: 0.0, blue: 0.5) // Pink
        case 30..<35: return Color(red: 0.5, green: 0.0, blue: 0.5) // Purple
        case 35...: return Color(red: 0.5, green: 0.0, blue: 0.0) // Dark Red
        default: return .gray // Default case
        }
    }

    var body: some View {
        let minColor = color(for: minTemp)
        let maxColor = color(for: maxTemp)

        RoundedRectangle(cornerRadius: 5)
            .fill(LinearGradient(gradient: Gradient(colors: [minColor, maxColor]), startPoint: .leading, endPoint: .trailing))
    }
}

extension WeatherController {
    func convertToFahrenheit(fahrenheit: Double) -> Double {
        return (fahrenheit - 32) * 5 / 9
    }

    func getImageForWeather(condition: WeatherConditionDaily) -> String {
        if condition.id > 710 || condition.id < 300 {
            return condition.icon + "H"
        } else {
            return "\(condition.id)H"
        }
    }
}

// For preview
struct NextDaysWeatherView_Previews: PreviewProvider {
    static var previews: some View {
        NextDaysWeatherView()
    }
}
