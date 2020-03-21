import 'package:cli/model/corona_test_case.dart';
import 'package:dio/dio.dart';

class APIService {
  static const API_BASE_PATH = "https://blffmaku9b.execute-api.eu-central-1.amazonaws.com/Prod/corona-test-case";
  static const API_TIMEOUT = 3000;
  static Dio dio = new Dio(BaseOptions(connectTimeout: API_TIMEOUT));

  static Future<List<CoronaTestCase>> createTestCases(final int amount) async {
    final Response response = await dio.post('${API_BASE_PATH}?amount=$amount');

    if (response.statusCode != 200)
      return null;

    final List<dynamic> json = response.data;
    final List<CoronaTestCase> testCases = [];

    for(final Map<String, dynamic> testCaseJSON in json) {
      testCases.add(CoronaTestCase.fromJson(testCaseJSON));
    }

    return testCases;
  }

  static Future<List<CoronaTestCase>> createTestCase() async {
    final Response response = await dio.post('${API_BASE_PATH}');

    if (response.statusCode != 200)
      return null;

    final data = response.data;
    return [CoronaTestCase.fromJson(data)];
  }
}