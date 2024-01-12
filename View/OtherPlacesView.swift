
import SwiftUI

struct OtherPlacesView: View {
    var body: some View {
        NavigationView {
            ZStack {
                
                
            }
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: .infinity)
            .background(Color(red: 0.12, green: 0.12, blue: 0.12))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    CustomTitleViewPlaces(title: "Places")
                }
            }
        }
    }
}

struct CustomTitleViewPlaces: View {
    
    @StateObject var weatherController = WeatherController()
    var title: String
    
    var body: some View {
        Text("Places")
            .font(Font.custom("Poppins-Bold", size: 24))
            .kerning(1)
    }
}

#Preview {
    OtherPlacesView()
}
