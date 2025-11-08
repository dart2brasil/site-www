---
ia-translate: true
title: Metadados
description: "Metadados e anotações em Dart."
prevpage:
  url: /language/functions
  title: Functions
nextpage:
  url: /language/libraries
  title: Libraries & imports
---


Use metadados para fornecer informações estáticas adicionais sobre seu código.
Uma anotação de metadados começa com o caractere `@`, seguido por uma
referência a uma constante de tempo de compilação (como `deprecated`) ou
uma chamada a um construtor constante.

Metadados podem ser anexados à maioria das construções de programa Dart
adicionando anotações antes da declaração ou diretiva da construção.

## Anotações integradas

As seguintes anotações estão disponíveis para todo código Dart:

[`@Deprecated`][]
: Marca uma declaração como obsoleta (deprecated),
  indicando que deve ser migrada para outra opção,
  com uma mensagem explicando a substituição e data potencial de remoção.

[`@deprecated`][]
: Marca uma declaração como obsoleta até uma versão futura não especificada.
  Prefira usar `@Deprecated` e [fornecer uma mensagem de depreciação][].

[`@override`][]
: Marca um membro de instância como uma sobrescrita ou implementação de
  um membro com o mesmo nome de uma classe pai ou interface.
  Para exemplos de uso de `@override`, confira [Estender uma classe][].

[`@pragma`][]
: Fornece instruções ou dicas específicas sobre uma declaração para
  ferramentas Dart, como o compilador ou analisador.

Aqui está um exemplo de uso da anotação `@Deprecated`:

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

O [analisador Dart][] fornece feedback como diagnósticos se
a anotação `@override` for necessária e ao usar
membros anotados com `@deprecated` ou `@Deprecated`.

[`@Deprecated`]: {{site.dart-api}}/dart-core/Deprecated-class.html
[`@deprecated`]: {{site.dart-api}}/dart-core/deprecated-constant.html
[`@override`]: {{site.dart-api}}/dart-core/override-constant.html
[`@pragma`]: {{site.dart-api}}/dart-core/pragma-class.html
[fornecer uma mensagem de depreciação]: /tools/linter-rules/provide_deprecation_message
[Estender uma classe]: /language/extend
[analisador Dart]: /tools/analysis

## Anotações suportadas pelo analisador

Além de fornecer suporte e análise para as [anotações integradas][],
o [analisador Dart][] fornece suporte adicional e diagnósticos para
uma variedade de anotações do [`package:meta`][].
Algumas anotações comumente usadas que o pacote fornece incluem:

[`@visibleForTesting`][]
: Marca um membro de um pacote como público apenas para que
  o membro possa ser acessado a partir dos testes do pacote.
  O analisador oculta o membro das sugestões de autocompletar
  e avisa se for usado de outro pacote.

[`@awaitNotRequired`][]
: Marca variáveis que têm um tipo `Future` ou funções que retornam um `Future`
  como não exigindo que o chamador aguarde (await) o `Future`.
  Isso impede que o analisador avise chamadores que não aguardam o `Future`
  devido aos lints [`discarded_futures`][] ou [`unawaited_futures`][].

Para saber mais sobre essas e outras anotações que o pacote fornece,
o que elas indicam, qual funcionalidade elas habilitam e como usá-las,
confira a [documentação da API `package:meta/meta.dart`][meta-api].

[anotações integradas]: #built-in-annotations
[analisador Dart]: /tools/analysis
[`@visibleForTesting`]: {{site.pub-api}}/meta/latest/meta/visibleForTesting-constant.html
[`@awaitNotRequired`]: {{site.pub-api}}/meta/latest/meta/awaitNotRequired-constant.html
[`discarded_futures`]: /tools/linter-rules/discarded_futures
[`unawaited_futures`]: /tools/linter-rules/unawaited_futures
[meta-api]: {{site.pub-api}}/meta/latest/meta/meta-library.html

## Anotações personalizadas

Você pode definir suas próprias anotações de metadados. Aqui está um exemplo de
definir uma anotação `@Todo` que recebe dois argumentos:

<?code-excerpt "misc/lib/language_tour/metadata/todo.dart (definition)"?>
```dart
class Todo {
  final String who;
  final String what;

  const Todo(this.who, this.what);
}
```

E aqui está um exemplo de como usar a anotação `@Todo`:

<?code-excerpt "misc/lib/language_tour/metadata/misc.dart (usage)"?>
```dart highlightLines=1
@Todo('Dash', 'Implement this function')
void doSomething() {
  print('Do something');
}
```

### Especificando alvos suportados {:.no_toc}

Para indicar o tipo de construções de linguagem que
devem ser anotadas com sua anotação,
use a anotação [`@Target`][] do [`package:meta`][].

Por exemplo, se você quisesse que a anotação `@Todo` anterior
só fosse permitida em funções e métodos,
você adicionaria a seguinte anotação:

<?code-excerpt "misc/lib/language_tour/metadata/todo.dart (target-kinds)"?>
```dart highlightLines=3
import 'package:meta/meta_meta.dart';

@Target({TargetKind.function, TargetKind.method})
class Todo {
  // ···
}
```

Com esta configuração, o analisador avisará se `Todo` for usado como
uma anotação em qualquer declaração além de uma função ou método de nível superior.

[`@Target`]: {{site.pub-api}}/meta/latest/meta_meta/Target-class.html
[`package:meta`]: {{site.pub-pkg}}/meta
