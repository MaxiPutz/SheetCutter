import 'package:shelf/shelf.dart';
import 'package:shelf_static/shelf_static.dart' as st;

class Service {
  Handler get handler {
    final staticFolder = st.createStaticHandler("../page_detect_web/build/web/",
        defaultDocument: "index.html");
    return staticFolder;
  }
}
