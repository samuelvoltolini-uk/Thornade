import SwiftUI

struct DetailsWeatherView: View {
    
    @StateObject var weatherController = WeatherController()
    
    var currentDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM"
        return "Today, \(dateFormatter.string(from: Date()))"
    }
    
    var body: some View {
        VStack {
            Text(weatherController.locationName)
                .font(Font.custom("Poppins-Bold", size: 24))
                .kerning(1)
                .multilineTextAlignment(.center)
            
            Text(currentDate)
                .font(Font.custom("Poppins-Regular", size: 14))
                .kerning(1)
                .foregroundColor(Color(red: 0.74, green: 0.74, blue: 0.76))
                .padding(.bottom, 5)
            
            ZStack {
                
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 400, height: 200)
                    .background(.quinary)
                    .cornerRadius(10)
                    .overlay(
                        HStack {
                            VStack(alignment: .leading) {
                                Image("\(weatherController.conditionIcon)H")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 120, height: 120)
                                
                                Text(weatherController.conditionDescription.capitalizedFirstLetter())
                                    .font(Font.custom("Poppins-Bold", size: 18))
                                    .kerning(1)
                                    .foregroundColor(Color.accentColor)
                                
                                
                                Text(timeOfDay())
                                    .font(Font.custom("Poppins-Regular", size: 12))
                                    .kerning(1)
                                    .foregroundColor(Color(red: 0.74, green: 0.74, blue: 0.76))
                            }
                            Spacer()
                            VStack {
                                Text("\( (weatherController.temperature - 32) * 5 / 9, specifier: "%.1f")°")
                                    .font(Font.custom("Poppins-Bold", size: 60))
                                    .kerning(1)
                                    .foregroundColor(Color.accentColor)
                                
                                Text("Feels like \( (weatherController.feelsLike - 32) * 5 / 9, specifier: "%.0f")°")
                                    .font(Font.custom("Poppins-Regular", size: 14))
                                    .kerning(1)
                                    .foregroundColor(Color(red: 0.74, green: 0.74, blue: 0.76))
                            }
                        }
                            .padding()
                    )
                
            }
            HStack {
                ZStack {
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 400, height: 120)
                        .background(.quinary) // Assuming .quinary is a defined color
                        .cornerRadius(10)
                    
                    SunMoonAnimationView(weatherController: weatherController)

                    HStack {
                        VStack {
                            Text("Sunrise")
                                .font(Font.custom("Poppins-Regular", size: 12))
                                .kerning(1)
                                .foregroundColor(Color(red: 0.74, green: 0.74, blue: 0.76))

                            Image("")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)

                            Text(formatTime(from: weatherController.sunriseTime))
                                .font(Font.custom("Poppins-Bold", size: 18))
                                .kerning(1)
                                .foregroundColor(Color.accentColor)
                        }

                        Spacer()

                        VStack {
                            Text("Sunset")
                                .font(Font.custom("Poppins-Regular", size: 12))
                                .kerning(1)
                                .foregroundColor(Color(red: 0.74, green: 0.74, blue: 0.76))

                            Image(systemName: "sun.low") // Placeholder image
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)

                            Text(formatTime(from: weatherController.sunsetTime))
                                .font(Font.custom("Poppins-Bold", size: 18))
                                .kerning(1)
                                .foregroundColor(Color.accentColor)
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .padding(.top, 10)
            .padding(.horizontal)

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
            }
            .padding(.top, 5)
            .padding(.horizontal)
            Spacer()
        }
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: .infinity)
        .background(Color(red: 0.12, green: 0.12, blue: 0.12))
    }
    

        func formatTime(from timestamp: Int) -> String {
            let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            return formatter.string(from: date)
        }
    

    
    func timeOfDay() -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 0..<6: return "Night"
        case 6..<12: return "Morning"
        case 12..<17: return "Afternoon"
        case 17..<24: return "Evening"
        default: return ""
        }
    }
}


struct SecondView_Previews: PreviewProvider {
    static var previews: some View {
        DetailsWeatherView()
    }
}
