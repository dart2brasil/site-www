---
ia-translate: true
title: Migrar para package:web
description: Como migrar código de interop web de dart:html para package:web.
prevpage:
  url: /interop/js-interop/past-js-interop
  title: Interop JS anterior
---

O [`package:web`][] do Dart expõe acesso às APIs do navegador,
possibilitando a interop entre aplicações Dart e a web.
Use `package:web` para interagir com o navegador e
manipular objetos e elementos no DOM.

```dart
import 'package:web/web.dart';

void main() {
  final div = document.querySelector('div')!;
  div.textContent = 'Text set at ${DateTime.now()}';
}
```

:::important
Se você mantém um pacote Flutter público que usa `dart:html` ou qualquer uma das
outras bibliotecas web do SDK do Dart,
**migre para `package:web` o quanto antes**.
`package:web` está substituindo `dart:html` e outras bibliotecas web
como a solução de interop web do Dart a longo prazo.
Leia a seção **`package:web` vs `dart:html`** para mais informações.
:::

## `package:web` vs `dart:html` {:#packageweb-vs-darthtml}

O objetivo do `package:web` é reformular a forma como o Dart expõe as APIs web,
resolvendo várias questões das bibliotecas web atuais do Dart:

1. **Compatibilidade com Wasm**

   Pacotes só podem ser compatíveis com [Wasm][] se usarem [`dart:js_interop`][] e [`dart:js_interop_unsafe`][].
   O `package:web` é baseado em `dart:js_interop`,
   então, por padrão, ele tem suporte no `dart2wasm`.

   Bibliotecas web centrais do Dart, como [`dart:html`][html] e [`dart:svg`][svg],
   estão depreciadas e **não são suportadas** ao compilar para Wasm.

2. **Manter-se moderno**

   O `package:web` usa a [Web IDL][idl] para gerar automaticamente
   [membros de interop][interop members] e [tipos de interop][interop types]
   para cada declaração na IDL.
   Gerar referências diretamente,
   em vez de usar os membros e abstrações adicionais do `dart:html`,
   permite que o `package:web` seja mais conciso, mais fácil de entender, mais consistente
   e mais capaz de acompanhar a evolução do desenvolvimento web.

3. **Versionamento**

   Por ser um pacote, o `package:web` pode ser versionado
   com mais facilidade do que uma biblioteca como o `dart:html`, evitando quebrar o código dos usuários conforme
   evolui.
   Isso também torna o código menos exclusivo e mais aberto a contribuições.
   Desenvolvedores podem criar [declarações de interop alternativas][alternative interop declarations]
   próprias e usá-las junto com o `package:web` sem conflito.

---

Essas melhorias resultam naturalmente em algumas
diferenças de implementação entre `package:web` e `dart:html`.
As mudanças que mais afetam pacotes existentes,
como [renomeações](#renames) da IDL e
[testes de tipo](#type-tests),
são tratadas nas seções de migração a seguir. Embora nos refiramos apenas ao
`dart:html` por brevidade, os mesmos padrões de migração se aplicam a qualquer outra
biblioteca web central do Dart, como `dart:svg`.

## Migrando de `dart:html` {:#migrating-from-darthtml}

Remova o import de `dart:html` e substitua-o por `package:web/web.dart`:

```dart
import 'dart:html' as html; // Remove
import 'package:web/web.dart' as web; // Add
```

Adicione `web` às `dependencies` do seu pubspec:

```console
dart pub add web
```

As seções a seguir cobrem alguns dos problemas comuns de migração
de `dart:html` para `package:web`.

Para outros problemas de migração, consulte o repositório [dart-lang/web][] e
abra uma issue.

### Renomeações {:#renames}

Muitos dos símbolos em `dart:html` foram renomeados em relação
à sua declaração original na IDL, para se alinhar mais ao estilo do Dart.
Por exemplo, `appendChild` virou `append`,
`HTMLElement` virou `HtmlElement`, etc.

Em contraste, para reduzir a confusão,
o `package:web` usa os nomes originais das definições da IDL.
Um `dart fix` está disponível para converter tipos que foram renomeados
entre `dart:html` e `package:web`.

Depois de trocar o import, os objetos renomeados vão gerar novos erros de "undefined".
Você pode resolvê-los de duas formas:
- Pela CLI, executando `dart fix --dry-run`.
- Na sua IDE, selecionando o `dart fix`: **Rename to '`package:web name`'**.

{% comment %}
TODO: Update this documentation to refer to symbols instead of just types once
we have a dart fix for that.
{% endcomment -%}

O `dart fix` cobre muitas das renomeações de tipos comuns.
Se você encontrar um tipo de `dart:html` sem um `dart fix` para renomeá-lo,
primeiro nos avise abrindo uma [issue][].

Depois, você pode tentar descobrir manualmente o nome do tipo em `package:web` de um
membro existente de `dart:html` olhando sua definição.
O valor da anotação `@Native` na definição de um membro de `dart:html`
indica ao compilador para tratar qualquer objeto JS desse tipo como a classe Dart
que ela anota. Por exemplo, a anotação `@Native` nos diz que o nome nativo JS do membro
`HtmlElement` do `dart:html` é `HTMLElement`, então o nome em `package:web` também será `HTMLElement`:

```dart
@Native("HTMLElement")
class HtmlElement extends Element implements NoncedElement { }
```

Para encontrar a definição em `dart:html` de um membro indefinido no `package:web`,
tente um dos métodos a seguir:

- Pressione Ctrl ou Command e clique no nome indefinido na IDE e escolha
  **Go to Definition**.
- Pesquise o nome na [documentação da API de `dart:html`][html]
  e verifique a página dele na seção *Annotations*.

De forma semelhante, você pode encontrar uma API indefinida no `package:web` cujo membro
correspondente em `dart:html` usa a palavra-chave `native` na definição.
Verifique se a definição usa a anotação `@JSName` para uma renomeação;
o valor da anotação indicará o nome que o membro usa no
`package:web`:

```dart
@JSName('appendChild')
Node append(Node node) native;
```

`native` é uma palavra-chave interna que significa o mesmo que `external` neste
contexto.

### `Element` e `HTMLElement` {:#element-and-htmlelement}

`Element` agora é `HTMLElement`, mas o extension type `Element` também existe como
um tipo base para `HTMLElement`, `SVGElement`, etc.
Veja a [documentação de Element no MDN][Element MDN documentation].
`querySelector` retorna um Element, pois ele pode retornar outros subtipos de `Element`
além de `HTMLElement`, como `SVGElement`. É preciso fazer um downcast para `HTMLElement`
se você precisar acessar os métodos dele.

```dart
element.querySelector('#selectme')!.className = 'test'; // valid in both

element.querySelector('#selectme')!.style.color = 'red'; // Remove
(element.querySelector('#selectme') as HTMLElement).style.color = 'red'; // Add
```

### Operações com listas {:#list-operations}

Diferente do `dart:html`, métodos do `package:web` como `Element.querySelectorAll` e
`Element.children` retornam valores que não implementam `List`. Se for necessário
uma `List`, você precisará envolvê-la com uma classe.

Para operações imutáveis, você pode usar `JSImmutableListWrapper`:

```dart
final anchors = document.querySelectorAll('a');
for (final anchor in anchors) {} // Remove
for (final anchor in JSImmutableListWrapper(anchors)) {} //Add

for (final child in parent.children) {} // Remove
for (final child in JSImmutableListWrapper(parent.children)) {} // Add
```

Você precisa implementar operações mutáveis simples, como `removeWhere`:

```dart
parent.children.removeWhere(test); // Remove

for (var i = parent.children.length - 1; i >= 0; --i) {
  if (test(parent.children.item(i)!)) {
    parent.children.item(i)!.remove();
  }
}  // Add

```

### Exemplos comuns de manipulação do DOM {:#common-dom-manipulation-examples}

Aqui estão alguns exemplos comuns de mudanças triviais que precisam ser feitas
ao migrar de `dart:html` para `package:web`:

```dart
element.querySelector('#selector')?.innerHtml = 'something'; // Remove
element.querySelector('#selector')?.innerHTML = 'something'.toJS; // Add

element.parent.classes.add('class'); // Remove
element.parentElement.classList.add('class'); // Add

element.appendHtml(html); // Remove
element.insertAdjacentHTML('beforeend', html.toJS); // Add

var checkbox = CheckboxInputElement(); // Remove
var checkbox = HTMLInputElement()..type='checkbox'; // Add

element.text = 'Hello'; // Remove
element.textContent = 'Hello'; // Add

element.querySelectorAll('a').classes.add('link'); // Remove
for (final a in JSImmutableListWrapper(element.querySelectorAll('a'))) {
  a.classList.add('a');
} // Add
```

### Testes de tipo {:#type-tests}

É comum que código que usa `dart:html` utilize verificações em tempo de execução, como `is`.
Quando usados com um objeto de `dart:html`, `is` e `as` verificam se o objeto é
o tipo JS dentro da anotação `@Native`.
Em contraste, todos os tipos de `package:web` são reificados para [`JSObject`][]. Isso significa que um
teste de tipo em tempo de execução terá comportamento diferente entre tipos de `dart:html` e
de `package:web`.

Para conseguir fazer testes de tipo, migre qualquer código de `dart:html` que usa testes de tipo com `is`
para usar [métodos de interop][interop methods], como `instanceOfString`,
ou o helper [`isA`][] mais conveniente e tipado.
A seção [Compatibilidade, verificações de tipo e casts][Compatibility, type checks, and casts]
da página de tipos JS cobre as alternativas em detalhes.

```dart
obj is Window; // Remove
obj.instanceOfString('Window'); // Add

element is InputElement; // Remove
element.isA<HTMLInputElement>(); // Add
```

Para detectar verificações de tipo e casts inválidos com tipos de interop JS,
habilite a regra de lint [`invalid_runtime_check_with_js_interop_types`][].
A partir do [`package:lints`][] 7.0.0,
`package:lints/core.yaml` inclui essa regra.

### Assinaturas de tipo {:#type-signatures}

Muitas APIs em `dart:html` aceitam vários tipos do Dart em suas assinaturas de tipo.
Como o `dart:js_interop` [restringe][restricts] os tipos que podem ser escritos, alguns
dos membros do `package:web` agora exigirão que você *converta* o valor antes
de chamar o membro.
Aprenda a usar os métodos de conversão de interop na seção [Conversões][Conversions]
da página de tipos JS.

Por exemplo, ao passar callbacks para `addEventListener`,
converta a função Dart em uma `JSFunction` usando `.toJS`:

```dart
window.addEventListener('click', callback); // Remove
window.addEventListener('click', callback.toJS); // Add
// where callback's first parameter accepts Event.
```

:::note
Chamar `.toJS` cria uma nova `JSFunction` a cada vez.
Para remover o listener depois com `removeEventListener`,
armazene a `JSFunction` convertida em uma variável e passe
essa mesma instância para os dois métodos:

```dart
final jsCallback = callback.toJS;
window.addEventListener('click', jsCallback);
// ...
window.removeEventListener('click', jsCallback);
```
:::

Se você preferir assinar eventos do DOM usando `Stream`s do Dart
em vez de `addEventListener`, pode usar as extensions helper de stream
do `package:web`:

```dart
// Using the stream helper extension (same API shape as dart:html):
button.onClick.listen((event) {
  // event is already typed as MouseEvent without needing a cast:
  print('Clicked at (${event.clientX}, ${event.clientY})');
});

// Or using EventStreamProviders directly:
EventStreamProviders.clickEvent.forTarget(button).listen((event) {
  print('Clicked at (${event.clientX}, ${event.clientY})');
});
```

De modo geral, você consegue identificar quais métodos precisam de conversão porque eles
serão sinalizados com alguma variação da exceção:

```plaintext
A value of type '...' can't be assigned to a variable of type 'JSFunction?'
```

### Imports condicionais {:#conditional-imports}

É comum que o código use um import condicional baseado em o `dart:html`
ser suportado para diferenciar entre nativo e web:

```dart
export 'src/hw_none.dart'
    if (dart.library.io) 'src/hw_io.dart'
    if (dart.library.html) 'src/hw_html.dart';
```

No entanto, como `dart:html` está depreciado e não é suportado ao
compilar para Wasm, a alternativa correta agora é
usar `dart.library.js_interop` para diferenciar entre nativo e web:

<?code-excerpt "create_libraries/lib/hw_mp.dart (export)"?>
```dart
export 'src/hw_none.dart' // Stub implementation
    if (dart.library.io) 'src/hw_io.dart' // dart:io implementation
    if (dart.library.js_interop) 'src/hw_web.dart'; // package:web implementation
```

:::version-note
A partir do Dart 3.14, você pode passar a flag `--no-deprecated-js-interop`
ao compilar para JavaScript.
Essa flag faz com que `dart.library.html` e as outras condições de bibliotecas web legadas
sejam avaliadas como `false`
e proíbe o import de bibliotecas web depreciadas.
Para detalhes, consulte
[Desabilitar bibliotecas de interop JS depreciadas][disallow-legacy].
:::

### Dispatch virtual e mocking {:#virtual-dispatch-and-mocking}

As classes de `dart:html` suportavam dispatch virtual, mas, como a interop JS usa
extension types, o dispatch virtual [não é possível][not possible]. De modo semelhante, chamadas `dynamic`
com tipos de `package:web` não funcionarão como esperado (ou podem continuar funcionando
por acaso, mas vão parar quando `dart:html` for removido), pois os membros deles
estão disponíveis apenas estaticamente. Migre todo o código que depende de dispatch virtual para
evitar esse problema.

Um caso de uso do dispatch virtual é o mocking. Se você tem uma classe de mock que
faz `implements` de uma classe de `dart:html`, ela não pode ser usada para implementar um tipo
de `package:web`. Em vez disso, prefira fazer o mock do próprio objeto JS. Veja o [tutorial de mocking][mocking tutorial]
para mais informações.

### APIs não-`native` {:#non-native-apis}

As classes de `dart:html` também podem conter APIs com uma implementação não trivial.
Esses membros podem ou não existir nos [helpers](#helpers) do `package:web`. Se o seu código
depende dos detalhes dessa implementação, talvez você consiga copiar o código necessário.
No entanto, se achar que isso não é viável ou se esse código for útil também para
outros usuários, considere abrir uma issue ou enviar um pull request para
o [`package:web`][dart-lang/web] para dar suporte a esse membro.

### Zones {:#zones}

Em `dart:html`, os callbacks são automaticamente associados à zone.
Isso não acontece no `package:web`. Não há vinculação automática de
callbacks à zone atual.

Se isso for importante para sua aplicação, você ainda pode usar zones, mas terá
que [escrevê-las você mesmo][zones] vinculando o callback. Veja [#54507] para
mais detalhes.

Por exemplo, ao passar um callback para um listener de evento do DOM,
vincule-o manualmente à zone atual antes de convertê-lo com `.toJS`:

<?code-excerpt "misc/lib/interop/zones_example.dart (before)"?>
```dart
// Before: Callback lost zone context
element.addEventListener(
  'click',
  (web.Event event) {
    // ... relies on zone-local values
  }.toJS,
);
```

<?code-excerpt "misc/lib/interop/zones_example.dart (after)"?>
```dart
element.addEventListener(
  'click',
  Zone.current.bindUnaryCallback((web.Event event) {
    // ... zone-local values are preserved
  }).toJS,
);
```

Ainda não há uma API de conversão nem um [helper](#helpers) disponível para
fazer isso automaticamente.

## Helpers {:#helpers}

O núcleo do `package:web` contém membros de interop `external`,
mas não fornece outras funcionalidades que o `dart:html` oferecia por padrão.
Para amenizar essas diferenças, o `package:web` contém [`helpers`][helpers]
com suporte adicional para vários casos de uso
que não estão disponíveis diretamente pela interop central.
A biblioteca de helpers contém vários membros que expõem algumas funcionalidades legadas
das bibliotecas web do Dart.

Por exemplo, o `package:web` central só tem suporte para adicionar e remover
event listeners. Em vez disso, você pode usar [helpers de stream][stream helpers], que facilitam
assinar eventos com `Stream`s do Dart sem escrever esse código você mesmo.

```dart
// Original dart:html version:
final htmlInput = InputElement();
await htmlInput.onBlur.first;

// Migrated package:web version:
final webInput = HTMLInputElement();
await webInput.onBlur.first;
```

Você pode encontrar todos os helpers e a documentação deles no repositório, em
[`package:web/helpers`][helpers]. Eles serão atualizados continuamente para ajudar
os usuários na migração e facilitar o uso das APIs web.

## Exemplos {:#examples}

Aqui estão alguns exemplos de pacotes que foram migrados de `dart:html`
para `package:web`:

- [Atualizando `url_launcher` para `package:web`][Upgrading `url_launcher` to `package:web`]

{% comment %}
Do we have any other package migrations to show off here?
{% endcomment -%}

[`package:web`]: {{site.pub-pkg}}/web
[Wasm]: /web/wasm
[html]: {{site.dart-api}}/dart-html/dart-html-library.html
[svg]: {{site.dart-api}}/dart-svg/dart-svg-library.html
[`dart:js_interop`]: {{site.dart-api}}/dart-js_interop/dart-js_interop-library.html
[`dart:js_interop_unsafe`]: {{site.dart-api}}/dart-js_interop_unsafe/dart-js_interop_unsafe-library.html
[idl]: https://www.npmjs.com/package/@webref/idl
[interop members]: /interop/js-interop/usage#interop-members
[interop types]: /interop/js-interop/usage#interop-types
[dart-lang/web]: {{site.repo.dart.org}}/web
[issue]: {{site.repo.dart.org}}/web/issues/new
[helpers]: {{site.repo.dart.org}}/web/tree/main/web/lib/src/helpers
[zones]: /libraries/async/zones
[Conversions]: /interop/js-interop/js-types#conversions
[interop methods]: {{site.dart-api}}/dart-js_interop/JSAnyUtilityExtension.html#instance-methods
[alternative interop declarations]: /interop/js-interop/usage
[Compatibility, type checks, and casts]: /interop/js-interop/js-types#compatibility-type-checks-and-casts
[Upgrading `url_launcher` to `package:web`]: https://github.com/flutter/packages/pull/5451/files
[stream helpers]: {{site.repo.dart.org}}/web/blob/main/web/lib/src/helpers/events/streams.dart
[not possible]: /language/extension-types
[`JSObject`]: {{site.dart-api}}/dart-js_interop/JSObject-extension-type.html
[`isA`]: {{site.dart-api}}/dart-js_interop/NullableObjectUtilExtension/isA.html
[restricts]: /interop/js-interop/js-types#requirements-on-external-declarations-and-function-tojs
[#54507]: {{site.repo.dart.sdk}}/issues/54507
[mocking tutorial]: /interop/js-interop/mock
[Element MDN documentation]: https://developer.mozilla.org/en-US/docs/Web/API/Element
[`invalid_runtime_check_with_js_interop_types`]: /tools/linter-rules/invalid_runtime_check_with_js_interop_types
[`package:lints`]: {{site.pub-pkg}}/lints
[disallow-legacy]: /interop/js-interop/past-js-interop#disallow-deprecated-js-interop
