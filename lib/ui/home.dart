import 'package:card_en_sqlite/model/english_card_model.dart';
import 'package:card_en_sqlite/model/level_card_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/card_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _word = TextEditingController();
  TextEditingController _mean = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Consumer<CardProvider>(builder: (context, cardProvider, child) {
      if (cardProvider.loading) {
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      } else {
        var levels = cardProvider.levels;
        var data = cardProvider.data;
        print(data.cards.length);
        return Scaffold(
          body: Center(
            child: ListView.builder(
              itemCount: data.cards.length,
              itemBuilder: (context, index) {
                var item = data.cards[index];
                var itemLevel = levels[item.level];
                return Card(
                  child: ListTile(
                    leading: _itemIcon(itemLevel),
                    title: Text(item.word),
                    subtitle: Text(item.mean),
                    onLongPress: (){
                      cardProvider.deleteCard(item);
                    },
                  ),
                );
              },
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    String levelValue = levels[0].name;
                    return StatefulBuilder(
                      builder: (context, setDialog) {
                        return AlertDialog(
                          title: const Text("Card"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text("CANCEL"),
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton(
                              onPressed: () async {
                                var _level = levels.firstWhere((e) => e.name==levelValue);
                                cardProvider.addCard(EnglishCard(
                                    id: 0,
                                    level: _level.id,
                                    word: _word.text,
                                    mean: _mean.text));
                                _word.text = "";
                                _mean.text = "";
                                Navigator.pop(context);
                              },
                              child: const Text("ADD"),
                            )
                          ],
                          content: SizedBox(
                            width: 300,
                            height: 200,
                            child: Column(
                              children: [
                                TextFormField(
                                  controller: _word,
                                  decoration: const InputDecoration(
                                    label: Text("New word"),
                                  ),
                                ),
                                TextFormField(
                                  controller: _mean,
                                  decoration: const InputDecoration(
                                    label: Text("Mean"),
                                  ),
                                ),
                                DropdownButton(
                                  value: levelValue,
                                    items: levels
                                        .map<DropdownMenuItem<String>>(
                                            (e) => DropdownMenuItem<String>(
                                                  value: e.name,
                                                  child: Text(e.name),   
                                                ))
                                        .toList(),
                                    onChanged: (String? st) {
                                      levelValue = st!;
                                      setDialog((){});
                                    })
                              ],
                            ),
                          ),
                        );
                      }
                    );
                  });
            },
            child: const Icon(Icons.add),
          ),
        );
      }
    });
  }

  _itemIcon(CardLevel l) {
    switch (l.id) {
      case 2:
        return Icon(Icons.priority_high, color: l.color);
      case 1:
        return Icon(Icons.shield, color: l.color);
      case 0:
        return Icon(Icons.mood, color: l.color);
      default:
        return const Icon(Icons.question_mark, color: Colors.grey);
    }
  }
}
