import 'package:equatable/equatable.dart';
import 'package:test/data_source/model/section_model.dart';

///Sections block
abstract class SectionsState extends Equatable {}

class SectionLoadingState extends SectionsState {
  @override
  List<Object?> get props => [];
}

class SectionLoadedState extends SectionsState {
  SectionLoadedState(this.sectionModel);

  final SectionsResponse sectionModel;

  @override
  List<Object?> get props => [sectionModel];
}

class SectionsErrorState extends SectionsState {
  SectionsErrorState(this.error);

  final String error;

  @override
  List<Object?> get props => [error];
}

class SectionsEmptyState extends SectionsState {
  final String empty;
  SectionsEmptyState(this.empty);

  @override
  // TODO: implement props
  List<Object?> get props => [empty];
}
