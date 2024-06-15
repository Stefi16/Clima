import Foundation

struct WeatherModel {
    let conditionId: Int
    let cityName: String
    let temperature: Double
    
    var conditionName: String {
        switch conditionId {
        case ..<300: return "cloud.bolt"
        case 300..<400: return "cloud.drizzle"
        case 500..<600: return "cloud.rain"
        case 600..<700: return "cloud.snow"
        case 700..<800: return "cloud.fog"
        case 800: return "sun.max"
        case 801..<810: return "cloud.bolt"
        default: return "cloud"
        }
    }
    
    var temperatureString: String {
        return String(format: "%.1f", temperature)
    }
}
