import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:test/business_logic/bloc/bloc_state.dart';
import 'package:test/business_logic/bloc/news_blocs.dart';
import 'package:test/business_logic/bloc/news_envents.dart';
import 'package:test/business_logic/bloc/section_bloc.dart';
import 'package:test/business_logic/bloc/section_state.dart';
import 'package:test/data_source/data_provider/article_repository.dart';
import 'package:test/data_source/model/news_tile_model.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../business_logic/bloc/section_events.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({Key? key}) : super(key: key);

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  int? currentPage;
  int? totalPages;
  bool? setColor;
  String? section;
  String? searchPhrase;
  Map<String, dynamic> searchParams = {};
  ScrollController scrollController = ScrollController();
  TextEditingController textEditingController = TextEditingController();
  NewsBloc? articleBloc;
  NewsRepository newsRepository = NewsRepository();
  late NewsBloc newsBloc;
  List<Result> allNews = [];
  ArticleResponse? data;

  scrollListener() {
    if (scrollController.position.atEdge) {
      if (scrollController.position.pixels == 0) {
        log('Scrolled to TOP');
      } else {
        log('Scrolled to bottom');
        nextPage();
      }
    }
  }

  textControllerListener() {
    if (textEditingController.text.isNotEmpty) {
      if (!searchParams.containsKey('q')) {
        searchParams.putIfAbsent('q', () => textEditingController.text);
      } else {
        searchParams.update('q', (value) => textEditingController.text);
      }
    }
  }

  void nextPage() {
    if (totalPages != null) {
      if (currentPage! != totalPages!) {
        currentPage = currentPage! + 1;
        if (!searchParams.containsKey('page')) {
          searchParams.putIfAbsent('page', () => currentPage);
        } else {
          searchParams.update('page', (value) => currentPage);
        }
        newsBloc.add(LoadArticleEvent(queryParams: searchParams));
      }
    }
    log('$searchParams');
  }

  void updatePageKey() {
    if (!searchParams.containsKey('page')) {
      searchParams.putIfAbsent('page', () => currentPage);
    } else {
      searchParams.update('page', (value) => currentPage);
    }
    newsBloc.add(LoadArticleEvent(queryParams: searchParams));
  }

  @override
  void initState() {
    scrollController.addListener(scrollListener);
    textEditingController.addListener(textControllerListener);
    newsBloc = NewsBloc(newsRepository);
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    textEditingController.dispose();
    newsBloc.isClosed;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: newsBloc..add(const LoadArticleEvent()),
      child: Scaffold(
        body: SafeArea(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    controller: textEditingController,
                    decoration: InputDecoration(
                        suffixIcon: MenuButton(onSelected: ((value) {
                          section = value;
                        })),
                        prefixIcon: Padding(
                          padding: const EdgeInsets.only(right: 30, left: 8),
                          child: InkWell(
                              child: const Icon(
                                Icons.search,
                                size: 30,
                              ),
                              onTap: () {
                                newsBloc.add(LoadArticleEvent(
                                    queryParams: searchParams));
                              }),
                        ),
                        border: const OutlineInputBorder(),
                        hintText: 'Search ...'),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: BlocBuilder<NewsBloc, ArticleState>(
                      builder: (context, state) {
                        if (state is ArticleLoadedState) {
                          data = state.articleLoaded;
                          totalPages = data?.pages;
                          currentPage = data?.currentPage!;
                          allNews.addAll(data?.results ?? []);

                          return Column(
                            children: [
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  // Text(
                                  //     'Page: ${data?.currentPage} of ${data?.pages}'),
                                ],
                              ),
                              Expanded(
                                child: RefreshIndicator(
                                  onRefresh: () async {
                                    allNews.clear();
                                    searchParams.clear();
                                    newsBloc.add(const LoadArticleEvent());
                                  },
                                  child: ListView.builder(
                                      controller: scrollController,
                                      itemCount: allNews.length,
                                      itemBuilder: (context, index) =>
                                          ResultBuilder(
                                              result: allNews[index])),
                                ),
                              ),
                            ],
                          );
                        } else if (state is ArticleLoadingState) {
                          return const Center(
                              child: SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator.adaptive()));
                        } else if (state is ArticleErrorState) {
                          return const Text('ERROR');
                        } else if (state is ArticleEmptyState &&
                            textEditingController.text.isNotEmpty) {
                          return Center(
                            child: Text(state.empty),
                          );
                        } else {
                          return _buildResults();
                        }
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResults() {
    return const Center(child: Text('Something went wrong'));
  }
}

class ResultBuilder extends StatelessWidget {
  ResultBuilder({super.key, required this.result});

  final Result? result;

  final WebViewController webViewController = WebViewController();

  void setWebView() {
    webViewController
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (!request.url.startsWith('https://www.theguardian.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(result!.webUrl!));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Card(
        color: Colors.white,
        elevation: 1,
        child: InkWell(
          onTap: () {
            setWebView();
            context.goNamed('detail',
                extra: DetailPageValues(
                    result: result!, webViewController: webViewController));
          },
          child: SizedBox(
            height: 100,
            child: Row(
              children: [
                Expanded(
                  child: ListTile(
                    title: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        result!.webTitle ?? '',
                        softWrap: true,
                        maxLines: 2,
                        overflow: TextOverflow.clip,
                        style: const TextStyle(
                            fontSize: 25, fontWeight: FontWeight.w600),
                      ),
                    ),
                    subtitle: Row(
                      children: [
                        Expanded(
                          child: Text(
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w400),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              result!.sectionName ?? ''),
                        ),
                        const Padding(padding: EdgeInsets.only(left: 8)),
                        Text(
                            '${DateFormat.yM().format(result!.webPublicationDate!)} ${DateFormat.jm().format(result!.webPublicationDate!)}'),
                        const Padding(padding: EdgeInsets.only(left: 8)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class NextPage extends StatelessWidget {
  const NextPage({
    Key? key,
    this.pageNumber,
    this.onTap,
    required this.currentPageNumber,
    required this.index,
  }) : super(key: key);
  final int? pageNumber;
  final void Function()? onTap;
  final int currentPageNumber;
  final int index;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap,
      child: Container(
        width: 40,
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black45),
            color: setTextBackgroundColor()),
        child: Align(
          alignment: Alignment.center,
          child: Text(
            pageNumber.toString(),
            style: TextStyle(color: setTextColor()),
          ),
        ),
      ),
    );
  }

  Color setTextBackgroundColor() {
    if (currentPageNumber == index) {
      return Colors.black45;
    } else {
      return Colors.white;
    }
  }

  Color setTextColor() {
    if (currentPageNumber == index) {
      return Colors.white;
    } else {
      return Colors.black45;
    }
  }
}

class MenuButton extends StatelessWidget {
  const MenuButton({Key? key, this.onSelected}) : super(key: key);
  final void Function(String)? onSelected;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SectionsBloc>(
      create: (context) => SectionsBloc(
        RepositoryProvider.of<NewsRepository>(context),
      )..add(LoadSectionsEvents()),
      child: BlocBuilder<SectionsBloc, SectionsState>(
        builder: (context, state) {
          if (state is SectionLoadingState) {
            return const Icon(Icons.hourglass_empty);
          } else if (state is SectionsEmptyState) {
            return PopupMenuButton<String>(
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: '',
                  child: Text(state.empty),
                ),
              ],
            );
          } else if (state is SectionsErrorState) {
            return const Icon(Icons.error_outline);
          } else if (state is SectionLoadedState) {
            var sections = state.sectionModel.results!;
            return PopupMenuButton<String>(
              constraints: const BoxConstraints(maxHeight: 600, maxWidth: 100),
              onSelected: onSelected,
              itemBuilder: (context) => sections
                  .map(
                    (e) => PopupMenuItem(
                      value: e.id,
                      child: Text(e.id!),
                    ),
                  )
                  .toList(),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
