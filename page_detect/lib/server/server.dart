import 'package:page_detect/server/static.dart' as s;
import 'package:page_detect/server/router.dart' as r;
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_cors_headers/shelf_cors_headers.dart' as cors;
import 'dart:io' as io;

final _overrideHeaders = {
  cors.ACCESS_CONTROL_ALLOW_ORIGIN: '*',
  'Content-Type': 'application/json;charset=utf-8'
};

void runServer() async {
  final staticFolder = s.Service().handler;
  final route = r.Service().handler;

  final p1 =
      const Pipeline().addMiddleware(logRequests()).addHandler(staticFolder);
  final p2 = const Pipeline()
      .addMiddleware(cors.corsHeaders(headers: _overrideHeaders))
      .addHandler(route);

  final c = Cascade().add(p1).add(p2).handler;

  const ipAdress = "192.168.0.206";
  const port = 8080;

  await shelf_io.serve(c, ipAdress, port);

  print("server is running on port $port and ip $ipAdress");
}
