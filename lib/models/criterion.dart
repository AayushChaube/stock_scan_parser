class Criterion {
  String type;
  String text;
  Map<String, dynamic>? variable;

  Criterion({
    required this.type,
    required this.text,
    this.variable,
  });

  factory Criterion.fromJson(Map<String, dynamic> json) => Criterion(
        type: json["type"],
        text: json["text"],
        variable: json["variable"] == null
            ? null
            : json["variable"] as Map<String, dynamic>,
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "text": text,
        "variable": variable,
      };
}
