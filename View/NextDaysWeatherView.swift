
import SwiftUI

struct NextDaysWeatherView: View {
    
    @StateObject var weatherController = WeatherController()
    
    var body: some View {
        NavigationView {
            ZStack {
                ScrollView {
                    VStack {
                        ForEach(weatherController.dailyForecast.prefix(5)) { dayWeather in
                            VStack {
                                // Display day of the week
                                Text(weatherController.dayOfWeek(for: dayWeather.dt))
                                    .font(Font.custom("Poppins-Regular", size: 14))
                                    .foregroundColor(Color.white)
                                    .padding(.bottom, 2)

                                ZStack {
                                    Rectangle()
                                        .foregroundColor(.clear)
                                        .frame(width: 400, height: 76)
                                        .background(.quinary)
                                        .cornerRadius(10)
                                    
                                    VStack {
                                        // Weather description
                                        Text(dayWeather.weather.first?.description ?? "N/A")
                                            .font(Font.custom("Poppins-Regular", size: 12))
                                            .multilineTextAlignment(.center)
                                            .foregroundColor(Color(red: 0.74, green: 0.74, blue: 0.76))
                                        
                                        // Min and Max temperature
                                        Text("Min: \(dayWeather.temp.min, specifier: "%.1f")°C - Max: \(dayWeather.temp.max, specifier: "%.1f")°C")
                                            .font(Font.custom("Poppins-Bold", size: 18))
                                            .foregroundColor(Color.accentColor)
                                    }
                                }
                            }
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

#Preview {
    NextDaysWeatherView()
}
