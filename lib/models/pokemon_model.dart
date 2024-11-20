class PokemonCard {
  final String id;
  final String name;
  final Images images;

  PokemonCard({
    required this.id,
    required this.name,
    required this.images,
  });

  factory PokemonCard.fromJson(Map<String, dynamic> json) {
    return PokemonCard(
      id: json['id'],
      name: json['name'],
      images: Images.fromJson(json['images']),
    );
  }
}

class PokemonDetailsModel {
  final String? id;
  final String? name;
  final Images? images;
  final List<String> types;
  final List<Attack> attacks;
  final List<Weakness> weaknesses;
  final String? artist;
  final String? rarity;
  final Set? set;

  PokemonDetailsModel({
    required this.id,
    required this.name,
    required this.images,
    required this.types,
    required this.attacks,
    required this.weaknesses,
    required this.set,
    required this.artist,
    required this.rarity,
  });

  factory PokemonDetailsModel.fromJson(Map<String, dynamic> json) {
    var attackList =
        (json['attacks'] as List).map((a) => Attack.fromJson(a)).toList();
    var weaknessList =
        (json['weaknesses'] as List).map((w) => Weakness.fromJson(w)).toList();

    return PokemonDetailsModel(
      id: json['id'],
      types: List<String>.from(json['types']),
      set: Set.fromJson(json['set']),
      attacks: attackList,
      artist: json['artist'],
      weaknesses: weaknessList,
      rarity: json['rarity'],
      name: json['name'],
      images: Images.fromJson(json['images']),
    );
  }
}

// Nested model for Ability

// Nested model for Set images
class SetImages {
  final String? symbol;
  final String? logo;

  SetImages({
    required this.symbol,
    required this.logo,
  });

  factory SetImages.fromJson(Map<String, dynamic> json) {
    return SetImages(
      symbol: json['symbol'],
      logo: json['logo'],
    );
  }
}

// Nested model for Images
class Images {
  final String? small;
  final String? large;

  Images({
    required this.small,
    required this.large,
  });

  factory Images.fromJson(Map<String, dynamic> json) {
    return Images(
      small: json['small'],
      large: json['large'],
    );
  }
}

class Set {
  final String? id;
  final String? name;
  final String? series;
  final int? printedTotal;
  final int? total;
  final String? ptcgoCode;
  final String? releaseDate;
  final String? updatedAt;
  final Map<String, String>? images;

  Set({
    required this.id,
    required this.name,
    required this.series,
    required this.printedTotal,
    required this.total,
    required this.ptcgoCode,
    required this.releaseDate,
    required this.updatedAt,
    required this.images,
  });

  // Factory constructor to parse from JSON
  factory Set.fromJson(Map<String, dynamic> json) {
    return Set(
      id: json['id'],
      name: json['name'],
      series: json['series'],
      printedTotal: json['printedTotal'],
      total: json['total'],
      ptcgoCode: json['ptcgoCode'],
      releaseDate: json['releaseDate'],
      updatedAt: json['updatedAt'],
      images: Map<String, String>.from(json['images']),
    );
  }
}

class Weakness {
  final String? type;
  final String? value;

  Weakness({
    required this.type,
    required this.value,
  });

  // Factory constructor to parse from JSON
  factory Weakness.fromJson(Map<String, dynamic> json) {
    return Weakness(
      type: json['type'],
      value: json['value'],
    );
  }
}

class Attack {
  final String? name;
  final List<String>? cost;
  final int? convertedEnergyCost;
  final String? damage;
  final String? text;

  Attack({
    required this.name,
    required this.cost,
    required this.convertedEnergyCost,
    required this.damage,
    required this.text,
  });

  // Factory constructor to parse from JSON
  factory Attack.fromJson(Map<String, dynamic> json) {
    return Attack(
      name: json['name'],
      cost: List<String>.from(json['cost']),
      convertedEnergyCost: json['convertedEnergyCost'],
      damage: json['damage'],
      text: json['text'],
    );
  }
}
