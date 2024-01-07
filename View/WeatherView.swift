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
                    .frame(width: 250, height: 250)
                    .padding()
                
                Text("\(weatherController.temperature, specifier: "%.1f")°C - \(weatherController.conditionDescription)")
            }
            .padding()
        }
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: .infinity)
        .background(Color(red: 0.12, green: 0.12, blue: 0.12))

    }
}

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView()
    }
}

