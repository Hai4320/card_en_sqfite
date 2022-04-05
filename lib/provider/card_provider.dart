import 'package:card_en_sqlite/provider/database.dart';
import 'package:card_en_sqlite/model/english_card_model.dart';
import 'package:card_en_sqlite/model/level_card_model.dart';
import 'package:flutter/foundation.dart';

class CardProvider with ChangeNotifier {
  DatabaseHelper? dbHelper;
  ListCard data;
  List<CardLevel> levels = [];
  bool loading = true;
  CardProvider({required this.dbHelper, required this.data}) {
    if (dbHelper != null && dbHelper!.hasDatabase) {
      fetchData();
    }
  }

  void fetchData() async {
    try {
      data = await dbHelper!.getCardData();
      levels = await dbHelper!.getLevelData();
      loading = false;
      notifyListeners();
    } catch (e){
      print(e);
    }
    
  }

  void addCard(EnglishCard card) async {
    try{
      await dbHelper!.insertCard(card);
      data = await dbHelper!.getCardData();
      notifyListeners();
    } catch (e){
      print(e);
    }
    
  }
  void deleteCard(EnglishCard card) async {
    try{
      await dbHelper!.deleteCard(card);
      data = await dbHelper!.getCardData();
      notifyListeners();
    } catch (e){
      print(e);
    }
    
  } 
}
