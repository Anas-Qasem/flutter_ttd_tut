import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:weather_clean_architecture_tdd/core/error/failure.dart';
import 'package:weather_clean_architecture_tdd/domain/entities/weather.dart';
import 'package:weather_clean_architecture_tdd/presentation/bloc/weather_bloc.dart';
import 'package:weather_clean_architecture_tdd/presentation/bloc/weather_event.dart';
import 'package:weather_clean_architecture_tdd/presentation/bloc/weather_state.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late MockGetCurrentWeatherUseCase mockGetCurrentWeatherUseCase;
  late WeatherBloc weatherBloc;

  setUp(() {
    mockGetCurrentWeatherUseCase = MockGetCurrentWeatherUseCase();
    weatherBloc = WeatherBloc(mockGetCurrentWeatherUseCase);
  });

  const testWeatherEntity = WeatherEntity(
    cityName: "Amman",
    main: "Clear",
    description: "clear sky",
    iconCode: "01n",
    temperature: 292.87,
    pressure: 1012,
    humidity: 70,
  );
  const testCityName = "Amman";

  test(
    "initial state should be empty",
    () {
      expect(weatherBloc.state, WeatherEmpty());
    },
  );

  blocTest<WeatherBloc, WeatherState>(
    'should emit [weatherLoading, WeatherLoaded] when data is gotten ',
    build: () {
      when(mockGetCurrentWeatherUseCase.execute(testCityName))
          .thenAnswer((_) async => const Right(testWeatherEntity));
      return weatherBloc;
    },
    act: (bloc) => bloc.add(const OnCityChanged(testCityName)),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      WeatherLoading(),
      const WeatherLoaded(testWeatherEntity),
    ],
  );

  blocTest<WeatherBloc, WeatherState>(
    'should emit [weatherLoading, weatherLoadFailure] when data is unsuccessful ',
    build: () {
      when(mockGetCurrentWeatherUseCase.execute(testCityName))
          .thenAnswer((_) async => const Left(ServerFailure('Server failure')));
      return weatherBloc;
    },
    act: (bloc) => bloc.add(const OnCityChanged(testCityName)),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      WeatherLoading(),
      const WeatherLoadFailure("Server failure"),
    ],
  );
}
