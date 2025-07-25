import Foundation

final class WeatherService {
    private let apiKey = "ac8ccdd3427e893d70359d0103cc573c"

    func fetchWeather(for city: String) async throws -> WeatherResponse {
        let cityName = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? city
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(cityName)&units=metric&appid=\(apiKey)"

        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let result = try JSONDecoder().decode(WeatherResponse.self, from: data)
            return result
        } catch {
			throw error
        }
    }
}
