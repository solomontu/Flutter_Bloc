import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test/business_logic/bloc/bloc_state.dart';
import 'package:test/business_logic/bloc/news_envents.dart';
import 'package:test/data_source/data_provider/article_repository.dart';
import 'package:test/data_source/model/news_tile_model.dart';

class NewsBloc extends Bloc<ArticleEvents, ArticleState> {
  final NewsRepository _articleRepository;

  NewsBloc(this._articleRepository) : super(ArticleLoadingState()) {
    ArticleResponse? result;
    on<LoadArticleEvent>((event, emit) async {
      try {
        result = await _articleRepository.getArticles(
            search: event.queryParams ?? {});
        if (result!.results!.isNotEmpty) {
          emit(ArticleLoadedState(result!));
        } else {
          emit(ArticleEmptyState('No result found'));
        }
      } catch (err) {
        emit(ArticleErrorState(err.toString()));
      }
    });
  }
}
