import Foundation

final class WeatherService {
    private let apiKey = "ac8ccdd3427e893d70359d0103cc573c"
    private let baseUrl = "https://api.openweathermap.org/data/2.5/weather"

    func fetchWeather(for city: String) async throws -> WeatherResponse {
        let cityName = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? city
        let urlString = "\(baseUrl)?q=\(cityName)&units=metric&appid=\(apiKey)"

        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }

        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(WeatherResponse.self, from: data)
    }

    func fetchWeather(lat: Double, lon: Double) async throws -> WeatherResponse {
        let urlString = "\(baseUrl)?lat=\(lat)&lon=\(lon)&units=metric&appid=\(apiKey)"

        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }

        let (data, _) = try await URLSession.shared.data(from: url)
        return  try JSONDecoder().decode(WeatherResponse.self, from: data)
    }
}
