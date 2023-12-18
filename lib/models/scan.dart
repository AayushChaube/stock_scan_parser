import 'criterion.dart';

class Scan {
  int id;
  String name;
  String tag;
  String color;
  List<Criterion> criteria;

  Scan({
    required this.id,
    required this.name,
    required this.tag,
    required this.color,
    required this.criteria,
  });

  factory Scan.fromJson(Map<String, dynamic> json) => Scan(
        id: json["id"],
        name: json["name"],
        tag: json["tag"],
        color: json["color"],
        criteria: List<Criterion>.from(
            json["criteria"].map((x) => Criterion.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "tag": tag,
        "color": color,
        "criteria": List<dynamic>.from(criteria.map((x) => x.toJson())),
      };
}
