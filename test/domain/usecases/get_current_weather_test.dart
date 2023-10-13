import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:weather_clean_architecture_tdd/domain/entities/weather.dart';
import 'package:weather_clean_architecture_tdd/domain/usecases/get_current_weather.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  // we want to ensue that tha repository actually called
  // and the data unChanged throw use case
  // so we need the weather repository
  late final GetCurrentWeatherUseCase getCurrentWeatherUseCase;
  // to test abstract class repository [Which in this case is WeatherRepository]
  // we use mocktail package [test_helper] and create [MockWeatherRepository]
  // MockWeatherRepository is generated mock class which implement the functions inside the WeatherRepository
  late final MockWeatherRepository mockWeatherRepository;

  // method called before any individual test
  // it is like init method so we can init the instance inside it
  setUp(() {
    mockWeatherRepository = MockWeatherRepository();
    getCurrentWeatherUseCase = GetCurrentWeatherUseCase(mockWeatherRepository);
  });

  // weather details entity the values of objects does not matter
  const testWeatherEntity = WeatherEntity(
    cityName: "Amman",
    main: "Clouds",
    description: "few Clouds",
    iconCode: "02d",
    temperature: 302.28,
    pressure: 1009,
    humidity: 70,
  );
  const testCityName = 'Amman';
  // test method
  test(
    'Should Get current weather details from the repository',
    () async {
      // we should dived test method into three sections

      /// arrange
      when(mockWeatherRepository.getCurrentWeather(testCityName))
          .thenAnswer((_) async => const Right(testWeatherEntity));

      /// act
      // in act you  should cover the main thing to be tested
      // [calling function or method calling reset api]
      // focuses in target behavior
      final result = await getCurrentWeatherUseCase.execute(testCityName);

      /// assets
      /// verify wether the unit behave as expected
      /// expect that the result of the use case should be the same thing
      /// what is return from the mock repository
      expect(result, const Right(testWeatherEntity));
    },
  );
}
