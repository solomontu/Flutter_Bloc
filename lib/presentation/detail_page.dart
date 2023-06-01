import 'package:flutter/material.dart';
import 'package:test/data_source/model/news_tile_model.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({super.key, required this.detailValues});

  final DetailPageValues detailValues;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
          maintainBottomViewPadding: true,
          child: WebViewWidget(controller: detailValues.webViewController)),
    );
  }
}
