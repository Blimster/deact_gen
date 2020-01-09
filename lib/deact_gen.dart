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

void generate(ElementDefinitions definitions) {
  print('part of deact;');
  print('');

  definitions.elements.forEach((k, v) {
    print('Element $k({');
    print('Object key, ');

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
      if (attr == null || attr.global) {
        throw StateError('attribute $a in element $k is not supported or is a global attribute!');
      }
      final name = attr.alternativeName != null && attr.alternativeName.trim().isNotEmpty ? attr.alternativeName : a;
      // print('${_mapType(attr.type)} $name, ');
      print('String $name, ');
    });

    definitions.events.forEach((v, k) {
      print('EventListener<$k> on$v, ');
    });

    print('List<Node> children,');
    print('}) {');

    print('final attributes = <String, Object>{};');

    definitions.attributes.forEach((v, k) {
      final name = k.alternativeName != null && k.alternativeName.trim().isNotEmpty ? k.alternativeName : v;
      if (k.global) {
        print('if($name != null) {');
        print('attributes[\'$name\'] = $name;');
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
      print('attributes[\'$name\'] = $name;');
      print('}');
    });

    print('final listeners = <String, Object>{};');
    definitions.events.forEach((k, v) {
      print('if(on$k != null) {');
      print('listeners[\'on$k\'] = on$k;');
      print('}');
    });

    print('return Element._(\'$k\', key, attributes, listeners, children,);');
    print('}');
    print('');
  });
}
