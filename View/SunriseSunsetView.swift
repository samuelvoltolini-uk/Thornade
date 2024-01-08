import SwiftUI

struct SunMoonAnimationView: View {
    @ObservedObject var weatherController: WeatherController
    @State private var sunScale: CGFloat = 1.0
    @State private var moonScale: CGFloat = 1.0
    
    var body: some View {
        VStack {
            GeometryReader { geometry in
                let totalWidth = geometry.size.width
                let sunPosition = calculateSunPosition(totalWidth: totalWidth)
                let moonPosition = calculateMoonPosition(totalWidth: totalWidth)
                
                Group {
                    if isDaytime() {
                        Image("01dH") // Sun image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 35, height: 35)
                            .scaleEffect(sunScale)
                            .position(x: sunPosition, y: geometry.size.height / 2)
                            .transition(.opacity)
                            .onAppear {
                                withAnimation(Animation.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                                    sunScale = 1.2
                                }
                            }
                    } else {
                        Image("01nH") // Moon image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 35, height: 35)
                            .scaleEffect(moonScale)
                            .position(x: moonPosition, y: geometry.size.height / 2)
                            .transition(.opacity)
                            .onAppear {
                                withAnimation(Animation.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                                    moonScale = 1.2
                                }
                            }
                    }
                }
            }
        }
        .frame(width: 400, height: 120)
    }
    
    private func isDaytime() -> Bool {
        let currentTime = Date().timeIntervalSince1970
        return currentTime >= Double(weatherController.sunriseTime) && currentTime < Double(weatherController.sunsetTime)
    }
    
    
    private func calculateSunPosition(totalWidth: CGFloat) -> CGFloat {
        let currentTime = Date().timeIntervalSince1970
        let sunrise = Double(weatherController.sunriseTime)
        let sunset = Double(weatherController.sunsetTime)
        
        if currentTime < sunrise || currentTime > sunset {
            return -50 // Before sunrise or after sunset, move the sun out of view
        }
        
        let duration = sunset - sunrise
        let progress = (currentTime - sunrise) / duration
        return CGFloat(progress) * totalWidth
    }
    
    private func calculateMoonPosition(totalWidth: CGFloat) -> CGFloat {
        let currentTime = Date().timeIntervalSince1970
        let sunrise = Double(weatherController.sunriseTime)
        let sunset = Double(weatherController.sunsetTime)
        
        if currentTime >= sunset || currentTime < sunrise {
            let duration = (24 * 3600) - (sunset - sunrise) // Duration of the night
            let progress = currentTime < sunrise ? (currentTime + (24 * 3600) - sunset) / duration : (currentTime - sunset) / duration
            return CGFloat(progress) * totalWidth
        }
        
        return -50 // During daytime, move the moon out of view
    }
}


