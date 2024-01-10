import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            WeatherView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            
            
            DetailsWeatherView()
                .tabItem {
                    Label("Details", systemImage: "chart.bar.fill")
                }
            
            NextDaysWeatherView()
                .tabItem {
                    Label("7 Days", systemImage: "calendar.badge.clock")
                }
            
            OtherPlacesView()
                .tabItem {
                    Label("Places", systemImage: "location.circle.fill")
                }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
