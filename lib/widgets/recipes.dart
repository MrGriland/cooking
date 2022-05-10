import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../network/recipesnetwork.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int counter = 0;
  final List<String> entries = <String>['Чизкейк Нью-Йорк классический', 'Family', 'Sports'];
  final List<int> colorCodes = <int>[600, 500, 100];

  ListTile _tile(String title, String subtitle) {
    return ListTile(
      title: Text(title,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 20,
          )),
      subtitle: Text(subtitle),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(8),
      itemCount: entries.length,
      itemBuilder: (BuildContext context, int index) {
        return SizedBox(
          height: 70,
          child: _tile(entries[index], 'Чизкейк — классическое блюдо американской кухни, которое прочно вошло в меню кафешек всего мира. Его достаточно просто готовить (если чётко следовать всем инструкциям в рецепте), а в результате получается невероятно вкусный и нежный десерт. Мы будем делать классику жанра — Чизкейк Нью-Йорк. Попробуем приготовить?  Самое сложное в приготовлении чизкейка — найти подходящий творожный (сливочный) сыр. По аутентичным рецептам используется сыр «Филадельфия» (Philadelphia). Главный недостаток этого варианта — этот сыр сейчас очень трудно достать в России. Поэтому подбираем сливочный сыр по мере возможности. Никакие плавленые сыры, творог, сметана и Маскарпоне не подходят. А уже тем более Creme Bonjour и прочие малополезные псевдосыры.'.substring(0, 80)+"..."),
        );
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(),
    );
    // This trailing comma makes auto-formatting nicer for build methods.
  }
}