---
ia-translate: true
title: Migrar para package:web
description: Como migrar código de interop da web de dart:html para package:web.
---

O [`package:web`][`package:web`] do Dart expõe acesso às APIs do navegador,
permitindo a interoperabilidade entre aplicativos Dart e a web.
Use `package:web` para interagir com o navegador e
manipular objetos e elementos no DOM.

```dart
import 'package:web/web.dart';

void main() {
  final div = document.querySelector('div')!;
  div.text = 'Texto definido em ${DateTime.now()}';
}
```

:::important
Se você mantém um pacote Flutter público que usa `dart:html` ou
qualquer outra das bibliotecas web do SDK Dart,
**você deve migrar para `package:web` o mais rápido possível**.
`package:web` está substituindo `dart:html` e outras bibliotecas web
como a solução de interop da web do Dart a longo prazo.
Leia a seção **`package:web` vs `dart:html`** para mais informações.
:::

## `package:web` vs `dart:html`

O objetivo de `package:web` é reformular como o Dart expõe as APIs da web
abordando diversas preocupações com as bibliotecas web Dart existentes:

1. **Compatibilidade com Wasm**

   Pacotes só podem ser compatíveis com [Wasm][Wasm]
   se eles usarem [`dart:js_interop`][`dart:js_interop`] e [`dart:js_interop_unsafe`][`dart:js_interop_unsafe`].
   `package:web` é baseado em `dart:js_interop`,
   portanto, por padrão, ele é suportado em `dart2wasm`.

   Bibliotecas web centrais do Dart, como [`dart:html`][html] e [`dart:svg`][svg],
   **não são suportadas** ao compilar para Wasm.

2. **Manter-se moderno**

   `package:web` usa o [Web IDL][idl] para gerar automaticamente
   [membros de interop][interop members] e [tipos de interop][interop types]
   para cada declaração no IDL.
   Gerando referências diretamente,
   em vez dos membros e abstrações adicionais em `dart:html`,
   permite que `package:web` seja mais conciso, mais fácil de entender, mais consistente,
   e mais capaz de se manter atualizado com o futuro dos desenvolvimentos da Web.

3. **Versionamento**

   Por ser um pacote, `package:web` pode ser versionado
   mais facilmente do que uma biblioteca como `dart:html` e evitar quebrar o código do usuário conforme ele evolui.
   Também torna o código menos exclusivo e mais aberto a contribuições.
   Desenvolvedores podem criar [declarações de interop alternativas][alternative interop declarations] próprias
   e usá-las junto com `package:web` sem conflito.

---

Essas melhorias naturalmente resultam em algumas
diferenças de implementação entre `package:web` e `dart:html`.
As mudanças que mais afetam os pacotes existentes,
como [renomeações](#renames) do IDL e
[testes de tipo](#type-tests),
são abordadas nas seções de migração a seguir. Embora nos refiramos apenas a
`dart:html` por brevidade, os mesmos padrões de migração se aplicam a qualquer outra biblioteca
web principal do Dart, como `dart:svg`.

## Migrando de `dart:html`

Remova a importação `dart:html` e substitua por `package:web/web.dart`:

```dart
import 'dart:html' as html; // Remover
import 'package:web/web.dart' as web; // Adicionar
```

Adicione `web` às `dependencies` no seu pubspec:

```console
dart pub add web
```

As seções a seguir cobrem alguns dos problemas comuns de migração
de `dart:html` para `package:web`.

Para quaisquer outros problemas de migração, verifique o repositório
[dart-lang/web][dart-lang/web] e registre um problema.

### Renomeações

Muitos dos símbolos em `dart:html` foram renomeados de
sua declaração IDL original para se alinhar mais com o estilo Dart.
Por exemplo, `appendChild` tornou-se `append`,
`HTMLElement` tornou-se `HtmlElement`, etc.

Em contraste, para reduzir a confusão,
`package:web` usa os nomes originais das definições IDL.
Um `dart fix` está disponível para converter tipos que foram renomeados
entre `dart:html` e `package:web`.

Depois de alterar a importação, quaisquer objetos renomeados serão novos erros "indefinidos".
Você pode resolver isso de uma das seguintes maneiras:
- A partir da CLI, executando `dart fix --dry-run`.
- Em sua IDE, selecionando o `dart fix`: **Renomear para '`nome package:web`'**.

{% comment %}
TODO: Atualize esta documentação para se referir a símbolos em vez de apenas tipos assim que
tivermos uma correção dart para isso.
{% endcomment %}

O `dart fix` cobre muitas das renomeações de tipo comuns.
Se você encontrar um tipo `dart:html` sem um `dart fix` para renomeá-lo,
primeiro nos informe registrando um [problema][issue].

Então, você pode tentar descobrir manualmente o nome do tipo `package:web` de um
membro `dart:html` existente procurando sua definição.
O valor da anotação `@Native` em uma definição de membro `dart:html`
diz ao compilador para tratar qualquer objeto JS desse tipo como a classe Dart
que ele anota. Por exemplo, a anotação `@Native` nos diz que o
nome JS nativo do membro `HtmlElement` de `dart:html` é `HTMLElement`,
então o nome `package:web` também será `HTMLElement`:

```dart
@Native("HTMLElement")
class HtmlElement extends Element implements NoncedElement { }
```

Para encontrar a definição `dart:html` para um membro indefinido em `package:web`,
tente um dos seguintes métodos:

- Ctrl ou comando clique no nome indefinido na IDE e escolha
  **Ir para Definição**.
- Pesquise o nome na [documentação da API `dart:html`][html]
  e verifique sua página em *Anotações*.

Da mesma forma, você pode encontrar uma API `package:web` indefinida cuja correspondente
a definição do membro `dart:html` usa a palavra-chave `native`.
Verifique se a definição usa a anotação `@JSName` para uma renomeação;
o valor da anotação lhe dirá o nome que o membro usa em
`package:web`:

```dart
@JSName('appendChild')
Node append(Node node) native;
```

`native` é uma palavra-chave interna que significa o mesmo que `external` neste
contexto.

### Testes de tipo

É comum que o código que usa `dart:html` utilize verificações de tempo de execução como `is`.
Quando usado com um objeto `dart:html`, `is` e `as` verificam se o objeto é
o tipo JS dentro da anotação `@Native`.
Em contraste, todos os tipos `package:web` são reificados para [`JSObject`][`JSObject`].
Isso significa que um teste de tipo em tempo de execução resultará em um comportamento diferente entre os tipos `dart:html` e `package:web`.

Para poder realizar testes de tipo, migre qualquer código `dart:html`
usando testes de tipo `is` para usar [métodos de interop][interop methods] como `instanceOfString`
ou o auxiliar [`isA`][`isA`] mais conveniente e tipado
(disponível a partir do Dart 3.4 em diante).
A seção [Compatibilidade, verificações de tipo e casts][Compatibility, type checks, and casts]
da página de tipos JS cobre alternativas em detalhes.

```dart
obj is Window; // Remover
obj.instanceOfString('Window'); // Adicionar
```

### Assinaturas de tipo

Muitas APIs em `dart:html` suportam vários tipos Dart em suas assinaturas de tipo.
Como `dart:js_interop` [restringe] os tipos que podem ser escritos, alguns dos
membros em `package:web` agora exigirão que você *converta* o valor antes de
chamar o membro.
Aprenda a usar os métodos de conversão de interop na seção [Conversões][Conversions]
da página de tipos JS.

```dart
window.addEventListener('click', callback); // Remover
window.addEventListener('click', callback.toJS); // Adicionar
```

{% comment %}
TODO: Pense em um exemplo melhor. As pessoas provavelmente usarão os auxiliares de fluxo
em vez de `addEventListener`.
{% endcomment %}

Geralmente, você pode identificar quais métodos precisam de uma conversão porque eles serão
sinalizados com alguma variação da exceção:

```plaintext
Um valor do tipo '...' não pode ser atribuído a uma variável do tipo 'JSFunction?'
```

### Importações condicionais

É comum que o código use uma importação condicional com base em se `dart:html`
é suportado para diferenciar entre nativo e web:

```dart
export 'src/hw_none.dart'
    if (dart.library.io) 'src/hw_io.dart'
    if (dart.library.html) 'src/hw_html.dart';
```

No entanto, como `dart:html` não é suportado ao compilar para Wasm, o correto
alternativa agora é usar `dart.library.js_interop` para diferenciar entre
nativo e web:

```dart
export 'src/hw_none.dart'
    if (dart.library.io) 'src/hw_io.dart'
    if (dart.library.js_interop) 'src/hw_web.dart';
```

### Despacho virtual e mocking

As classes `dart:html` suportavam o despacho virtual, mas como o JS interop usa
tipos de extensão, o despacho virtual [não é possível]. Da mesma forma, chamadas `dynamic`
com tipos `package:web` não funcionarão como esperado (ou podem continuar a funcionar
apenas por acaso, mas pararão quando `dart:html` for removido), pois seus membros estão
disponíveis apenas estaticamente. Migre todo o código que depende do despacho virtual para
evitar esse problema.

Um caso de uso de despacho virtual é o mocking. Se você tem uma classe de mocking que
`implements` uma classe `dart:html`, ela não pode ser usada para implementar um tipo `package:web`.
Em vez disso, prefira fazer o mocking do próprio objeto JS. Consulte o [tutorial de mocking]
para obter mais informações.

### APIs não-`native`

As classes `dart:html` também podem conter APIs que têm uma implementação não trivial.
Esses membros podem ou não existir nos
[auxiliares](#helpers) do `package:web`. Se seu código depende dos detalhes dessa
implementação, você pode conseguir copiar o código necessário.
No entanto, se você acha que isso não é viável ou se esse código seria benéfico
para outros usuários também, considere registrar um problema ou enviar um pull request para
[`package:web`][dart-lang/web] para dar suporte a esse membro.

### Zonas

Em `dart:html`, os callbacks são automaticamente zonificados.
Este não é o caso em `package:web`. Não há vinculação automática de
callbacks na zona atual.

Se isso for importante para sua aplicação, você ainda pode usar zonas, mas terá que
[escrevê-las você mesmo][zones] vinculando o callback. Veja [#54507] para mais
detalhes.
Ainda não há uma API de conversão ou um [auxiliar](#helpers) disponível para
fazer isso automaticamente.

## Auxiliares

O núcleo de `package:web` contém membros de interop `external`,
mas não fornece outras funcionalidades que `dart:html` fornecia por padrão.
Para mitigar essas diferenças, `package:web` contém [`helpers`][helpers]
para suporte adicional no tratamento de uma série de casos de uso
que não estão diretamente disponíveis através do interop principal.
A biblioteca de auxiliares contém vários membros para expor alguns recursos legados de
as bibliotecas web do Dart.

Por exemplo, o `package:web` principal só tem suporte para adicionar e remover
listeners de eventos. Em vez disso, você pode usar [auxiliares de fluxo][stream helpers] que facilitam a
assinatura de eventos com `Stream`s do Dart sem escrever esse código você mesmo.

```dart
// versão dart:html
InputElement htmlInput = InputElement();
await htmlInput.onBlur.first;

// versão package:web
HTMLInputElement webInput = document.createElement('input') as HTMLInputElement;
await webInput.onBlur.first;
```

Você pode encontrar todos os auxiliares e sua documentação no repositório em
[`package:web/helpers`][helpers]. Eles serão continuamente atualizados para ajudar os usuários
na migração e facilitar o uso das APIs da web.

## Exemplos

Aqui estão alguns exemplos de pacotes que foram migrados de `dart:html`
para `package:web`:

- [Atualizando `url_launcher` para `package:web`][Upgrading `url_launcher` to `package:web`]

{% comment %}
Temos outras migrações de pacotes para mostrar aqui?
{% endcomment %}

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
