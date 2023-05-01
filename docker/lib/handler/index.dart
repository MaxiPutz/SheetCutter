import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_static/shelf_static.dart' as st;
import 'package:shelf_cors_headers/shelf_cors_headers.dart' as cors;
import 'router.dart';

final overrideHeaders = {
  cors.ACCESS_CONTROL_ALLOW_ORIGIN: '*',
  'Content-Type': 'application/json;charset=utf-8'
};

Handler customHandler() {
  final service = Service();

  final staticFolder =
      st.createStaticHandler("public", defaultDocument: "index.html");

  final pipe = Pipeline()
      .addMiddleware(cors.corsHeaders(headers: overrideHeaders))
      .addHandler(service.handler);

  final h = Cascade().add(staticFolder).add(pipe);
  return h.handler;
}
