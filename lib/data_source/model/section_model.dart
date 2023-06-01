class SectionsResponse {
  String? status;
  String? userTier;
  int? total;
  List<Result>? results;

  SectionsResponse({
    this.status,
    this.userTier,
    this.total,
    this.results,
  });

  factory SectionsResponse.fromJson(Map<String, dynamic> json) =>
      SectionsResponse(
        status: json["status"],
        userTier: json["userTier"],
        total: json["total"],
        results: json["results"] == null
            ? []
            : List<Result>.from(
                json["results"]!.map((x) => Result.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "userTier": userTier,
        "total": total,
        "results": results == null
            ? []
            : List<dynamic>.from(results!.map((x) => x.toJson())),
      };
}

class Result {
  String? id;
  String? webTitle;
  String? webUrl;
  String? apiUrl;
  List<Result>? editions;
  String? code;

  Result({
    this.id,
    this.webTitle,
    this.webUrl,
    this.apiUrl,
    this.editions,
    this.code,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        webTitle: json["webTitle"],
        webUrl: json["webUrl"],
        apiUrl: json["apiUrl"],
        editions: json["editions"] == null
            ? []
            : List<Result>.from(
                json["editions"]!.map((x) => Result.fromJson(x))),
        code: json["code"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "webTitle": webTitle,
        "webUrl": webUrl,
        "apiUrl": apiUrl,
        "editions": editions == null
            ? []
            : List<dynamic>.from(editions!.map((x) => x.toJson())),
        "code": code,
      };
}
