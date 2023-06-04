import 'dart:convert';

//http 패키지 가져오기(get,post...하기위해서 )
import 'package:http/http.dart' as http;
import 'package:toonflix/models/webtoon_model.dart';

class ApiService {
  static const String baseUrl =
      "https://webtoon-crawler.nomadcoders.workers.dev";
  static const String today = "today";

  //응답을 확실하게 받기 위해 async 부여
  static Future<List<WebtoonModel>> getTodaysToons() async {
    //응답값을 답을 객체 생성
    List<WebtoonModel> webtoonInstances = [];
    final url = Uri.parse('$baseUrl/$today');
    final response = await http.get(url);

    //응답이 제대로 올경우에 한에서만 작동
    if (response.statusCode == 200) {
      //string을 json으로 변환하기 위해 jsonDecode 적용
      final List<dynamic> webtoons = jsonDecode(response.body);
      for (var webtoon in webtoons) {
        final toon = WebtoonModel.fromJson(webtoon);
        webtoonInstances.add(toon);
      }
      return webtoonInstances;
    }
    throw Error();
  }
}
