import 'dart:math';

import 'package:flutter/widgets.dart';

class Location {
  final double latitude;
  final double longitude;

  Location(this.latitude, this.longitude);
}

class Letter {
  final DateTime sendingDate;
  final Location senderLocation;
  final Location receiverLocation;

  Letter(this.sendingDate, this.senderLocation, this.receiverLocation);
}

// Función para convertir grados a radianes
double degreesToRadians(double degrees) {
  return degrees * pi / 180;
}

// Función para calcular la distancia entre dos coordenadas geográficas
double calculateDistance(Location location1, Location location2) {
  const earthRadius = 6371; // Radio medio de la Tierra en kilómetros

  final lat1 = degreesToRadians(location1.latitude);
  final lon1 = degreesToRadians(location1.longitude);
  final lat2 = degreesToRadians(location2.latitude);
  final lon2 = degreesToRadians(location2.longitude);

  final dlon = lon2 - lon1;
  final dlat = lat2 - lat1;

  final a =
      pow(sin(dlat / 2), 2) + cos(lat1) * cos(lat2) * pow(sin(dlon / 2), 2);
  final c = 2 * atan2(sqrt(a), sqrt(1 - a));

  return earthRadius * c * 1000; // Distancia en metros
}

// Función para calcular la fecha de llegada de la carta
DateTime calculateArrivalDate(Letter letter) {
  final distance = calculateDistance(
      letter.senderLocation, letter.receiverLocation); // Distancia en metros
  final daysToDeliver =
      distance / (45 * 1000); // Tiempo estimado de entrega en días

  final totalDays =
      daysToDeliver.ceil(); // Redondear hacia arriba al día más cercano

  // Ajustar la fecha de envío según los días laborables
  DateTime deliveryDate = letter.sendingDate;
  int daysToAdd = totalDays.toInt();
  while (daysToAdd > 0) {
    deliveryDate = deliveryDate.add(const Duration(days: 1));
    if (deliveryDate.weekday >= 1 && deliveryDate.weekday <= 5) {
      daysToAdd--;
    }
  }

  // Calcular el tiempo estimado de entrega con retrasos
  final random = Random();
  if (random.nextDouble() < 0.0001) {
    deliveryDate = deliveryDate.add(const Duration(days: 1));
  }

  return deliveryDate;
}

// Función para calcular el tiempo restante para la llegada de la carta
Duration calculateTimeRemaining(Letter letter) {
  final currentDate = DateTime.now();
  final arrivalDate = calculateArrivalDate(letter);
  return arrivalDate.difference(currentDate);
}

// Función para calcular la distancia restante para la llegada de la carta
double calculateDistanceRemaining(Letter letter) {
  final distance = calculateDistance(
      letter.senderLocation, letter.receiverLocation); // Distancia en metros
  final currentDate = DateTime.now();
  final arrivalDate = calculateArrivalDate(letter);
  final remainingDays = arrivalDate.difference(currentDate).inDays;
  final distanceToTravel = distance / (45 * 1000); // Distancia estimada en días

  // Calcular la distancia restante en metros
  final remainingDistance = (distanceToTravel - remainingDays) * 45 * 1000;
  return remainingDistance;
}

  Map<String, dynamic> textStyleToMap(TextStyle textStyle) {
    return {
      'fontSize': textStyle.fontSize,
      'fontWeight': textStyle.fontWeight?.index,
      'fontStyle': textStyle.fontStyle?.index,
      'color': textStyle.color?.value,
    };
  }

/* void main() {
  // Ejemplo de uso
  final sendingDate = DateTime.now();
  final senderLocation = Location(40.7128, -74.0060); // New York City
  final receiverLocation = Location(34.0522, -118.2437); // Los Angeles

  final letter = Letter(sendingDate, senderLocation, receiverLocation);

  print('Fecha de llegada estimada: ${calculateArrivalDate(letter)}');
  print(
      'Distancia entre las ubicaciones: ${calculateDistance(senderLocation, receiverLocation)} metros');
  print('Tiempo total estimado de entrega: ${calculateTimeRemaining(letter)}');
  print('Tiempo restante para la llegada: ${calculateTimeRemaining(letter)}');
  print(
      'Distancia restante para la llegada: ${calculateDistanceRemaining(letter)} metros');
}
 */