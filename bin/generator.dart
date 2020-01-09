import 'dart:convert';

import 'package:deact_gen/model.dart';
import 'package:deact_gen/deact_gen.dart';
import 'package:resource/resource.dart';

void main(List<String> arguments) async {
  final resource = Resource('package:deact_gen/elements.json');
  final definitions = ElementDefinitions.fromJson(json.decode(await resource.readAsString()));
  generate(definitions);
}
