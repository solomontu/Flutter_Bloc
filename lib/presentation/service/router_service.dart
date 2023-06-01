import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:test/data_source/model/news_tile_model.dart';
import 'package:test/presentation/detail_page.dart';
import 'package:test/presentation/home_page.dart';

import '../../data_source/data_provider/article_repository.dart';

class AppRouter {
  AppRouter();
  final GoRouter router = GoRouter(
    routes: [
      GoRoute(
          path: '/',
          builder: (context, state) => RepositoryProvider(
                create: (context) => NewsRepository(),
                child: const HomePageScreen(),
              ),
          routes: [
            GoRoute(
                path: 'detail',
                name: 'detail',
                builder: (context, state) {
                  DetailPageValues detailValues =
                      state.extra as DetailPageValues;
                  return DetailPage(
                    detailValues: detailValues,
                  );
                })
          ]),
    ],
  );
// Route onGenerateRoute(RouteSettings routeSettings) {
//   switch (routeSettings.name) {
//     case '/':
//       return MaterialPageRoute(
//         builder: (_) => RepositoryProvider(
//           create: (context) => ArticleRepository(),
//           child: const HomePageScreen(),
//         ),
//       );
//
//     case '/detail':
//       return MaterialPageRoute(builder: (_) {
//         Result result = Result();
//         return DetailPage(result: result);
//       });
//     default:
//       return MaterialPageRoute(builder: (_) => const InvalidRoute());
//   }
// }
}
