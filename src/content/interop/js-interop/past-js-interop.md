---
ia-translate: true
title: Interop JS anterior
breadcrumb: Legado
description: Arquivo do suporte anterior de interop JS do Dart.
prevpage:
  url: /interop/js-interop/tutorials
  title: Tutoriais de interop JS
nextpage:
  url: /interop/js-interop/package-web/
  title: Migrar para package:web
---

## A evolução da interop JavaScript {: #next-generation-js-interop }

[Dart 3.3][] introduz uma nova geração de interop JS que oferece
um conjunto unificado de recursos e APIs para acessar funcionalidades de JavaScript e do navegador
dentro do seu código Dart. Essa abordagem moderna melhora a
experiência do desenvolvedor e habilita o suporte a WebAssembly ([Wasm][]), alinhando
o Dart com o futuro da web.

A tabela a seguir relaciona as novas soluções de interop JS e web do Dart
com suas contrapartes anteriores:

| Novas bibliotecas de interop        | Bibliotecas legadas                       |
|------------------------------|------------------------------------------|
| [`package:web`][] | [`dart:html`][] <br> [`dart:indexed_db`][] <br> [`dart:svg`][] <br> [`dart:web_audio`][] <br> [`dart:web_gl`][] |
| [`dart:js_interop`][] <br> [`dart:js_interop_unsafe`][] | [`package:js`][] <br> [`dart:js`][] <br> [`dart:js_util`][] |

{:.table .table-striped}


As iterações anteriores de interop JS para Dart são consideradas legadas e
estão depreciadas desde o Dart 3.7 (fev. 2025).
Prefira usar [`dart:js_interop`][] daqui para frente e
migre o uso das bibliotecas antigas de interop sempre que possível.
[`package:web`][] oferece suporte às APIs do navegador,
substituindo bibliotecas legadas como [`dart:html`][].


:::warning
Nenhuma das bibliotecas legadas de interop é suportada ao compilar para [Wasm][].
:::

### Desabilitar bibliotecas de interop JS depreciadas {:#disallow-deprecated-js-interop}

:::version-note
A flag do compilador `--[no-]deprecated-js-interop` requer o Dart 3.14 ou posterior.
:::

Para verificar se seu app e suas dependências não importam bibliotecas web legadas
ao compilar para JavaScript,
passe a flag `--no-deprecated-js-interop` para [`dart compile js`][] (`dart2js`)
ou `dart compile js-dev` (`dartdevc`):

```console
$ dart compile js --no-deprecated-js-interop -o out/main.js web/main.dart
```

Se você faz o build com [`webdev`][] 4.1.0 ou posterior
(com [`build_web_compilers`][] 4.9.0 ou posterior),
pode passar a flag `--no-deprecated-js-interop` para comandos do `webdev`
como `webdev serve` e `webdev build`.
Para configurar o `build.yaml` diretamente, em vez disso,
defina `deprecated-js-interop: false` em `global_options`
para todos os quatro builders do [`build_web_compilers`][]
(`build_web_compilers:ddc`, `build_web_compilers:ddc_modules`,
`build_web_compilers:dart2js_modules` e `build_web_compilers:entrypoint`).

Passar a flag `--no-deprecated-js-interop` impõe o seguinte comportamento:

- **Proíbe imports web legados**:
  Importar qualquer uma das bibliotecas web `dart:*` depreciadas
  (`dart:html`, `dart:indexed_db`, `dart:js`,
  `dart:js_util`, `dart:svg`, `dart:web_audio` e `dart:web_gl`) — ou
  pacotes que as importam, como `package:js` — resulta em um erro de compilação.
  (`dart compile wasm` sempre proíbe essas bibliotecas e não aceita
  a flag `--[no-]deprecated-js-interop`.)
- **Avalia imports condicionais legados como `false`**:
  As condições de ambiente `dart.library.html`,
  `dart.library.indexed_db`, `dart.library.js`, `dart.library.js_util`,
  `dart.library.svg`, `dart.library.web_audio` e `dart.library.web_gl`
  são avaliadas como `false` em [imports condicionais][conditional imports]
  (como `if (dart.library.html)`) e em [`bool.fromEnvironment`][].
- **Reporta cadeias de import de menor caminho**:
  Quando um app ou uma dependência importa uma biblioteca proibida,
  `dart compile js` (`dart2js`) imprime uma árvore de import de menor caminho, sem duplicatas,
  que identifica qual biblioteca ou pacote introduziu o import depreciado:

  ```plaintext
  Deprecated JS interop libraries are imported through:
    main library
    ├── package:foo
    │   └── dart:html
    └── web/src/app.dart
        ├── package:foo (see above)
        └── package:bar
            └── dart:js_util
  ```

Por padrão, os compiladores de JavaScript permitem bibliotecas de interop JS depreciadas
(`--deprecated-js-interop`).
Passe a flag `--no-deprecated-js-interop`
no seu pipeline de integração contínua (CI)
para detectar cedo dependências web legadas
e preparar seu código para a remoção
das bibliotecas web `dart:*` depreciadas do SDK do Dart.

Para detectar verificações de tipo e casts inválidos com tipos de interop JS,
habilite a regra de lint [`invalid_runtime_check_with_js_interop_types`][].
A partir do [`package:lints`][] 7.0.0,
`package:lints/core.yaml` inclui essa regra.

[Dart 3.3]: /blog/new-in-dart-3-3-extension-types-javascript-interop-and-more
[`package:web`]: {{site.pub-pkg}}/web
[`dart:html`]: {{site.dart-api}}/dart-html/
[`dart:indexed_db`]: {{site.dart-api}}/dart-indexed_db/
[`dart:js_interop`]: {{site.dart-api}}/dart-js_interop/
[`dart:js_interop_unsafe`]: {{site.dart-api}}/dart-js_interop_unsafe/
[`dart:js_util`]: {{site.dart-api}}/dart-js_util/
[`dart:svg`]: {{site.dart-api}}/dart-svg/
[`dart:web_audio`]: {{site.dart-api}}/dart-web_audio/
[`dart:web_gl`]: {{site.dart-api}}/dart-web_gl/
[Wasm]: /web/wasm
[`dart compile js`]: /tools/dart-compile#js
[`webdev`]: /tools/webdev
[`build_web_compilers`]: {{site.pub-pkg}}/build_web_compilers
[conditional imports]: /interop/js-interop/package-web#conditional-imports
[`bool.fromEnvironment`]: {{site.dart-api}}/dart-core/bool/bool.fromEnvironment.html
[`invalid_runtime_check_with_js_interop_types`]: /tools/linter-rules/invalid_runtime_check_with_js_interop_types
[`package:lints`]: {{site.pub-pkg}}/lints

## `dart:js`

[`dart:js`][] expôs um [`object wrapper`][] concreto para interoperar com objetos JS.
Esse wrapper continha métodos baseados em String para obter, definir e chamar
propriedades no objeto JS encapsulado de forma dinâmica. Era menos performático por causa dos
custos de wrapping e mais difícil de usar do ponto de vista ergonômico. Por exemplo, você não recebia
code-completion, pois não podia declarar membros de interop e dependia de
Strings. Muitas das funcionalidades expostas em `dart:js`, como
[`allowInterop`][], foram depois reexpostas por meio de outras bibliotecas de interop.

Essa biblioteca é legada desde que
`package:js` e `dart:js_util` foram lançados.

[`object wrapper`]: {{site.dart-api}}/dart-js/JsObject-class.html
[`allowInterop`]: {{site.dart-api}}/dart-js_util/allowInterop.html

## `package:js`

[`package:js`][] introduziu a funcionalidade de declarar tipos e membros de interop.
Ela permitia escrever classes de interop em vez de extension types de interop.
Em tempo de execução, essas classes eram apagadas para um tipo parecido com o
[`JSObject`][] de `dart:js_interop`.

```dart
@JS()
class JSType {}
```

Quem usa `package:js` vai achar a
sintaxe e a semântica de `dart:js_interop` familiares.
Talvez seja possível migrar para `dart:js_interop` substituindo a definição da classe
por um extension type, e isso funciona em muitos casos.

Há diferenças significativas, no entanto:

- Tipos de `package:js` não podiam ser usados para interoperar com APIs do navegador.
  Tipos de `dart:js_interop` podem.
- `package:js` permitia dispatch dinâmico. Isso significava que, se você convertesse o
  tipo de `package:js` para `dynamic` e chamasse um membro de interop nele, a chamada
  era encaminhada para o membro correto. Isso não é mais possível com
  `dart:js_interop`.
- O `@JS` de `package:js` não oferece garantias de soundness, já que os tipos de retorno de
  membros `external` não eram verificados. `dart:js_interop` é sound.
- Tipos de `package:js` não podiam renomear membros de instância nem ter membros
  não-`external`.
- Tipos de `package:js` podiam ser subtipos e supertipos de classes que não são de interop.
  Isso era frequentemente usado em mocks. Com `dart:js_interop`, o mocking é feito
  substituindo o objeto JS. Veja o [tutorial sobre mocking][tutorial on mocking].
- Tipos [`@anonymous`][] eram uma forma de declarar um tipo de interop com um
  construtor de object literal. `dart:js_interop` não distingue tipos dessa forma, e
  qualquer construtor `external` com argumentos nomeados é um construtor de object literal.

### `@staticInterop`

Junto com `@JS` e `@anonymous`, `package:js` depois expôs
[`@staticInterop`][], que era um protótipo de extension types de interop. Ele é tão
expressivo e restritivo quanto `dart:js_interop` e foi pensado como uma
sintaxe transitória, até que extension types estivessem disponíveis.

Tipos `@staticInterop` eram implicitamente apagados para `JSObject`. Eles exigiam que os usuários
declarassem todos os membros de instância em extensions, para que apenas semântica estática
pudesse ser usada, e tinham garantias de soundness mais fortes. Os usuários podiam usá-lo para
interagir com APIs do navegador, e ele também permitia coisas como renomear e
membros não-`external`. Assim como os extension types de interop, não tinha suporte a
dispatch dinâmico.

Classes `@staticInterop` quase sempre podem ser migradas para um extension
type de interop, apenas trocando a classe por um extension type e removendo as
anotações.

`dart:js_interop` expôs `@staticInterop` (e `@anonymous`, mas apenas se
`@staticInterop` também for usado) para dar suporte à semântica de interop estático até que
extension types fossem adicionados à linguagem. Todos esses tipos devem agora ser
migrados para extension types.

[`@staticInterop`]: {{site.repo.dart.sdk}}/blob/main/sdk/lib/js/_js_annotations.dart#L48

## `dart:js_util`

[`dart:js_util`][] fornecia várias funções utilitárias que não podiam ser
declaradas em um tipo de `package:js` ou eram necessárias para que valores fossem passados de um lado
para o outro. Isso incluía membros como:

- `allowInterop` (que agora é [`Function.toJS`][])
- `getProperty`/`setProperty`/`callMethod`/`callConstructor` (que agora estão em
  [`dart:js_interop_unsafe`][])
- Vários operadores de JS
- Helpers de verificação de tipo
- Suporte a mocking
- E mais.

`dart:js_interop` e `dart:js_interop_unsafe` agora contêm esses helpers, possivelmente
com uma sintaxe alternativa.

[`dart:js`]: {{site.dart-api}}/dart-js/
[`package:js`]: {{site.pub-pkg}}/js
[`JSObject`]: {{site.dart-api}}/dart-js_interop/JSObject-extension-type.html
[`@anonymous`]: {{site.repo.dart.sdk}}/blob/main/sdk/lib/js/_js_annotations.dart#L40
[tutorial on mocking]: /interop/js-interop/mock
[`dart:js_util`]: {{site.dart-api}}/dart-js_util/dart-js_util-library.html
[`Function.toJS`]: {{site.dart-api}}/dart-js_interop/FunctionToJSExportedDartFunction/toJS.html
[`dart:js_interop_unsafe`]: {{site.dart-api}}/dart-js_interop_unsafe/
[Wasm]: /web/wasm
