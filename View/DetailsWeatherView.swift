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
                            Text(isDaytime() ? "Sunrise" : "Sunset")
                                .font(Font.custom("Poppins-Regular", size: 12))
                                .kerning(1)
                                .foregroundColor(Color(red: 0.74, green: 0.74, blue: 0.76))

                            Image("") // Add appropriate image
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)

                            Text(formatTime(from: isDaytime() ? weatherController.sunriseTime : weatherController.sunsetTime))
                                .font(Font.custom("Poppins-Bold", size: 18))
                                .kerning(1)
                                .foregroundColor(Color.accentColor)
                        }

                        Spacer()

                        VStack {
                            Text(isDaytime() ? "Sunset" : "Sunrise")
                                .font(Font.custom("Poppins-Regular", size: 12))
                                .kerning(1)
                                .foregroundColor(Color(red: 0.74, green: 0.74, blue: 0.76))

                            Image("") // Add appropriate image
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)

                            Text(formatTime(from: isDaytime() ? weatherController.sunsetTime : weatherController.sunriseTime))
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
                        Text("Night Duration")
                            .font(Font.custom("Poppins-Regular", size: 12))
                            .kerning(1)
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color(red: 0.74, green: 0.74, blue: 0.76))
                        
                        Text(calculateNightDuration())
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
                        Text("Day Duration")
                            .font(Font.custom("Poppins-Regular", size: 12))
                            .kerning(1)
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color(red: 0.74, green: 0.74, blue: 0.76))
                        
                        Text(calculateDayDuration())
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
                        Text("Visibility")
                            .font(Font.custom("Poppins-Regular", size: 12))
                            .kerning(1)
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color(red: 0.74, green: 0.74, blue: 0.76))
                        
                        Text(String(format: "%.1f", weatherController.visibility * 0.000621371))
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
            
            
            HStack {
                ZStack {
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 118, height: 76)
                        .background(.quinary)
                        .cornerRadius(10)
                    
                    VStack {
                        Text("Pressure")
                            .font(Font.custom("Poppins-Regular", size: 12))
                            .kerning(1)
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color(red: 0.74, green: 0.74, blue: 0.76))
                        
                        Text("\(weatherController.pressure)")
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
                        Text("Dew Point")
                            .font(Font.custom("Poppins-Regular", size: 12))
                            .kerning(1)
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color(red: 0.74, green: 0.74, blue: 0.76))
                        
                        Text("\(weatherController.dew_point, specifier: "%.1f")")
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
                        Text("UVI")
                            .font(Font.custom("Poppins-Regular", size: 12))
                            .kerning(1)
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color(red: 0.74, green: 0.74, blue: 0.76))
                        
                        Text("\(weatherController.uvi, specifier: "%.1f")")
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
    
    func calculateNightDuration() -> String {
        let sunset = Double(weatherController.sunsetTime)
        var nextSunrise = Double(weatherController.sunriseTime)

        // Ensure nextSunrise is always after sunset (accounting for the next day)
        if nextSunrise < sunset {
            nextSunrise += 24 * 3600 // Add 24 hours
        }

        let nightDurationInSeconds = nextSunrise - sunset
        let hours = Int(nightDurationInSeconds) / 3600
        let minutes = Int(nightDurationInSeconds) % 3600 / 60

        return String(format: "%02d:%02d", hours, minutes)
    }
    
    func calculateDayDuration() -> String {
        let sunrise = Double(weatherController.sunriseTime)
        let sunset = Double(weatherController.sunsetTime)

        let dayDurationInSeconds = sunset - sunrise
        let hours = Int(dayDurationInSeconds) / 3600
        let minutes = Int(dayDurationInSeconds) % 3600 / 60

        return String(format: "%02d:%02d", hours, minutes)
    }
    
    func isDaytime() -> Bool {
         let currentTime = Date().timeIntervalSince1970
         return currentTime >= Double(weatherController.sunriseTime) && currentTime < Double(weatherController.sunsetTime)
     }
}


struct SecondView_Previews: PreviewProvider {
    static var previews: some View {
        DetailsWeatherView()
    }
}
