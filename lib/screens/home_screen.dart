import 'dart:async';

import 'package:flutter/material.dart';
import 'package:toonflix/models/webtoon_model.dart';
import 'package:toonflix/services/api_service.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final Future<List<WebtoonModel>> webtoons = ApiService.getTodaysToons();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 1, //음영
        backgroundColor:
            const Color.fromARGB(255, 112, 106, 106).withOpacity(1), //배경색
        foregroundColor: Colors.white, //타이틀
        title: const Text(
          "Today's WebToon",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
        ), //제목
      ),
      //FutureBuilder를 통해서 미래의 값을 가져오는것을 볼수있게 async await wrap되어있는 개념
      body: FutureBuilder(
        future: webtoons,
        builder: (context, furturResult) {
          //데이터 존재 여부 확인
          if (furturResult.hasData) {
            //api에서 가져온 데이터를 화면상 보이는 것들만 가져오도록 최적화
            //ListView.builder
            //api에서 가져온 데이터를 화면상 보이는 것들만 가져오도록 최적화 + 가져온 값사이의 기능 추가
            //ListView.separated
            return makeList(furturResult);
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  ListView makeList(AsyncSnapshot<List<WebtoonModel>> furturResult) {
    return ListView.separated(
        //데이터가 나오는 방향 설정
        scrollDirection: Axis.horizontal,
        //출력되어지는 데이터의 갯수
        itemCount: furturResult.data!.length,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        itemBuilder: (context, index) {
          var webtoon = furturResult.data![index];
          return Column(
            children: [
              const SizedBox(height: 30),
              Container(
                width: 180,
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 15,
                        offset: const Offset(3, 3),
                        color: Colors.black.withOpacity(0.5),
                      )
                    ]),
                child: Image.network(
                  webtoon.thumb,
                  headers: const {
                    "User-Agent":
                        "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36",
                  },
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(webtoon.title,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.w600)),
            ],
          );
        },
        separatorBuilder: (context, index) => const SizedBox(width: 20));
  }
}
