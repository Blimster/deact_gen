import 'model.dart';

String _mapType(String inputType) {
  switch (inputType) {
    case 'string':
      return 'String';
    case 'bool':
      return 'bool';
    case 'int':
      return 'int';
    case 'double':
      return 'double';
    case 'null':
      return 'Null';
    default:
      throw StateError('unsupported type $inputType!');
  }
}

void generate(String name, ElementDefinitions definitions, void Function(Object object) print) {
  print('part of deact_$name;');
  print('');

  definitions.elements.forEach((k, v) {
    print('ElementNode $k({');
    print('Object key, ');
    print('Ref<h.Element> ref, ');

    definitions.attributes.forEach((k, v) {
      if (v.global) {
        final attr = definitions.attributes[k];
        final name = attr.alternativeName != null && attr.alternativeName.trim().isNotEmpty ? attr.alternativeName : k;
        // print('${_mapType(attr.type)} $name, ');
        print('String $name, ');
      }
    });

    v.attributes.forEach((a) {
      final attr = definitions.attributes[a];
      if (attr == null) {
        throw StateError('attribute $a in element $k is not supported!');
      }
      if (attr.global) {
        throw StateError('attribute $a in element $k is a global attribute!');
      }
      final name = attr.alternativeName != null && attr.alternativeName.trim().isNotEmpty ? attr.alternativeName : a;
      // print('${_mapType(attr.type)} $name, ');
      print('String $name, ');
    });

    definitions.events.forEach((v, k) {
      print('EventListener<h.$k> on$v, ');
    });

    print('Iterable<DeactNode> children,');
    print('}) {');

    print('final attributes = <String, Object>{};');

    definitions.attributes.forEach((v, k) {
      final name = k.alternativeName != null && k.alternativeName.trim().isNotEmpty ? k.alternativeName : v;
      if (k.global) {
        print('if($name != null) {');
        print('attributes[\'$v\'] = $name;');
        print('}');
      }
    });
    v.attributes.forEach((a) {
      final attr = definitions.attributes[a];
      if (attr == null || attr.global) {
        throw StateError('attribute $a in element ${k} not supported or it is a global attribute!');
      }
      final name = attr.alternativeName != null && attr.alternativeName.trim().isNotEmpty ? attr.alternativeName : a;
      print('if($name != null) {');
      print('attributes[\'$a\'] = $name;');
      print('}');
    });

    print('final listeners = <String, Object>{};');
    definitions.events.forEach((k, v) {
      print('if(on$k != null) {');
      print('listeners[\'on$k\'] = on$k;');
      print('}');
    });

    print('return el(\'$k\', key: key, ref: ref, attributes: attributes, listeners: listeners, children: children,);');
    print('}');
    print('');
  });
}
