import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:fwfh_webview/fwfh_webview.dart';

class MyWidgetFactory extends WidgetFactory with WebViewFactory {
  // optional: override getter to configure how WebViews are built
  @override
  bool get webViewMediaPlaybackAlwaysAllow => true;
  @override
  String? get webViewUserAgent => 'My app';
}

class ManagementUserView extends ConsumerStatefulWidget {
  const ManagementUserView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ManagementUserViewState();
}

class _ManagementUserViewState extends ConsumerState<ManagementUserView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mantenimiento: Usuarios"),
        centerTitle: false,
      ),
      body: HtmlWidget(
        """
        <iframe width="560" height="315" src="http://172.16.220.50:8090/_/?#/" frameborder="0" allowfullscreen></iframe>
        """,
        factoryBuilder: () => MyWidgetFactory(),
      ),
    );
  }
}
