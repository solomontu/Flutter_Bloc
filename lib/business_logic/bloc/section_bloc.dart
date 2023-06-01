import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test/business_logic/bloc/section_events.dart';
import 'package:test/business_logic/bloc/section_state.dart';
import 'package:test/data_source/data_provider/article_repository.dart';

class SectionsBloc extends Bloc<SectionsEvents, SectionsState> {
  final NewsRepository _articleRepository;

  SectionsBloc(this._articleRepository) : super(SectionLoadingState()) {
    on<LoadSectionsEvents>((event, emit) async {
      try {
        final sections = await _articleRepository.getSections();
        if (sections.results!.isNotEmpty) {
          emit(SectionLoadedState(sections));
        } else {
          emit(SectionsEmptyState('Empty sections'));
        }
      } catch (err) {
        emit(SectionsErrorState(err.toString()));
      }
    });
  }
}
