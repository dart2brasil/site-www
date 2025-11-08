---
ia-translate: true
title: Migrar para `package:web`
description: Como migrar código de interoperabilidade web de dart:html para package:web.
prevpage:
  url: /interop/js-interop/past-js-interop
  title: Past JS interop
---

O pacote [`package:web`][] do Dart expõe acesso às APIs do navegador,
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
Se você mantém um pacote Flutter público que usa `dart:html` ou qualquer uma das
outras bibliotecas web do SDK Dart,
**você deve migrar para `package:web` o mais rápido possível**.
`package:web` está substituindo `dart:html` e outras bibliotecas web
como a solução de interoperabilidade web do Dart a longo prazo.
Leia a seção **`package:web` vs `dart:html`** para mais informações.
:::

## `package:web` vs `dart:html` {:#package-web-vs-dart-html}

O objetivo do `package:web` é reformular como o Dart expõe as APIs web
abordando várias preocupações com as bibliotecas web Dart existentes:

1. **Compatibilidade com Wasm**

   Pacotes só podem ser compatíveis com [Wasm][]
   se usarem [`dart:js_interop`][] e [`dart:js_interop_unsafe`][].
   `package:web` é baseado em `dart:js_interop`,
   portanto, por padrão, ele é suportado em `dart2wasm`.

   As bibliotecas web principais do Dart, como [`dart:html`][html] e [`dart:svg`][svg],
   estão obsoletas e **não são suportadas** ao compilar para Wasm.

2. **Permanecer moderno**

   `package:web` usa o [Web IDL][idl] para gerar automaticamente
   [membros de interoperabilidade][] e [tipos de interoperabilidade][]
   para cada declaração no IDL.
   Gerar referências diretamente,
   ao contrário dos membros e abstrações adicionais em `dart:html`,
   permite que `package:web` seja mais conciso, mais fácil de entender, mais consistente
   e mais capaz de se manter atualizado com o futuro dos desenvolvimentos Web.

3. **Controle de versão**

   Por ser um pacote, `package:web` pode ser versionado
   mais facilmente do que uma biblioteca como `dart:html` e evitar quebras no código do usuário à medida que
   evolui.
   Também torna o código menos exclusivo e mais aberto a contribuições.
   Desenvolvedores podem criar [declarações de interoperabilidade alternativas][] próprias
   e usá-las junto com `package:web` sem conflitos.

---

Essas melhorias resultam naturalmente em algumas
diferenças de implementação entre `package:web` e `dart:html`.
As alterações que mais afetam os pacotes existentes,
como renomeações de IDL [renomeações](#renames) e
[testes de tipo](#testes-de-tipo),
são abordadas nas seções de migração a seguir. Embora nos refiramos apenas a
`dart:html` por brevidade, os mesmos padrões de migração se aplicam a qualquer outra biblioteca web principal do Dart, como `dart:svg`.

## Migrando de `dart:html` {:#migrando-de-dart-html}

Remova a importação `dart:html` e substitua-a por `package:web/web.dart`:

```dart
import 'dart:html' as html; // Remover
import 'package:web/web.dart' as web; // Adicionar
```

Adicione `web` às `dependencies` no seu `pubspec`:

```console
dart pub add web
```

As seções a seguir abordam alguns dos problemas comuns de migração
de `dart:html` para `package:web`.

Para quaisquer outros problemas de migração, verifique o repositório [dart-lang/web][] e
abra uma issue.

### Renomeações {:#renames}

Muitos dos símbolos em `dart:html` foram renomeados a partir de
sua declaração IDL original para se alinhar melhor com o estilo Dart.
Por exemplo, `appendChild` tornou-se `append`,
`HTMLElement` tornou-se `HtmlElement`, etc.

Em contraste, para reduzir a confusão,
`package:web` usa os nomes originais das definições IDL.
Um `dart fix` está disponível para converter tipos que foram renomeados
entre `dart:html` e `package:web`.

Depois de alterar a importação, quaisquer objetos renomeados serão novos erros "não definidos".
Você pode solucionar isso de duas maneiras:
- A partir da CLI, executando `dart fix --dry-run`.
- Em seu IDE, selecionando o `dart fix`: **Renomear para '`nome do package:web`'**.

{% comment %}
TODO: Atualizar esta documentação para se referir a símbolos em vez de apenas tipos assim que
tivermos um dart fix para isso.
{% endcomment -%}

O `dart fix` abrange muitas das renomeações de tipos comuns.
Se você encontrar um tipo `dart:html` sem um `dart fix` para renomeá-lo,
informe-nos primeiro abrindo uma [issue][].

Então, você pode tentar descobrir manualmente o nome do tipo `package:web` de um
membro `dart:html` existente procurando sua definição.
O valor da anotação `@Native` na definição de um membro `dart:html`
indica ao compilador que qualquer objeto JS desse tipo deve ser tratado como a classe Dart
que ele anota. Por exemplo, a anotação `@Native` nos diz que o
nome JS nativo do membro `HtmlElement` de `dart:html` é `HTMLElement`,
portanto, o nome `package:web` também será `HTMLElement`:

```dart
@Native("HTMLElement")
class HtmlElement extends Element implements NoncedElement { }
```

Para encontrar a definição `dart:html` para um membro não definido em `package:web`,
tente um dos seguintes métodos:

- Pressione Ctrl ou command e clique no nome não definido no IDE e escolha
  **Ir para a definição**.
- Busque o nome na [documentação da API `dart:html`][html]
  e verifique sua página em *Annotations*.

Da mesma forma, você pode encontrar uma API `package:web` não definida cujo membro `dart:html` correspondente
usa a palavra-chave `native` em sua definição.
Verifique se a definição usa a anotação `@JSName` para uma renomeação;
o valor da anotação lhe dirá o nome que o membro usa em
`package:web`:

```dart
@JSName('appendChild')
Node append(Node node) native;
```

`native` é uma palavra-chave interna que significa o mesmo que `external` neste
contexto.

### Testes de tipo {:#testes-de-tipo}

É comum que o código que usa `dart:html` utilize verificações de tempo de execução como `is`.
Quando usado com um objeto `dart:html`, `is` e `as` verificam se o objeto é
o tipo JS dentro da anotação `@Native`.
Em contraste, todos os tipos `package:web` são reificados para [`JSObject`][]. Isso significa que
um teste de tipo de tempo de execução resultará em comportamento diferente entre os tipos `dart:html` e `package:web`.

Para poder realizar testes de tipo, migre qualquer código `dart:html`
usando testes de tipo `is` para usar [métodos de interoperabilidade][] como `instanceOfString`
ou o auxiliar mais conveniente e tipado [`isA`][]
(disponível a partir do Dart 3.4).
A seção [Compatibilidade, verificações de tipo e conversões][]
da página de tipos JS abrange alternativas em detalhes.

```dart
obj is Window; // Remover
obj.instanceOfString('Window'); // Adicionar
```

### Assinaturas de tipo {:#assinaturas-de-tipo}

Muitas APIs em `dart:html` suportam vários tipos Dart em suas assinaturas de tipo.
Como `dart:js_interop` [restrige] os tipos que podem ser escritos, alguns dos
membros em `package:web` agora exigirão que você *converta* o valor antes
de chamar o membro.
Saiba como usar os métodos de conversão de interoperabilidade na seção [Conversões][]
da página de tipos JS.

```dart
window.addEventListener('click', callback); // Remover
window.addEventListener('click', callback.toJS); // Adicionar
```

{% comment %}
TODO: Pense em um exemplo melhor. As pessoas provavelmente usarão os auxiliares de stream
em vez de `addEventListener`.
{% endcomment -%}

Geralmente, você pode identificar quais métodos precisam de uma conversão porque eles serão
marcados com alguma variação da exceção:

```plaintext
Um valor do tipo '...' não pode ser atribuído a uma variável do tipo 'JSFunction?'
```

### Importações condicionais {:#importacoes-condicionais}

It's common for code to use a conditional import based on whether `dart:html`
is supported to differentiate between native and web:

```dart
export 'src/hw_none.dart'
    if (dart.library.io) 'src/hw_io.dart'
    if (dart.library.html) 'src/hw_html.dart';
```

However, since `dart:html` is deprecated and not supported when
compiling to Wasm, the correct alternative now is to
use `dart.library.js_interop` to differentiate between native and web:

<?code-excerpt "create_libraries/lib/hw_mp.dart (export)"?>
```dart
export 'src/hw_none.dart' // Stub implementation
    if (dart.library.io) 'src/hw_io.dart' // dart:io implementation
    if (dart.library.js_interop) 'src/hw_web.dart'; // package:web implementation
```

### Despacho virtual e simulação {:#despacho-virtual-e-simulacao}

As classes `dart:html` suportavam despacho virtual, mas como a interoperabilidade JS usa
tipos de extensão, o despacho virtual [não é possível]. Da mesma forma, chamadas `dynamic`
com tipos `package:web` não funcionarão como esperado (ou podem continuar funcionando
apenas por acaso, mas pararão quando `dart:html` for removido), pois seus membros são
disponíveis apenas estaticamente. Migre todo o código que depende do despacho virtual para
evitar esse problema.

Um caso de uso do despacho virtual é a simulação. Se você tiver uma classe de simulação que
`implementa` uma classe `dart:html`, ela não poderá ser usada para implementar um tipo `package:web`. Em vez disso, prefira simular o próprio objeto JS. Consulte o [tutorial de simulação]
para mais informações.

### APIs não nativas {:#apis-nao-nativas}

As classes `dart:html` também podem conter APIs que possuem uma implementação não trivial. Esses membros podem ou não existir nos
[auxiliares](#auxiliares) `package:web`. Se seu código depender das especificidades dessa
implementação, você poderá copiar o código necessário.
No entanto, se você acha que isso não é viável ou se esse código seria benéfico
para outros usuários também, considere abrir uma issue ou enviar uma pull request para
[`package:web`][dart-lang/web] para suportar esse membro.

### Zonas {:#zonas}

Em `dart:html`, os callbacks são automaticamente zoneados.
Este não é o caso em `package:web`. Não há vinculação automática de
callbacks na zona atual.

Se isso for importante para seu aplicativo, você ainda pode usar zonas, mas precisará
[escrevê-las você mesmo][zonas] vinculando o callback. Veja [#54507] para mais
detalhes.
Não há nenhuma API de conversão ou [auxiliar](#auxiliares) disponível ainda para
fazer isso automaticamente.

## Auxiliares {:#auxiliares}

The core of `package:web` contains `external` interop members,
but doesn't provide other functionality that `dart:html` provided by default.
To mitigate these differences, `package:web` contains [`helpers`][helpers]
for additional support in handling a number of use cases
that aren't directly available through the core interop.
The helper library contains various members to expose some legacy features from
the Dart web libraries.

Por exemplo, o núcleo `package:web` só tem suporte para adicionar e remover
ouvintes de eventos. Em vez disso, você pode usar [auxiliares de stream][] que facilitam
a assinatura de eventos com `Streams` Dart sem escrever esse código você mesmo.

```dart
// Original dart:html version:
final htmlInput = InputElement();
await htmlInput.onBlur.first;

// Migrated package:web version:
final webInput = HTMLInputElement();
await webInput.onBlur.first;
```

Você pode encontrar todos os auxiliares e sua documentação no repositório em
[`package:web/helpers`][helpers]. Eles serão continuamente atualizados para auxiliar os usuários
na migração e facilitar o uso das APIs web.

## Exemplos {:#exemplos}

Aqui estão alguns exemplos de pacotes que foram migrados de `dart:html`
para `package:web`:

- [Atualizando `url_launcher` para `package:web`][]

{% comment %}
Temos outras migrações de pacotes para mostrar aqui?
{% endcomment -%}

[`package:web`]: {{site.pub-pkg}}/web
[Wasm]: /web/wasm
[html]: {{site.dart-api}}/dart-html/dart-html-library.html
[svg]: {{site.dart-api}}/dart-svg/dart-svg-library.html
[`dart:js_interop`]: {{site.dart-api}}/dart-js_interop/dart-js_interop-library.html
[`dart:js_interop_unsafe`]: {{site.dart-api}}/dart-js_interop_unsafe/dart-js_interop_unsafe-library.html
[idl]: https://www.npmjs.com/package/@webref/idl
[membros de interoperabilidade]: /interop/js-interop/usage#interop-members
[tipos de interoperabilidade]: /interop/js-interop/usage#interop-types
[dart-lang/web]: {{site.repo.dart.org}}/web
[issue]: {{site.repo.dart.org}}/web/issues/new
[helpers]: {{site.repo.dart.org}}/web/tree/main/web/lib/src/helpers
[zonas]: /libraries/async/zones
[Conversões]: /interop/js-interop/js-types#conversions
[métodos de interoperabilidade]: {{site.dart-api}}/dart-js_interop/JSAnyUtilityExtension.html#instance-methods
[declarações de interoperabilidade alternativas]: /interop/js-interop/usage
[Compatibilidade, verificações de tipo e conversões]: /interop/js-interop/js-types#compatibility-type-checks-and-casts
[Atualizando `url_launcher` para `package:web`]: https://github.com/flutter/packages/pull/5451/files
[auxiliares de stream]: {{site.repo.dart.org}}/web/blob/main/web/lib/src/helpers/events/streams.dart
[não é possível]: /language/extension-types
[`JSObject`]: {{site.dart-api}}/dart-js_interop/JSObject-extension-type.html
[`isA`]: {{site.dart-api}}/dart-js_interop/JSAnyUtilityExtension/isA.html
[restrige]: /interop/js-interop/js-types#requirements-on-external-declarations-and-function-tojs
[#54507]: {{site.repo.dart.sdk}}/issues/54507
[tutorial de simulação]: /interop/js-interop/mock

