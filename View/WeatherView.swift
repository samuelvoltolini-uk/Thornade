import SwiftUI

struct WeatherView: View {
    @StateObject var weatherController = WeatherController()

    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")

            // Displaying the temperature
            Text("\(weatherController.temperature, specifier: "%.1f")°C")
                .onAppear {
                    weatherController.fetchWeather()
                }
        }
        .padding()
    }
}


#Preview {
    WeatherView()
}
