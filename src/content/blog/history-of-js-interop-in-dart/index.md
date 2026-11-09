---
ia-translate: true
title: "A história da interop com JS no Dart"
description: "O suporte ao Wasm acaba de chegar ao Flutter beta atual, graças a um marco empolgante de interop com JavaScript alcançado no Dart 3.3. Para celebrar…"
publishDate: 2024-03-28
author: sigmundch
image: images/1dhBQqKXU46sGKjx36LNf0w.webp
category: deep-dive
layout: blog
---


### O suporte ao Wasm acaba de chegar ao Flutter beta atual, graças a um marco empolgante de interop com JavaScript alcançado no Dart 3.3. Para celebrar, vamos olhar para trás e revisitar a jornada de uma década de interoperabilidade entre Dart e JS. {:#support-for-wasm-just-landed-in-the-current-flutter-beta-thanks-to-an-exciting-javascript-interop-milestone-reached-in-dart-33-to-celebrate-were-taking-a-look-back-at-the-decade-long-journey-of-dart-and-js-interoperability}

<DashImage src="images/1dhBQqKXU46sGKjx36LNf0w.webp" alt="Dash, o mascote do Dart e do Flutter, caminhando por uma porta aberta com termos relacionados à interop com JavaScript." caption="Imagem gerada por IA com o Gemini" />


A interoperabilidade tem sido um foco central desde o início do Dart. Quando o Dart foi lançado pela primeira vez, em 2011, ele foi projetado para ser *embutível* e *multiplataforma*. Ele rodava em uma máquina virtual independente, era embutido em um navegador e compilado para JavaScript. Quando o Flutter surgiu, em 2015, também estávamos prontos para embuti-lo ali. Agora, estamos animados para [direcionar para runtimes WasmGC](https://docs.flutter.dev/platform-integration/web/wasm), também.

No começo, trabalhamos rapidamente para expor as capacidades de cada plataforma onde o Dart era embutido. Foi assim que surgiram as bibliotecas específicas de plataforma do nosso SDK: [`dart:io`](https://api.dart.dev/stable/dart-io/dart-io-library.html) expôs o sistema de arquivos na VM, [`dart:html`](https://api.dart.dev/stable/dart-html/dart-html-library.html) expôs as APIs do navegador na web, e assim por diante. Essas bibliotecas pareciam e funcionavam como bibliotecas Dart comuns, mas, por trás, escondiam primitivas nativas sofisticadas e de baixo nível para fazê-las funcionar. Essa foi a primeira forma de interop que inventamos. Era expressiva, mas restrita apenas às bibliotecas do SDK.

Na web, os desenvolvedores precisavam de acesso a mais do que as APIs do navegador. Então começamos a buscar formas de abrir a interoperabilidade para cobrir mais alvos. Como ponto de partida, introduzimos o [`dart:js`](https://codereview.chromium.org//15782009) em 2013 para permitir o acesso a bibliotecas JavaScript.

```javascript
// Short example JavaScript code to illustrate Dart/JS interop
window.myTopLevel = {
  field1: 0,
  method2() {
    return this.field1;
  }
}

// Access via `dart:js` (2013)
import 'dart:js' as js;

void main() {
  // This line has a typo! oops :(
  var object = js.context['myTopLevl'];
  object['field1'] = 1;
  // This call fails with a noSuchMethod because method2
  // returns an int, oops
  object.callMethod('method2', []).substr(1);
}
```


Já sabíamos, naquele momento, que o `dart:js` não era o modelo de programação que queríamos. Você precisava usar strings para acessar nomes do JavaScript: esqueça encontrar problemas em tempo de compilação, e nem pense em autocompletar! A implementação também era cara. Ela dependia muito de boxes e cópias profundas para a maioria das operações. Então continuamos [rascunhando](https://github.com/dart-archive/js-interop-deprecated) ideias em 2014 e 2015, até que a v0.6 do `package:js` foi lançada.

```dart
// Access via `package:js` (2015)
import 'package:js/js.dart';

// Magic annotations allow us to declare API signatures:
@JS()
class MyObject {
  external int get field1;
  external void set field1(int value);
  external String method2();
}

@JS()
external MyObject get myTopLevel;

void main() {
  // Access to code is less error prone: analyzer can check that
  // these symbols match a declaration, and we get code-completion too!
  var object = myTopLevel;
  object.field1 = 1;
  // But types are not checked, this unsoundly invokes substring on an int
  object.method2().substring(1);
}
```


Com o [`package:js`](https://pub.dev/documentation/js/latest/) finalmente tínhamos uma API aberta, eficiente e fácil de usar. Você podia espalhar algumas anotações em classes abstratas e, *voilà*, já tinha acesso às APIs do JavaScript. Tudo funcionava como mágica, até deixar de funcionar. Havia muita coisa que você não conseguia fazer com o `package:js`: acessar APIs do navegador diretamente, renomear membros, fazer conversões, anexar lógica do Dart e [mais](https://github.com/dart-lang/sdk/issues/35084). Para compensar, também lançamos o [`dart:js_util`](https://codereview.chromium.org/2150313003/), uma API de baixo nível leve e eficiente, semelhante ao `dart:js`, como alternativa. Todas as limitações do `package:js` nos incomodavam muito, mas nossas mãos estavam atadas. Precisávamos de mais da própria linguagem Dart para fazer melhor.

Naquela época, já estávamos trabalhando na maior mudança que já fizemos na linguagem: estávamos tornando o Dart [sound](https://dart.dev/language/type-system#what-is-soundness). Ironicamente, quando lançamos o novo sistema de tipos com o Dart 2.0, em 2018, a interoperabilidade ficou *pior*! Além daquelas limitações iniciais, a mágica que tornava o `package:js` especial tinha um lado sombrio: ele não conseguia verificar a validade dos tipos. Isso significava que nossa interoperabilidade era uma fonte de falta de solidez (unsoundness) em uma linguagem que, de resto, era sound.

Então, nossa jornada mudou para focar em melhorar tanto o Dart quanto a interop com JS como um esforço conjunto. Com princípios claros (ser idiomático, expressivo, composicional, preciso, acessível, pragmático, não mágico e completo), chegamos a um design ancorado em tipagem e despacho estático, que desafiava a própria linguagem Dart. O que veio depois foi uma evolução lado a lado.

* Em 2019, o Dart 2.7 adicionou métodos de extensão estáticos. Você podia anexar lógica personalizada do Dart a uma classe de interop com JS e converter valores, como um `Promise` do JS em um `Future` do Dart, sem usar wrappers.

* Em 2021, lançamos o `@staticInterop` com o `package:js` v0.6.4. Enfim, a interop com JS era expressiva o suficiente: você podia expor APIs do navegador que antes eram gerenciadas exclusivamente por bibliotecas do SDK, como o `dart:html`.

* Em 2023, quando removemos a null safety não sound do Dart 3.0, finalmente pudemos ver o progresso que tínhamos feito. Nossos designs e o trabalho com `@staticInterop` deixaram claro que estávamos prontos para resolver a lacuna de solidez que carregávamos havia tanto tempo.

Naquele ano, introduzimos a compilação para WasmGC e aproveitamos a interop com JS para rodar frameworks robustos, como o [Flutter web]({{site.flutter-blog}}/whats-next-for-flutter), nele. Isso originou o trabalho nos [JS Types](https://dart.dev/interop/js-interop/js-types) para definir claramente a fronteira entre Dart e JS no modelo de programação e encontrar uma forma consistente de trabalhar com JS tanto nos alvos de compilação Wasm quanto nos de JS. Também começamos o [experimento de linguagem extension types](https://dart.dev/language/extension-types), um recurso lançado no Dart 3.3 que preenche a lacuna entre a linguagem Dart e a interop com JS. Por anos, a interop com JS teve comportamentos, como o type erasure, que não combinavam com nada mais no Dart. Com extension types, a interop com JS finalmente pôde ser idiomática e receber o suporte que merece nas ferramentas de desenvolvimento do Dart.

Apesar das muitas mudanças e reviravoltas no caminho, uma coisa permaneceu constante durante toda a década: o engajamento ativo da nossa comunidade Dart. Membros da comunidade deram os primeiros passos testando e contribuindo com o `dart:js` e, depois, influenciaram o design do `package:js`. Eles escreveram ferramentas para cobrir lacunas de funcionalidades ([`package:js_wrapping`](https://github.com/a14n/dart-js-wrapping)) e experimentaram formas de aumentar a produtividade gerando APIs Dart automaticamente ([`package:js_facade_gen`](https://github.com/dart-archive/js_facade_gen), [`package:js_bindings`](https://pub.dev/packages/js_bindings), [`package:typings`](https://pub.dev/packages/typings)). Cada contribuição ajudou a tornar o design de interop do Dart melhor. A todos vocês, obrigado por tornar essa aventura tão empolgante!

Finalmente, chegamos a 2024. Lançamos o [`dart:js_interop`](https://dart.dev/interop/js-interop) no Dart 3.3, junto com o [`package:web`](https://dart.dev/interop/js-interop/package-web), as soluções mais recentes de interop com JS no Dart, que tornam possível compilar o [Flutter para Wasm](https://docs.flutter.dev/platform-integration/web/wasm).

```dart
// Access via `dart:js_interop` (2024)
import 'dart:js_interop';

// Declarations use extension types, which are very similar to package:js
// declarations. The main difference: they are statically dispatched.
extension type MyObject._(JSObject _) implements JSObject {
  external int get field1;
  external void set field1(int value);
  external String method2();
}

@JS()
external MyObject get myTopLevel;

void main() {
  var object = myTopLevel;
  object.field1 = 1;
  // At last, access is sound - this line fails with a type error
  // when returning from method2.
  object.method2().substring(1);
}
```


* `dart:js_interop` é uma forma de interop estática, sound, idiomática, expressiva e consistente, baseada em extension types, capaz de expor qualquer API do JavaScript ou do navegador.

* `package:web` usa o `dart:js_interop` para fazer o que o `dart:html` fazia há 13 anos, mas de um jeito que é suportado tanto em JavaScript quanto em WasmGC.

Hoje, estamos animados para celebrar uma nova forma de interop entre Dart e JS e o futuro que ela possibilita. Conhecendo nosso passado, temos certeza de que esta não é o fim da jornada, mas um ponto empolgante da nossa história.

Mal podemos esperar para ver o que você vai construir com ela!
