import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MeteoPage extends StatefulWidget {
  const MeteoPage({super.key});

  @override
  State<MeteoPage> createState() => _MeteoPageState();
}

class _MeteoPageState extends State<MeteoPage> {
  final String apiKey =
      '1680d0644118c3ba41fc0ed21cb89d9c'; // 🔑 Mets ta clé OpenWeatherMap ici
  final String city = 'Ziguinchor'; // Tu peux changer la ville
  Map<String, dynamic>? weatherData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchWeather();
  }

  Future<void> fetchWeather() async {
    final url = Uri.parse(
      'https://api.openweathermap.org/data/2.5/weather?q=$city&units=metric&lang=fr&appid=$apiKey',
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        setState(() {
          weatherData = json.decode(response.body);
          isLoading = false;
        });
      } else {
        throw Exception('Erreur de chargement');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Impossible de récupérer les données météo.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Météo agricole'),
        backgroundColor: const Color(0xFF1EB980),
      ),
      backgroundColor: const Color(0xFFF7F8FA),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : weatherData == null
          ? const Center(child: Text('Aucune donnée disponible'))
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Prévisions pour $city',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _WeatherCard(
                    temperature: '${weatherData!['main']['temp'].round()}°C',
                    condition: weatherData!['weather'][0]['description'],
                    humidity: '${weatherData!['main']['humidity']}%',
                    wind: '${weatherData!['wind']['speed']} km/h',
                    icon: weatherData!['weather'][0]['main'] == 'Rain'
                        ? Icons.thunderstorm_rounded
                        : weatherData!['weather'][0]['main'] == 'Clouds'
                        ? Icons.cloud_rounded
                        : Icons.wb_sunny_rounded,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: fetchWeather,
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('Actualiser'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1EB980),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class _WeatherCard extends StatelessWidget {
  final String temperature;
  final String condition;
  final String humidity;
  final String wind;
  final IconData icon;

  const _WeatherCard({
    required this.temperature,
    required this.condition,
    required this.humidity,
    required this.wind,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(icon, color: const Color(0xFF1EB980), size: 32),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: 160,
                      child: Text(
                        condition.toUpperCase(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  'Humidité : $humidity',
                  style: const TextStyle(color: Colors.grey),
                ),
                Text(
                  'Vent : $wind',
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
            Text(
              temperature,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1EB980),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
