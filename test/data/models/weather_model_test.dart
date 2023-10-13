import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:weather_clean_architecture_tdd/data/models/weather_model.dart';
import 'package:weather_clean_architecture_tdd/domain/entities/weather.dart';

import '../../helpers/json_reader.dart';

void main() {
  // we need to test three main things

  //=1
  // is The model we created equal to entity in the domain layer
  // what should be class of weather entity ?
  // is weather model
  // so we need the weather model
  const testWeatherModel = WeatherModel(
    cityName: "Amman",
    main: "Clear",
    description: "clear sky",
    iconCode: "01n",
    temperature: 292.87,
    pressure: 1012,
    humidity: 70,
  );

  test(
    'Should be class of weather entity',
    () {
      // in this test there is no arrange or act
      // only assert
      expect(testWeatherModel, isA<WeatherEntity>());
    },
  );

  //=2
  // does from Json function return valid model
  test(
    'should return a valid from json',
    () {
      // arrange
      final Map<String, dynamic> jsonMap = json.decode(
        readJson('helpers/dummy_data/dummy_weather_response.json'),
      );

      // act
      final result = WeatherModel.fromJson(jsonMap);
      // expect
      expect(result, equals(testWeatherModel));
    },
  );

  //=3
  // does the to Json function return the correct Json map
  test(
    'should return a json map containing proper data',
    () {
      // act
      final result = testWeatherModel.toJson();
      // assert
      final expectedJsonMap = {
        'weather': [
          {
            'main': 'Clear',
            'description': 'clear sky',
            'icon': '01n',
          }
        ],
        'main': {
          'temp': 292.87,
          'pressure': 1012,
          'humidity': 70,
        },
        'name': 'Amman',
      };

      expect(result, equals(expectedJsonMap));
    },
  );
}
