import 'dart:convert';
import 'dart:io';

import 'package:deact_gen/model.dart';
import 'package:deact_gen/deact_gen.dart';
import 'package:resource/resource.dart';

void main(List<String> arguments) async {
  final resource = Resource('package:deact_gen/${arguments[0]}.json');
  final definitions = ElementDefinitions.fromJson(json.decode(await resource.readAsString()) as Map<String, dynamic>);

  final lines = <String>[];
  void writer(Object object) {
    if (object != null) {
      lines.add('${object.toString()}');
    }
  }

  generate(arguments[0], definitions, writer);

  final target = File('output_${arguments[0]}.txt');
  await target.writeAsString(lines.join('\n'), flush: true);
}
