import SwiftUI

struct WeatherView: View {
    @StateObject var weatherController = WeatherController()
    
    var currentDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM"
        return "Today, \(dateFormatter.string(from: Date()))"
    }
    
    var body: some View {
        ZStack {
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
                
                Image("\(weatherController.conditionIcon)")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 300)
                    .padding(.top, 60)
                
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
                                .font(Font.custom("Poppins", size: 12))
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
                                .font(Font.custom("Poppins", size: 12))
                                .kerning(1)
                                .multilineTextAlignment(.center)
                                .foregroundColor(Color(red: 0.74, green: 0.74, blue: 0.76))

                            Text("\((weatherController.temperature - 32) * 5 / 9, specifier: "%.1f")°C")
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
                                .font(Font.custom("Poppins", size: 12))
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
                .padding(.top)
            }
            .padding()
            
        }
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: .infinity)
        .background(Color(red: 0.12, green: 0.12, blue: 0.12))

    }
}

extension String {
    func capitalizedFirstLetter() -> String {
        return self.lowercased().split(separator: " ").map { $0.capitalized }.joined(separator: " ")
    }
}

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView()
    }
}

