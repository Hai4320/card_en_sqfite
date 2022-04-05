class EnglishCard{
  int id;
  String word;
  String mean;
  int level;
  EnglishCard({required this.id, required this.word, required this.mean, required this.level});
  
  Map<String, dynamic> toMap() => {
    "word":word,
    "mean":mean,
    "level": level,
  };

  factory EnglishCard.fromMap(Map<String, dynamic> data) => EnglishCard(
    id: data["id"],
    word:data["word"],
    mean:data["mean"],
    level:data["level"]
  );
}

class ListCard {
  List<EnglishCard> cards;
  ListCard(this.cards);
}