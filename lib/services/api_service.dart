import 'dart:convert';

//http 패키지 가져오기(get,post...하기위해서 )
import 'package:http/http.dart' as http;
import 'package:toonflix/models/webtoon_model.dart';

import '../models/webtoon_detail_model.dart';
import '../models/webtoon_episode_model.dart';

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
      //response값이 객체값인 배열로 오기에 이를 for문을 통해서 값을 넣어준다.
      for (var webtoon in webtoons) {
        final toon = WebtoonModel.fromJson(webtoon);
        webtoonInstances.add(toon);
      }
      return webtoonInstances;
    }
    throw Error();
  }

  static Future<WebtoonDetailModel> getToonById(String id) async {
    final url = Uri.parse("$baseUrl/$id");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final webtoon = jsonDecode(response.body);
      return WebtoonDetailModel.fromJson(webtoon);
    }
    throw Error();
  }

  static Future<List<WebtooEpisodeModel>> getLatestEpisodesById(
      String id) async {
    List<WebtooEpisodeModel> episodesInstances = [];

    final url = Uri.parse("$baseUrl/$id/episodes");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final episodes = jsonDecode(response.body);
      for (var episode in episodes) {
        episodesInstances.add(WebtooEpisodeModel.fromJson(episode));
      }
      return episodesInstances;
    }
    throw Error();
  }
}
