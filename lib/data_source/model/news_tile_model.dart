// To parse this JSON data, do
//
//     final articleModel = articleModelFromJson(jsonString);

import 'dart:convert';

import 'package:webview_flutter/webview_flutter.dart';

ArticleModel articleModelFromJson(String str) =>
    ArticleModel.fromJson(json.decode(str));

String articleModelToJson(ArticleModel data) => json.encode(data.toJson());

class ArticleModel {
  ArticleResponse? response;

  ArticleModel({
    this.response,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json) => ArticleModel(
        response: json["response"] == null
            ? null
            : ArticleResponse.fromJson(json["response"]),
      );

  Map<String, dynamic> toJson() => {
        "response": response?.toJson(),
      };
}

class ArticleResponse {
  String? status;
  String? userTier;
  int? total;
  int? startIndex;
  int? pageSize;
  int? currentPage;
  int? pages;
  String? orderBy;
  List<Result>? results;

  ArticleResponse({
    this.status,
    this.userTier,
    this.total,
    this.startIndex,
    this.pageSize,
    this.currentPage,
    this.pages,
    this.orderBy,
    this.results,
  });

  factory ArticleResponse.fromJson(Map<String, dynamic> json) =>
      ArticleResponse(
        status: json["status"],
        userTier: json["userTier"],
        total: json["total"],
        startIndex: json["startIndex"],
        pageSize: json["pageSize"],
        currentPage: json["currentPage"],
        pages: json["pages"],
        orderBy: json["orderBy"],
        results: json["results"] == null
            ? []
            : List<Result>.from(
                json["results"]!.map((x) => Result.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "userTier": userTier,
        "total": total,
        "startIndex": startIndex,
        "pageSize": pageSize,
        "currentPage": currentPage,
        "pages": pages,
        "orderBy": orderBy,
        "results": results == null
            ? []
            : List<dynamic>.from(results!.map((x) => x.toJson())),
      };
}

class Result {
  String? id;
  String? type;
  String? sectionId;
  String? sectionName;
  DateTime? webPublicationDate;
  String? webTitle;
  String? webUrl;
  String? apiUrl;
  bool? isHosted;
  String? pillarId;
  String? pillarName;

  Result({
    this.id,
    this.type,
    this.sectionId,
    this.sectionName,
    this.webPublicationDate,
    this.webTitle,
    this.webUrl,
    this.apiUrl,
    this.isHosted,
    this.pillarId,
    this.pillarName,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        type: json["type"],
        sectionId: json["sectionId"],
        sectionName: json["sectionName"],
        webPublicationDate: json["webPublicationDate"] == null
            ? null
            : DateTime.parse(json["webPublicationDate"]),
        webTitle: json["webTitle"],
        webUrl: json["webUrl"],
        apiUrl: json["apiUrl"],
        isHosted: json["isHosted"],
        pillarId: json["pillarId"],
        pillarName: json["pillarName"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "sectionId": sectionId,
        "sectionName": sectionName,
        "webPublicationDate": webPublicationDate?.toIso8601String(),
        "webTitle": webTitle,
        "webUrl": webUrl,
        "apiUrl": apiUrl,
        "isHosted": isHosted,
        "pillarId": pillarId,
        "pillarName": pillarName,
      };
}

class DetailPageValues {
  final Result result;
  final WebViewController webViewController;

  DetailPageValues({required this.result, required this.webViewController});
}
