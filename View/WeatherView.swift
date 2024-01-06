import SwiftUI

struct WeatherView: View {
    
    @StateObject var weatherController = WeatherController()

    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            
            Text("Hello, world!")
           
                Text("\(weatherController.temperature, specifier: "%.1f")°C - \(weatherController.conditionDescription)")
 
        }
        .padding()
    }
}

#Preview {
    WeatherView()
}
