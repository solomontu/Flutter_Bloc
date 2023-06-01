import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:test/data_source/model/news_tile_model.dart';

@immutable
abstract class ArticleState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ArticleLoadingState extends ArticleState {
  @override
  List<Object?> get props => [];
}

class ArticleLoadedState extends ArticleState {
  ArticleLoadedState(this.articleLoaded);

  final ArticleResponse articleLoaded;

  @override
  List<Object?> get props => [articleLoaded];
}

class ArticleErrorState extends ArticleState {
  ArticleErrorState(this.error);

  final String error;

  @override
  List<Object?> get props => [error];
}

class ArticleEmptyState extends ArticleState {
  final String empty;

  ArticleEmptyState(this.empty);

  @override
  // TODO: implement props
  List<Object?> get props => [empty];
}
