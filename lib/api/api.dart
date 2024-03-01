import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'api.g.dart';

@RestApi(baseUrl: '')
abstract class RhymerApiClient {
  factory RhymerApiClient(Dio dio, {String baseUrl}) = _RhymerApiClient;

  factory RhymerApiClient.create({String? apiKey}) {
    final dio = Dio();
    if (apiKey != null) {
      dio.options.headers['X-Api-Key'] = apiKey;
      return RhymerApiClient(dio, baseUrl: "https://api.api-ninjas.com/v1");
    }
    return RhymerApiClient(dio);
  }

  @GET('/rhyme')
  Future<List<String>> getRhymesList(@Query("word") String word);
}
