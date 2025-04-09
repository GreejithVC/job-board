import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:job_board/networks/api_handler.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}
class MockResponse extends Mock implements Response {}

void main() {
  late MockDio mockDio;
  late ApiHandler apiHandler;

  setUp(() {
    mockDio = MockDio();
    apiHandler = ApiHandler(dio: mockDio);
  });

  group('ApiHandler', () {
    const testUrl = '/test';
    const testData = {'key': 'value'};
    final successResponse = Response(
      requestOptions: RequestOptions(path: testUrl),
      data: {'result': 'ok'},
      statusCode: 200,
    );

    test('GET success', () async {
      when(() => mockDio.get(any(), queryParameters: any(named: 'queryParameters'), options: any(named: 'options')))
          .thenAnswer((_) async => successResponse);

      final result = await apiHandler.get(url: testUrl);
      expect(result, {'result': 'ok'});
    });

    test('POST success', () async {
      when(() => mockDio.post(any(), data: any(named: 'data'), options: any(named: 'options')))
          .thenAnswer((_) async => successResponse);

      final result = await apiHandler.post(url: testUrl, body: testData);
      expect(result, {'result': 'ok'});
    });


    test('Handles 204 No Content', () async {
      final response204 = Response(
        requestOptions: RequestOptions(path: testUrl),
        data: null,
        statusCode: 204,
      );

      when(() => mockDio.get(any(), queryParameters: any(named: 'queryParameters'), options: any(named: 'options')))
          .thenAnswer((_) async => response204);

      final result = await apiHandler.get(url: testUrl);
      expect(result, null);
    });

    test('Throws exception for non-200/201/204 responses', () async {
      final errorResponse = Response(
        requestOptions: RequestOptions(path: testUrl),
        data: {},
        statusCode: 500,
      );

      when(() => mockDio.get(any(), queryParameters: any(named: 'queryParameters'), options: any(named: 'options')))
          .thenAnswer((_) async => errorResponse);

      expect(() => apiHandler.get(url: testUrl), throwsException);
    });
  });
}
