---
title: Migrar para package:web
description: Como migrar código de interop web de dart:html para package:web.
ia-translate: true
prevpage:
  url: /interop/js-interop/past-js-interop
  title: JS interop anterior
---

O [`package:web`][] do Dart expõe acesso às APIs do browser,
habilitando interop entre aplicações Dart e a web.
Use `package:web` para interagir com o browser e
manipular objetos e elementos no DOM.

```dart
import 'package:web/web.dart';

void main() {
  final div = document.querySelector('div')!;
  div.text = 'Text set at ${DateTime.now()}';
}
```

:::important
Se você mantém um pacote Flutter público que usa `dart:html` ou qualquer uma das
outras bibliotecas web do SDK Dart,
**você deve migrar para `package:web` o mais rápido possível**.
`package:web` está substituindo `dart:html` e outras bibliotecas web
como a solução de interop web do Dart a longo prazo.
Leia a seção **`package:web` vs `dart:html`** para mais informações.
:::

## `package:web` vs `dart:html`

O objetivo do `package:web` é reformular como o Dart expõe as APIs web
ao abordar várias preocupações com as bibliotecas web Dart existentes:

1. **Compatibilidade com Wasm**

   Pacotes só podem ser compatíveis com [Wasm][]
   se eles usarem [`dart:js_interop`][] e [`dart:js_interop_unsafe`][].
   `package:web` é baseado em `dart:js_interop`,
   então por padrão, é suportado em `dart2wasm`.

   Bibliotecas web principais do Dart, como [`dart:html`][html] e [`dart:svg`][svg],
   estão depreciadas e **não são suportadas** ao compilar para Wasm.

2. **Manter-se moderno**

   `package:web` usa o [Web IDL][idl] para gerar automaticamente
   [membros interop][interop members] e [tipos interop][interop types]
   para cada declaração no IDL.
   Gerar referências diretamente,
   em oposição aos membros e abstrações adicionais em `dart:html`,
   permite que `package:web` seja mais conciso, mais fácil de entender, mais consistente
   e mais capaz de se manter atualizado com o futuro dos desenvolvimentos Web.

3. **Versionamento**

   Por ser um pacote, `package:web` pode ser versionado
   mais facilmente do que uma biblioteca como `dart:html` e evitar quebrar o código do usuário à medida que
   evolui.
   Também torna o código menos exclusivo e mais aberto a contribuições.
   Desenvolvedores podem criar [declarações interop alternativas][alternative interop declarations] próprias
   e usá-las junto com `package:web` sem conflito.

---

Essas melhorias naturalmente resultam em algumas
diferenças de implementação entre `package:web` e `dart:html`.
As mudanças que afetam os pacotes existentes mais,
como [renomeações][renames] IDL e
[testes de tipo][type tests],
são abordadas nas seções de migração a seguir. Embora nos refiramos apenas a
`dart:html` por brevidade, os mesmos padrões de migração se aplicam a qualquer outra biblioteca
web principal do Dart como `dart:svg`.

## Migrando de `dart:html`

Remova o import de `dart:html` e substitua por `package:web/web.dart`:

```dart
import 'dart:html' as html; // Remove
import 'package:web/web.dart' as web; // Add
```

Adicione `web` às `dependencies` no seu pubspec:

```console
dart pub add web
```

As seções a seguir cobrem alguns dos problemas comuns de migração
de `dart:html` para `package:web`.

Para quaisquer outros problemas de migração, confira o repositório [dart-lang/web][] e
registre uma issue.

### Renomeações

Muitos dos símbolos em `dart:html` foram renomeados de
sua declaração IDL original para se alinhar mais com o estilo Dart.
Por exemplo, `appendChild` se tornou `append`,
`HTMLElement` se tornou `HtmlElement`, etc.

Em contraste, para reduzir confusão,
`package:web` usa os nomes originais das definições IDL.
Um `dart fix` está disponível para converter tipos que foram renomeados
entre `dart:html` e `package:web`.

Após alterar o import, quaisquer objetos renomeados serão novos erros "undefined".
Você pode resolver esses erros de uma das seguintes formas:
- A partir da CLI, executando `dart fix --dry-run`.
- No seu IDE, selecionando o `dart fix`: **Rename to '`package:web name`'**.

{% comment %}
TODO: Update this documentation to refer to symbols instead of just types once
we have a dart fix for that.
{% endcomment -%}

O `dart fix` cobre muitas das renomeações de tipo comuns.
Se você encontrar um tipo `dart:html` sem um `dart fix` para renomeá-lo,
primeiro nos avise registrando uma [issue][].

Então, você pode tentar descobrir manualmente o nome do tipo `package:web` de um
membro `dart:html` existente consultando sua definição.
O valor da anotação `@Native` na definição de um membro `dart:html`
informa ao compilador para tratar qualquer objeto JS daquele tipo como a classe Dart
que ela anota. Por exemplo, a anotação `@Native` nos diz que o
nome JS nativo do membro `HtmlElement` de `dart:html` é `HTMLElement`,
então o nome `package:web` também será `HTMLElement`:

```dart
@Native("HTMLElement")
class HtmlElement extends Element implements NoncedElement { }
```

Para encontrar a definição `dart:html` de um membro indefinido em `package:web`,
tente um dos seguintes métodos:

- Ctrl ou command click no nome indefinido no IDE e escolha
  **Go to Definition**.
- Procure pelo nome na [documentação da API `dart:html`][html]
  e verifique sua página em *Annotations*.

De forma similar, você pode encontrar uma API `package:web` indefinida cujo
membro `dart:html` correspondente usa a palavra-chave `native` em sua definição.
Verifique se a definição usa a anotação `@JSName` para uma renomeação;
o valor da anotação informará o nome que o membro usa em
`package:web`:

```dart
@JSName('appendChild')
Node append(Node node) native;
```

`native` é uma palavra-chave interna que significa o mesmo que `external` neste
contexto.

### Testes de tipo

É comum para código que usa `dart:html` utilizar verificações em runtime como `is`.
Quando usado com um objeto `dart:html`, `is` e `as` verificam que o objeto é
o tipo JS dentro da anotação `@Native`.
Em contraste, todos os tipos `package:web` são reificados para [`JSObject`][]. Isso significa que um
teste de tipo em runtime resultará em comportamento diferente entre tipos `dart:html` e
`package:web`.

Para poder realizar testes de tipo, migre qualquer código `dart:html`
que usa testes de tipo `is` para usar [métodos interop][interop methods] como `instanceOfString`
ou o auxiliar [`isA`][] mais conveniente e tipado
(disponível a partir do Dart 3.4).
A seção [Compatibilidade, verificações de tipo e conversões][Compatibility, type checks, and casts]
da página de tipos JS cobre alternativas em detalhe.

```dart
obj is Window; // Remove
obj.instanceOfString('Window'); // Add
```

### Assinaturas de tipo

Muitas APIs em `dart:html` suportam vários tipos Dart em suas assinaturas de tipo.
Como `dart:js_interop` [restringe][restricts] os tipos que podem ser escritos, alguns dos
membros em `package:web` agora exigirão que você *converta* o valor antes de
chamar o membro.
Aprenda como usar métodos de conversão interop na seção [Conversões][Conversions]
da página de tipos JS.

```dart
window.addEventListener('click', callback); // Remove
window.addEventListener('click', callback.toJS); // Add
```

{% comment %}
TODO: Think of a better example. People will likely use the stream helpers
instead of `addEventListener`.
{% endcomment -%}

Geralmente, você pode identificar quais métodos precisam de uma conversão porque eles serão
sinalizados com alguma variação da exceção:

```plaintext
A value of type '...' can't be assigned to a variable of type 'JSFunction?'
```

### Imports condicionais

É comum para código usar um import condicional baseado em se `dart:html`
é suportado para diferenciar entre nativo e web:

```dart
export 'src/hw_none.dart'
    if (dart.library.io) 'src/hw_io.dart'
    if (dart.library.html) 'src/hw_html.dart';
```

No entanto, já que `dart:html` está depreciado e não é suportado ao
compilar para Wasm, a alternativa correta agora é
usar `dart.library.js_interop` para diferenciar entre nativo e web:

<?code-excerpt "create_libraries/lib/hw_mp.dart (export)"?>
```dart
export 'src/hw_none.dart' // Stub implementation
    if (dart.library.io) 'src/hw_io.dart' // dart:io implementation
    if (dart.library.js_interop) 'src/hw_web.dart'; // package:web implementation
```

### Dispatch virtual e mocking

Classes `dart:html` suportavam dispatch virtual, mas como JS interop usa
extension types, dispatch virtual [não é possível][not possible]. De forma similar, chamadas `dynamic`
com tipos `package:web` não funcionarão como esperado (ou, elas podem continuar a funcionar
apenas por acaso, mas pararão quando `dart:html` for removido), pois seus membros estão
disponíveis apenas estaticamente. Migre todo o código que depende de dispatch virtual para
evitar esse problema.

Um caso de uso de dispatch virtual é mocking. Se você tem uma classe de mock que
`implements` uma classe `dart:html`, ela não pode ser usada para implementar um tipo `package:web`.
Em vez disso, prefira fazer o mock do próprio objeto JS. Veja o [tutorial de mocking][mocking tutorial]
para mais informações.

### APIs não-`native`

Classes `dart:html` também podem conter APIs que têm uma
implementação não trivial. Esses membros podem ou não existir nos
[helpers](#helpers) do `package:web`. Se seu código depende dos detalhes dessa
implementação, você pode ser capaz de copiar o código necessário.
No entanto, se você acha que isso não é viável ou se esse código seria benéfico
para outros usuários também, considere registrar uma issue ou enviar um pull request para
[`package:web`][dart-lang/web] para suportar esse membro.

### Zones

Em `dart:html`, callbacks são automaticamente zoneados.
Este não é o caso em `package:web`. Não há binding automático de
callbacks na zone atual.

Se isso importa para sua aplicação, você ainda pode usar zones, mas terá que
[escrevê-las você mesmo][zones] vinculando o callback. Veja [#54507] para mais
detalhes.
Ainda não há uma API de conversão ou [helper](#helpers) disponível para
fazer isso automaticamente.

## Helpers

O núcleo de `package:web` contém membros interop `external`,
mas não fornece outras funcionalidades que `dart:html` fornecia por padrão.
Para mitigar essas diferenças, `package:web` contém [`helpers`][helpers]
para suporte adicional ao lidar com vários casos de uso
que não estão diretamente disponíveis através do interop principal.
A biblioteca helper contém vários membros para expor alguns recursos legados das
bibliotecas web Dart.

Por exemplo, o núcleo `package:web` tem suporte apenas para adicionar e remover
event listeners. Em vez disso, você pode usar [stream helpers][] que facilita
a assinatura de eventos com `Stream`s Dart sem escrever esse código você mesmo.

```dart
// Original dart:html version:
final htmlInput = InputElement();
await htmlInput.onBlur.first;

// Migrated package:web version:
final webInput = HTMLInputElement();
await webInput.onBlur.first;
```

Você pode encontrar todos os helpers e sua documentação no repositório em
[`package:web/helpers`][helpers]. Eles serão continuamente atualizados para ajudar usuários
na migração e tornar mais fácil o uso das APIs web.

## Exemplos

Aqui estão alguns exemplos de pacotes que foram migrados de `dart:html`
para `package:web`:

- [Atualizando `url_launcher` para `package:web`][Upgrading `url_launcher` to `package:web`]

{% comment %}
Do we have any other package migrations to show off here?
{% endcomment -%}

[renames]: #renomeações
[type tests]: #testes-de-tipo
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
[`isA`]: {{site.dart-api}}/dart-js_interop/JSAnyUtilityExtension/isA.html
[restricts]: /interop/js-interop/js-types#requirements-on-external-declarations-and-function-tojs
[#54507]: {{site.repo.dart.sdk}}/issues/54507
[mocking tutorial]: /interop/js-interop/mock
