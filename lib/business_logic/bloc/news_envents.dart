import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class ArticleEvents extends Equatable {
  const ArticleEvents();
  @override
  List<Object?> get props => [];
}

class LoadArticleEvent extends ArticleEvents {
  final Map<String, dynamic>? queryParams;

  const LoadArticleEvent({this.queryParams});
  @override
  List<Object?> get props => [queryParams];
}
