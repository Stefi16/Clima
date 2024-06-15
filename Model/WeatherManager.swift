import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(_ error: Error)
}

struct WeatherManager {
    
    private let url =  "https://api.openweathermap.org/data/2.5/weather?appid=20e2bf8cdc299bd3f3206caf028b8fec&units=metric"
        
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(_ cityName: String) {
        let urlString = "\(url)&q=\(cityName)"
                
        performRequest(with: urlString)
    }

    func fetchCurrentLocationWeather(_ lat: CLLocationDegrees, _ lon: CLLocationDegrees) {
        let urlString = "\(url)&lat=\(lat)&lon=\(lon)"
        
        performRequest(with: urlString)
    }
    
    func performRequest(with url: String) {
        let session = URLSession(configuration: .default)
        
        let url = URL(string: url)
        
        if let safeUrl = url {
            let task = session.dataTask(with: safeUrl) { data, response, error in
                if let safeData = data {
                    print(data)
                    if let weatherResult = parseJson(safeData) {
                        self.delegate?.didUpdateWeather(self, weather: weatherResult)
                    }
                }
                
                if let safeError = error {
                    delegate?.didFailWithError(safeError)
                }
                
            }
            
            task.resume()
        }
    }

    func parseJson(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            
            let id = decodedData.weather[0].id
            let name = decodedData.name
            let temp = decodedData.main.temp
            
            return WeatherModel(conditionId: id, cityName: name, temperature: temp)
            
        } catch {
            delegate?.didFailWithError(error)
            return nil
        }
    }
    
}
