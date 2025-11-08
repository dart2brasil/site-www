---
ia-translate: true
title: Metadata
description: Metadata e annotations em Dart.
prevpage:
  url: /language/functions
  title: Functions
nextpage:
  url: /language/libraries
  title: Libraries & imports
---


Use metadata para fornecer informações estáticas adicionais sobre seu código.
Uma annotation de metadata começa com o caractere `@`, seguido por uma
referência a uma constante em tempo de compilação (como `deprecated`) ou
uma chamada a um construtor constante.

Metadata pode ser anexado à maioria das construções de programa Dart
adicionando annotations antes da declaração ou diretiva da construção.

## Annotations built-in

As seguintes annotations estão disponíveis para todo código Dart:

[`@Deprecated`][]
: Marca uma declaração como descontinuada,
  indicando que ela deve ser migrada,
  com uma mensagem explicando a substituição e data de remoção potencial.

[`@deprecated`][]
: Marca uma declaração como descontinuada até uma futura versão não especificada.
  Prefira usar `@Deprecated` e [fornecer uma mensagem de descontinuação][providing a deprecation message].

[`@override`][]
: Marca um membro de instância como uma sobrescrita ou implementação de
  um membro com o mesmo nome de uma classe pai ou interface.
  Para exemplos de uso de `@override`, confira [Estender uma classe][Extend a class].

[`@pragma`][]
: Fornece instruções ou dicas específicas sobre uma declaração para
  ferramentas Dart, como o compilador ou analisador.

Aqui está um exemplo de uso da annotation `@Deprecated`:

<?code-excerpt "misc/lib/language_tour/metadata/television.dart (deprecated)"?>
```dart highlightLines=3
class Television {
  /// Use [turnOn] to turn the power on instead.
  @Deprecated('Use turnOn instead')
  void activate() {
    turnOn();
  }

  /// Turns the TV's power on.
  void turnOn() {
    // ···
  }
  // ···
}
```

O [analisador Dart][Dart analyzer] fornece feedback como diagnósticos se
a annotation `@override` for necessária e ao usar
membros anotados com `@deprecated` ou `@Deprecated`.

[`@Deprecated`]: {{site.dart-api}}/dart-core/Deprecated-class.html
[`@deprecated`]: {{site.dart-api}}/dart-core/deprecated-constant.html
[`@override`]: {{site.dart-api}}/dart-core/override-constant.html
[`@pragma`]: {{site.dart-api}}/dart-core/pragma-class.html
[providing a deprecation message]: /tools/linter-rules/provide_deprecation_message
[Extend a class]: /language/extend
[Dart analyzer]: /tools/analysis

## Annotations suportadas pelo analisador

Além de fornecer suporte e análise para as [annotations built-in][built-in annotations],
o [analisador Dart][Dart analyzer] fornece suporte adicional e diagnósticos para
uma variedade de annotations do [`package:meta`][].
Algumas annotations comumente usadas que o pacote fornece incluem:

[`@visibleForTesting`][]
: Marca um membro de um pacote como apenas público para que
  o membro possa ser acessado dos testes do pacote.
  O analisador oculta o membro das sugestões de autocompletar
  e avisa se ele for usado de outro pacote.

[`@awaitNotRequired`][]
: Marca variáveis que têm um tipo `Future` ou funções que retornam um `Future`
  como não requerendo que o chamador aguarde o `Future`.
  Isso impede que o analisador avise chamadores que não aguardam o `Future`
  devido aos lints [`discarded_futures`][] ou [`unawaited_futures`][].

Para saber mais sobre essas e outras annotations que o pacote fornece,
o que elas indicam, que funcionalidade elas habilitam e como usá-las,
confira a [documentação da API `package:meta/meta.dart`][meta-api].

[built-in annotations]: #built-in-annotations
[Dart analyzer]: /tools/analysis
[`@visibleForTesting`]: {{site.pub-api}}/meta/latest/meta/visibleForTesting-constant.html
[`@awaitNotRequired`]: {{site.pub-api}}/meta/latest/meta/awaitNotRequired-constant.html
[`discarded_futures`]: /tools/linter-rules/discarded_futures
[`unawaited_futures`]: /tools/linter-rules/unawaited_futures
[meta-api]: {{site.pub-api}}/meta/latest/meta/meta-library.html

## Annotations personalizadas

Você pode definir suas próprias annotations de metadata. Aqui está um exemplo de
definição de uma annotation `@Todo` que recebe dois argumentos:

<?code-excerpt "misc/lib/language_tour/metadata/todo.dart (definition)"?>
```dart
class Todo {
  final String who;
  final String what;

  const Todo(this.who, this.what);
}
```

E aqui está um exemplo de uso dessa annotation `@Todo`:

<?code-excerpt "misc/lib/language_tour/metadata/misc.dart (usage)"?>
```dart highlightLines=1
@Todo('Dash', 'Implement this function')
void doSomething() {
  print('Do something');
}
```

### Especificando alvos suportados {:.no_toc}

Para indicar o tipo de construções de linguagem que
devem ser anotadas com sua annotation,
use a annotation [`@Target`][] do [`package:meta`][].

Por exemplo, se você quisesse que a annotation `@Todo` anterior
fosse permitida apenas em funções e métodos,
você adicionaria a seguinte annotation:

<?code-excerpt "misc/lib/language_tour/metadata/todo.dart (target-kinds)"?>
```dart highlightLines=3
import 'package:meta/meta_meta.dart';

@Target({TargetKind.function, TargetKind.method})
class Todo {
  // ···
}
```

Com essa configuração, o analisador avisará se `Todo` for usado como
uma annotation em qualquer declaração além de uma função ou método de nível superior.

[`@Target`]: {{site.pub-api}}/meta/latest/meta_meta/Target-class.html
[`package:meta`]: {{site.pub-pkg}}/meta
