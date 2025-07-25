import SwiftUI

struct ContentView: View {

    let service = WeatherService()

    @StateObject var locationManager = LocationManager()

    @State private var cityName = ""
    @State private var weather: WeatherResponse?
    @State private var errorMessage: String?

    var weatherIconUrl: URL? {
        guard let iconCode = weather?.weather.first?.icon else { return nil }
        let urlString = "https://openweathermap.org/img/wn/\(iconCode)@2x.png"
        return URL(string: urlString)
    }

    var body: some View {
        VStack(spacing: 16) {
            TextField("Enter city name.", text: $cityName)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            Button("Search") {
                onSearchTapped()
            }
            .padding()

            if let weather {
                VStack {
                    Text("City: \(weather.name)")
                    Text("Temperature: \(weather.main.temp, specifier: "%.1f")°C")
                    Text("Feels Like: \(weather.main.feelsLike, specifier: "%.1f")°C")
                    Text("Humidity: \(weather.main.humidity)%")
                    Text("Description: \(weather.weather.first?.description ?? "")")
                    AsyncImage(url: weatherIconUrl) { image in
                        image.resizable()
                             .frame(width: 100, height: 100)
                    } placeholder: {
                        ProgressView()
                    }
                }
            } else if let errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
            }

            Spacer()
        }
        .padding(.top, 40)
        .onChange(of: locationManager.location) { _, newLocation in
            guard let coord = newLocation?.coordinate else { return }

            Task {
                do {
                    weather = try await service.fetchWeather(lat: coord.latitude, lon: coord.longitude)
                    errorMessage = nil
                } catch {
                    errorMessage = "Failed to retrieve location-based weather information."
                }
            }
        }
    }

    private func onSearchTapped() {
        let trimmedCityName = cityName.trimmingCharacters(in: .whitespaces)
        guard trimmedCityName != "" else { return }

        Task {
            do {
                weather = try await service.fetchWeather(for: trimmedCityName)
                errorMessage = nil
                cityName = ""
            } catch {
                weather = nil
                errorMessage = "Failed to fetch weather data."
            }
        }
    }
}

#Preview {
    ContentView()
}
