import SwiftUI
import Charts

struct DetailsWeatherView: View {
    
    private let barColors: [Color] = [.cyan, .white, .mint, .pink, .purple, .blue, .green, .orange]
    
    let temperatureGradient = Gradient(colors: [
        Color(red: 0, green: 0, blue: 1),             // Blue, -30°C, very cold
        Color(red: 0, green: 1, blue: 1),             // Cyan, -20°C, cold
        Color(red: 0, green: 0.5, blue: 0.5),         // Teal, -10°C, chilly
        Color(red: 0, green: 1, blue: 0),             // Green, 0°C, cool
        Color(red: 0.5, green: 1, blue: 0.5),         // Light Green, 10°C, mild cool
        Color(red: 1, green: 1, blue: 0),             // Yellow, 20°C, mild
        Color(red: 1, green: 0.647, blue: 0),         // Orange, 30°C, warm
        Color(red: 1, green: 0.549, blue: 0),         // Deep Orange, 40°C, hot
        Color(red: 1, green: 0, blue: 0)              // Red, 50°C, very hot
    ])

    
    
    @State private var isUserInteracting = false
    @State private var markerPosition: CGFloat? = nil
    
    @State private var selectedHour: String? = nil
    @State private var selectedUVI: Double? = nil
    
    let chartWidth: CGFloat = 370
    let chartHeight: CGFloat = 215
    let chartFrameOriginX: CGFloat = 0
    
    
    @State private var gestureLocation: CGPoint? = nil
    
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
                        
                        ZStack {
                            
                            Rectangle()
                                .foregroundColor(.clear)
                                .frame(width: 400, height: 200)
                                .background(.quinary)
                                .cornerRadius(10)
                                .overlay(
                                    HStack {
                                        VStack(alignment: .leading) {
                                            Image(weatherController.id > 710 || weatherController.id < 300 ? "\(weatherController.conditionIcon)H" : "\(weatherController.id)H")
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
                                    .frame(width: 400, height: 300)
                                    .background(.quinary)
                                    .cornerRadius(10)
                                
                                VStack(alignment: .leading) {
                                    Text("Precipitation 24 Horas (Mm)")
                                        .font(Font.custom("Poppins-Regular", size: 12))
                                        .kerning(1)
                                        .foregroundColor(Color(red: 0.74, green: 0.74, blue: 0.76))
                                    
                                    Text("\(totalPrecipitationForNext24Hours(), specifier: "%.1f")")
                                        .font(Font.custom("Poppins-Bold", size: 18))
                                        .kerning(1)
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(.accentColor)
                                    
                                    
                                    Chart() {
                                        ForEach(aggregateDataByThreeHours(), id: \.hour) { data in
                                            BarMark(
                                                x: .value("3-Hour Interval", data.hour),
                                                y: .value("Precipitation", data.precipitation)
                                            )
                                            .cornerRadius(5.0)
                                            .foregroundStyle(data.isSnow ? barColors[1] : barColors[0])
                                            
                                        }
                                    }
                                    .padding(.top, 20)
                                    .frame(width: 370, height: 215)
                                    .font(Font.custom("Poppins-Bold", size: 12))
                                    .kerning(1)
                                    
                                    
                                    .chartXAxis {
                                        AxisMarks(stroke: StrokeStyle(lineWidth: 0))
                                        
                                    }
                                    //.chartYAxis(.hidden)
                                }
                            }
                            
                        }
                        .padding(.top, 10)
                        .padding(.horizontal)
                        
                        HStack {
                            ZStack {
                                Rectangle()
                                    .foregroundColor(.clear)
                                    .frame(width: 400, height: 300)
                                    .background(.quinary)
                                    .cornerRadius(10)

                                VStack(alignment: .leading) {
                                    Text("Average Temperature 24 Hours (°C)")
                                        .font(Font.custom("Poppins-Regular", size: 12))
                                        .kerning(1)
                                        .foregroundColor(Color(red: 0.74, green: 0.74, blue: 0.76))
                                    
                                    Text("\(averageTemperatureForNext24HoursInCelsius(), specifier: "%.1f")°C")
                                        .font(Font.custom("Poppins-Bold", size: 18))
                                        .kerning(1)
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(.accentColor)
                                    
                                    Chart {
                                        ForEach(aggregateTemperatureByThreeHours(), id: \.hour) { data in
                                            BarMark(
                                                x: .value("3-Hour Interval", data.hour),
                                                y: .value("Temperature", data.temperature)
                                            )
                                            .cornerRadius(5.0)
                                            .foregroundStyle(colorForTemperature(data.temperature)) // Apply the color based on temperature
                                        }
                                    }
                                    .padding(.top, 20)
                                    .frame(width: 370, height: 215)
                                    .font(Font.custom("Poppins-Bold", size: 12))
                                    .kerning(1)
                                    .chartXAxis {
                                        AxisMarks(stroke: StrokeStyle(lineWidth: 0))
                                    }
                                }
                            }
                            .padding(.top, 10)
                            .padding(.horizontal)
                        }
                        
                        HStack {
                            ZStack {
                                Rectangle()
                                    .foregroundColor(.clear)
                                    .frame(width: 400, height: 300)
                                    .background(.quinary)
                                    .cornerRadius(10)
                                
                                
                                VStack(alignment: .leading) {
                                    Text("Wind Average Speed 24 Hours (Mph)")
                                        .font(Font.custom("Poppins-Regular", size: 12))
                                        .kerning(1)
                                        .foregroundColor(Color(red: 0.74, green: 0.74, blue: 0.76))
                                    
                                    Text("\(averageWindSpeedForNext24Hours(), specifier: "%.1f")")
                                        .font(Font.custom("Poppins-Bold", size: 18))
                                        .kerning(1)
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(.accentColor)
                                    
                                    
                                    Chart {
                                        ForEach(aggregateWindSpeedByThreeHours(), id: \.hour) { data in
                                            BarMark(
                                                x: .value("3-Hour Interval", data.hour),
                                                y: .value("Wind Speed", data.windSpeed)
                                            )
                                            .cornerRadius(5.0)
                                            .foregroundStyle(barColors[4])
                                        }
                                    }
                                    
                                    .padding(.top, 20)
                                    .frame(width: 370, height: 215)
                                    .font(Font.custom("Poppins-Bold", size: 12))
                                    .kerning(1)
                                    .chartXAxis {
                                        AxisMarks(stroke: StrokeStyle(lineWidth: 0))
                                    }
                                    //.chartYAxis(.hidden)
                                }
                            }
                            
                        }
                        .padding(.top, 10)
                        .padding(.horizontal)
                        
                        HStack {
                            ZStack {
                                Rectangle()
                                    .foregroundColor(.clear)
                                    .frame(width: 400, height: 300)
                                    .background(.quinary)
                                    .cornerRadius(10)
                                
                                VStack(alignment: .leading) {
                                    Text("Average Temperature 24 Hours (°C)")
                                        .font(Font.custom("Poppins-Regular", size: 12))
                                        .kerning(1)
                                        .foregroundColor(Color(red: 0.74, green: 0.74, blue: 0.76))
                                    
                                    Text("\(averageTemperatureForNext24HoursInCelsius(), specifier: "%.1f")°C")
                                        .font(Font.custom("Poppins-Bold", size: 18))
                                        .kerning(1)
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(.accentColor)
                                    
                                    Chart {
                                        ForEach(aggregateTemperatureByThreeHours(), id: \.hour) { data in
                                            BarMark(
                                                x: .value("3-Hour Interval", data.hour),
                                                y: .value("Temperature", data.temperature)
                                            )
                                            .cornerRadius(5.0)
                                            .foregroundStyle(barColors[4]) // Choose an appropriate color
                                        }
                                    }
                                    .padding(.top, 20)
                                    .frame(width: 370, height: 215)
                                    .font(Font.custom("Poppins-Bold", size: 12))
                                    .kerning(1)
                                    .chartXAxis {
                                        AxisMarks(stroke: StrokeStyle(lineWidth: 0))
                                    }
                                }
                            }
                        }
                        .padding(.top, 10)
                        .padding(.horizontal)
                        
                        HStack {
                            ZStack {
                                Rectangle()
                                    .foregroundColor(.clear)
                                    .frame(width: 400, height: 300)
                                    .background(.quinary) // Assuming .quinary is a defined color
                                    .cornerRadius(10)
                                
                                VStack(alignment: .leading) {
                                    Text("UVI Max Value 24 Hours")
                                        .font(Font.custom("Poppins-Regular", size: 12))
                                        .kerning(1)
                                        .foregroundColor(Color(red: 0.74, green: 0.74, blue: 0.76))
                                    
                                    Text(isUserInteracting ? "\(selectedUVI ?? 0, specifier: "%.1f") AT \(selectedHour ?? ""):00" : "\(maxUVIForNext24Hours(), specifier: "%.1f")")
                                        .font(Font.custom("Poppins-Bold", size: 18))
                                        .kerning(1)
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(.accentColor)
                                    
                                    
                                    Chart(weatherController.hourlyForecast.prefix(24)) { data in
                                        LineMark(
                                            x: .value("Hour", formatHourString(from: data.dt)),
                                            y: .value("UVI Index", data.uvi)
                                        )
                                        .interpolationMethod(.catmullRom)
                                        .foregroundStyle(barColors[7])
                                    }
                                    .gesture(
                                        DragGesture()
                                            .onChanged { value in
                                                isUserInteracting = true
                                                markerPosition = value.location.x
                                                updateSelectedUVIAndHour(for: value.location)
                                                UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                                            }
                                            .onEnded { _ in
                                                isUserInteracting = false
                                                markerPosition = nil
                                                selectedHour = nil
                                            }
                                    )
                                    .overlay(
                                        Group {
                                            if let position = markerPosition {
                                                let clampedX = max(chartFrameOriginX, min(position, chartFrameOriginX + chartWidth))
                                                Rectangle()
                                                    .frame(width: 1)
                                                    .background(Color.primary)
                                                    .position(x: clampedX, y: chartHeight / 2)
                                            }
                                        },
                                        alignment: .leading
                                    )
                                    .padding(.top, 20)
                                    .frame(width: 370, height: 215)
                                    .font(Font.custom("Poppins-Bold", size: 12))
                                    .kerning(1)
                                    .chartXAxis(.hidden)
                                    
                                }
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
                                    Text("Sunrise")
                                        .font(Font.custom("Poppins-Regular", size: 12))
                                        .kerning(1)
                                        .foregroundColor(Color(red: 0.74, green: 0.74, blue: 0.76))
                                    
                                    Text(formatTime(from: weatherController.sunriseTime))
                                        .font(Font.custom("Poppins-Bold", size: 18))
                                        .kerning(1)
                                        .foregroundColor(Color(red: 0.74, green: 0.74, blue: 0.76))
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
                                    Text("Sunset")
                                        .font(Font.custom("Poppins-Regular", size: 12))
                                        .kerning(1)
                                        .foregroundColor(Color(red: 0.74, green: 0.74, blue: 0.76))
                                    
                                    Text(formatTime(from: weatherController.sunsetTime))
                                        .font(Font.custom("Poppins-Bold", size: 18))
                                        .kerning(1)
                                        .foregroundColor(Color(red: 0.74, green: 0.74, blue: 0.76))
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
                                    Text("Chance")
                                        .font(Font.custom("Poppins-Regular", size: 12))
                                        .kerning(1)
                                        .foregroundColor(Color(red: 0.74, green: 0.74, blue: 0.76))
                                    
                                    Text(formatTime(from: weatherController.sunsetTime))
                                        .font(Font.custom("Poppins-Bold", size: 18))
                                        .kerning(1)
                                        .foregroundColor(Color(red: 0.74, green: 0.74, blue: 0.76))
                                        .padding(.top, 1)
                                }
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
                                        .foregroundColor(Color(red: 0.74, green: 0.74, blue: 0.76))
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
                                        .foregroundColor(Color(red: 0.74, green: 0.74, blue: 0.76))
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
                                        .foregroundColor(Color(red: 0.74, green: 0.74, blue: 0.76))
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
                                        .foregroundColor(Color(red: 0.74, green: 0.74, blue: 0.76))
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
                                        .foregroundColor(Color(red: 0.74, green: 0.74, blue: 0.76))
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
                                        .foregroundColor(Color(red: 0.74, green: 0.74, blue: 0.76))
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
                                    Text("Clouds Cover")
                                        .font(Font.custom("Poppins-Regular", size: 12))
                                        .kerning(1)
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(Color(red: 0.74, green: 0.74, blue: 0.76))
                                    
                                    Text("\(weatherController.clouds)%")
                                        .font(Font.custom("Poppins-Bold", size: 18))
                                        .kerning(1)
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(Color(red: 0.74, green: 0.74, blue: 0.76))
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
                                    Text("Wind Move")
                                        .font(Font.custom("Poppins-Regular", size: 12))
                                        .kerning(1)
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(Color(red: 0.74, green: 0.74, blue: 0.76))
                                    
                                    Text(windDirection(from: Double(weatherController.wind_deg)))
                                        .font(Font.custom("Poppins-Bold", size: 18))
                                        .kerning(1)
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(Color(red: 0.74, green: 0.74, blue: 0.76))
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
                                    Text("Wind Gust")
                                        .font(Font.custom("Poppins-Regular", size: 12))
                                        .kerning(1)
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(Color(red: 0.74, green: 0.74, blue: 0.76))
                                    
                                    Text("\(weatherController.wind_gust, specifier: "%.1f")")
                                        .font(Font.custom("Poppins-Bold", size: 18))
                                        .kerning(1)
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(Color(red: 0.74, green: 0.74, blue: 0.76))
                                        .padding(.top, 1)
                                }
                            }
                        }
                        .padding(.top, 5)
                        .padding(.horizontal)
                        
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
                    CustomTitleViewDetails(title: "Weather Forecast")
                }
                
            }
            
            
        }
        .scrollIndicators(.hidden)
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
    
    func windDirection(from degrees: Double) -> String {
        let directions = ["N", "NE", "E", "SE", "S", "SW", "W", "NW", "N"]
        let index = Int((degrees + 22.5) / 45.0) % 8
        return directions[index]
    }
}

private func formatHourString(from timestamp: Int) -> String {
    let date = Date(timeIntervalSince1970: Double(timestamp))
    let formatter = DateFormatter()
    formatter.dateFormat = "HH" // e.g., "1PM", "2PM"
    return formatter.string(from: date)
}

struct CustomTitleViewDetails: View {
    
    @StateObject var weatherController = WeatherController()
    var title: String
    
    var body: some View {
        Text(weatherController.locationName)
            .font(Font.custom("Poppins-Bold", size: 24))
            .kerning(1)
    }
}

extension DetailsWeatherView {
    func aggregateDataByThreeHours() -> [(hour: String, precipitation: Double, isSnow: Bool)] {
        stride(from: 0, to: weatherController.hourlyForecast.count, by: 3).map { startIndex -> (String, Double, Bool) in
            let endIndex = min(startIndex + 3, weatherController.hourlyForecast.count)
            let range = startIndex..<endIndex
            
            let totalRain = weatherController.hourlyForecast[range].compactMap { $0.rain?.first?.value }.reduce(0, +)
            let totalSnow = weatherController.hourlyForecast[range].compactMap { $0.snow?.first?.value }.reduce(0, +)
            
            let hourString = formatHourString(from: weatherController.hourlyForecast[startIndex].dt)
            let isSnow = totalSnow > totalRain
            
            return (hourString, totalRain + totalSnow, isSnow)
        }
    }
    
    func totalPrecipitationForNext24Hours() -> Double {
        weatherController.hourlyForecast.prefix(24).reduce(0) { sum, forecast in
            sum + (forecast.rain?.first?.value ?? 0) + (forecast.snow?.first?.value ?? 0)
        }
    }
    
    func aggregateWindSpeedByThreeHours() -> [(hour: String, windSpeed: Double)] {
        // Limit the data to the first 24 hours
        let limitedForecast = weatherController.hourlyForecast.prefix(24)
        
        return stride(from: 0, to: limitedForecast.count, by: 3).map { startIndex -> (String, Double) in
            let endIndex = min(startIndex + 3, limitedForecast.count)
            let range = startIndex..<endIndex
            
            let sumWindSpeed = limitedForecast[range].map { $0.wind_speed }.reduce(0, +)
            let averageWindSpeed = range.count > 0 ? sumWindSpeed / Double(range.count) : 0
            let hourString = formatHourString(from: limitedForecast[startIndex].dt)
            
            return (hourString, averageWindSpeed)
        }
    }
    
    func averageWindSpeedForNext24Hours() -> Double {
        let totalHours = min(weatherController.hourlyForecast.count, 24)
        guard totalHours > 0 else { return 0.0 }
        
        let totalWindSpeed = weatherController.hourlyForecast.prefix(24).reduce(0) { sum, forecast in
            sum + forecast.wind_speed
        }
        return totalWindSpeed / Double(totalHours)
    }
    
    func aggregateCloudCoverageByThreeHours() -> [(hour: String, cloudCoverage: Int)] {
        // Limit the data to the first 24 hours
        let limitedForecast = weatherController.hourlyForecast.prefix(24)
        
        return stride(from: 0, to: limitedForecast.count, by: 3).map { startIndex -> (String, Int) in
            let endIndex = min(startIndex + 3, limitedForecast.count)
            let range = startIndex..<endIndex
            
            let sumCloudCoverage = limitedForecast[range].map { $0.clouds }.reduce(0, +)
            let averageCloudCoverage = range.count > 0 ? sumCloudCoverage / range.count : 0
            let hourString = formatHourString(from: limitedForecast[startIndex].dt)
            
            return (hourString, averageCloudCoverage)
        }
    }
    
    func averageCloudCoverageForNext24Hours() -> Int {
        let totalHours = min(weatherController.hourlyForecast.count, 24)
        guard totalHours > 0 else { return 0 }
        
        let sumCloudCoverage = weatherController.hourlyForecast.prefix(24).map { $0.clouds }.reduce(0, +)
        let average = sumCloudCoverage / totalHours
        
        return average
    }
    
    func aggregateUVIByThreeHours() -> [(hour: String, uvi: Double)] {
        let limitedForecast = weatherController.hourlyForecast.prefix(24)
        
        return stride(from: 0, to: limitedForecast.count, by: 3).map { startIndex -> (String, Double) in
            let endIndex = min(startIndex + 3, limitedForecast.count)
            let range = startIndex..<endIndex
            
            let averageUVI = limitedForecast[range].map { $0.uvi }.reduce(0, +) / Double(range.count)
            let hourString = formatHourString(from: limitedForecast[startIndex].dt)
            
            return (hourString, averageUVI)
        }
    }
    func maxUVIForNext24Hours() -> Double {
        let uviValues = weatherController.hourlyForecast.prefix(24).map { $0.uvi }
        return uviValues.max() ?? 0.0
    }
    
    func updateSelectedUVI(for location: CGPoint) {
        let chartWidth: CGFloat = 370 // Width of the chart as CGFloat
        let hourIndex = Int((location.x / chartWidth) * CGFloat(24))
        selectedUVI = weatherController.hourlyForecast[hourIndex].uvi
    }
    
    func updateSelectedUVIAndHour(for location: CGPoint) {
        let chartWidth = 370
        let index = Int((location.x / CGFloat(chartWidth)) * 24)
        let clampedIndex = max(0, min(weatherController.hourlyForecast.count - 1, index))
        
        if clampedIndex < weatherController.hourlyForecast.count {
            let selectedData = weatherController.hourlyForecast[clampedIndex]
            selectedUVI = selectedData.uvi
            selectedHour = formatHourString(from: selectedData.dt)
        }
    }
    
    func aggregateTemperatureByThreeHours() -> [(hour: String, temperature: Double)] {
        stride(from: 0, to: weatherController.hourlyForecast.count, by: 3).map { startIndex -> (String, Double) in
            let endIndex = min(startIndex + 3, weatherController.hourlyForecast.count)
            let range = startIndex..<endIndex
            
            let averageTemperatureFahrenheit = weatherController.hourlyForecast[range].map { $0.temp }.reduce(0, +) / Double(range.count)
            let averageTemperatureCelsius = (averageTemperatureFahrenheit - 32) * 5 / 9
            
            let hourString = formatHourString(from: weatherController.hourlyForecast[startIndex].dt)
            return (hourString, averageTemperatureCelsius)
        }
    }
    
    func averageTemperatureForNext24HoursInCelsius() -> Double {
        let totalHours = min(weatherController.hourlyForecast.count, 24)
        guard totalHours > 0 else { return 0.0 }
        
        let totalTemperatureFahrenheit = weatherController.hourlyForecast.prefix(24).map { $0.temp }.reduce(0, +)
        let averageTemperatureFahrenheit = totalTemperatureFahrenheit / Double(totalHours)
        return (averageTemperatureFahrenheit - 32) * 5 / 9
    }
    
    func colorForTemperature(_ temperature: Double) -> Color {
        let normalizedTemperature = (temperature + 30) / 80 // Normalize temperature to a 0-1 scale
        return Color(temperatureGradient.stops[Int(normalizedTemperature * Double(temperatureGradient.stops.count - 1))].color)
    }
}




struct SecondView_Previews: PreviewProvider {
    static var previews: some View {
        DetailsWeatherView()
    }
}
