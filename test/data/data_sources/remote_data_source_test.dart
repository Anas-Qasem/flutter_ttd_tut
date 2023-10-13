import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:weather_clean_architecture_tdd/core/constants/constants.dart';
import 'package:weather_clean_architecture_tdd/core/error/exception.dart';
import 'package:weather_clean_architecture_tdd/data/data_sources/remote_data_source.dart';
import 'package:http/http.dart' as http;
import 'package:weather_clean_architecture_tdd/data/models/weather_model.dart';
import '../../helpers/json_reader.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late MockHttpClient mockHttpClient;
  late WeatherRemoteDataSource weatherRemoteDataSource;
  const testCityName = 'Amman';
  setUp(() {
    mockHttpClient = MockHttpClient();
    weatherRemoteDataSource =
        WeatherRemoteDataSourceImpl(client: mockHttpClient);
  });

  group(
    'get current weather',
    () {
      test(
        'should return weather model when the response code is 200',
        () async {
          // arrange
          when(
            mockHttpClient
                .get(Uri.parse(Urls.currentWeatherByName(testCityName))),
          ).thenAnswer(
            (_) async => http.Response(
              readJson('helpers/dummy_data/dummy_weather_response.json'),
              200,
            ),
          );
          // act
          final result =
              await weatherRemoteDataSource.getCurrentWeather(testCityName);

          // assert
          expect(result, isA<WeatherModel>());
        },
      );

      test( 
        'should throw a server exception when the response code is 404 or other',
        () async {
          //arrange
          when(
            mockHttpClient
                .get(Uri.parse(Urls.currentWeatherByName(testCityName))),
          ).thenAnswer((_) async => http.Response('Not found', 404));

          //act
          final result =
              weatherRemoteDataSource.getCurrentWeather(testCityName);

          //assert
          expect(result, throwsA(isA<ServerException>()));
        },
      );
    },
  );
}
