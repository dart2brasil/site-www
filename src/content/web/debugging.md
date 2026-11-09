---
ia-translate: true
title: Depurando aplicações web Dart
shortTitle: Depurando aplicações web
breadcrumb: Depuração
description: Aprenda a depurar sua aplicação web Dart.
---

Você pode depurar aplicações web Dart usando sua [IDE Dart][IDE], o [Dart DevTools][],
e ferramentas do navegador, como o [Chrome DevTools][].

* **Lógica e estado da aplicação:** use o depurador embutido da sua IDE ou o Dart DevTools
  para definir breakpoints em arquivos `.dart`, inspecionar variáveis e avaliar
  expressões Dart.
* **DOM, CSS e atividade de rede:** use as ferramentas de desenvolvedor do navegador,
  como o [Chrome DevTools][].

## Depurar em uma IDE {:#debug-in-an-ide}

A forma mais rápida de depurar uma aplicação web Dart durante o desenvolvimento é
usar uma [IDE com suporte a Dart][IDE], como VS Code ou IntelliJ IDEA.
Abra seu projeto, defina breakpoints na margem do editor e inicie uma
sessão de depuração.
O editor compila sua aplicação com `dartdevc`, abre o Chrome e conecta
o depurador automaticamente.

Para inspecionar os arquivos Dart com source map diretamente no Chrome DevTools
a qualquer momento, pressione <kbd>Control</kbd>+<kbd>Shift</kbd>+<kbd>I</kbd>
(<kbd>Command</kbd>+<kbd>Option</kbd>+<kbd>I</kbd> no macOS).
O Chrome usa [source maps][] para exibir seus arquivos `.dart` originais
em vez do JavaScript ou WebAssembly compilado.

## Depurar pela linha de comando com o Dart DevTools {:#using-dart-devtools}

Para depurar pela linha de comando usando o [Dart SDK][] mais recente e o
[Google Chrome][Google Chrome], ative globalmente a ferramenta de linha de comando
[`webdev`][webdev] com [`dart pub global`][dart pub global]:

```console
$ dart pub global activate webdev
```

:::note
Sempre que você atualizar o Dart SDK, execute `dart pub global activate webdev` de novo
para que o `webdev` fique alinhado com a versão do SDK ativa.
:::

![Depurador do Dart DevTools mostrando código-fonte e breakpoints](/assets/img/dart-devtools-screenshot.png)

1. No diretório raiz da sua [aplicação web Dart][Dart web app], busque as dependências do pacote:

   ```console
   $ dart pub get
   ```

1. Inicie o servidor de desenvolvimento em modo de depuração (opcionalmente passe
   `--auto restart` para fazer hot restart quando os arquivos mudarem):

   * **Abra uma nova instância de depuração do Chrome:**

     ```console
     $ webdev serve --debug --auto restart
     ```

   * **Use uma janela do Chrome já aberta** (requer a
     [Dart Debug Extension][]):

     ```console
     $ webdev serve --debug-extension --auto restart
     ```

1. Abra `http://localhost:8080` no Chrome, caso ainda não esteja aberto.

1. Abra o **Dart DevTools**:

   * Com `--debug`, pressione <kbd>Alt</kbd>+<kbd>D</kbd>
     (<kbd>Option</kbd>+<kbd>D</kbd> no macOS).
   * Com `--debug-extension`, clique no ícone do Dart
     <img src="/assets/img/logo/dart-64.png" alt="Logo do Dart" class="align-baseline text-icon">
     na barra de ferramentas do Chrome.

1. Na aba **Debugger**, clique no número de uma linha do seu arquivo `.dart` para definir
   um breakpoint e, em seguida, acione esse trecho de código na aplicação.
   Quando a execução pausar, inspecione as variáveis no painel **Variables** e avance
   pelo código com **Step In**, **Step Over** e **Step Out**.

   :::note
   O Dart DevTools não entra no código de implementação do SDK por padrão
   (por exemplo, ao usar Step In em `print()`, a execução avança para a próxima linha da sua aplicação).
   :::

1. Abra a visualização **Logging** para inspecionar `stdout`, `stderr` e eventos do sistema.

## Executar testes web e coletar cobertura {:#running-web-tests-and-collecting-coverage}

Para executar testes unitários no navegador, passe `-p` (`--platform`) para
o [`dart test`][dart test]:

```console
$ dart test -p chrome
```

Você também pode usar o Firefox (`-p firefox`) ou o Safari (`-p safari`).

Para pausar a execução depois do carregamento, de modo que você possa abrir o DevTools
do navegador e definir breakpoints antes de os testes rodarem, passe `--pause-after-load`:

```console
$ dart test -p chrome --pause-after-load
```

Para coletar cobertura de código dos testes web em JavaScript (`dart2js`) no Chrome, passe
`-p chrome` para o `test_with_coverage` (requer o [`package:coverage`][coverage-pkg]
1.16.0 ou superior):

```console
$ dart run coverage:test_with_coverage -p chrome
```

:::note
A cobertura no Chrome usa a cobertura de JavaScript do V8 e não oferece suporte a testes
em WebAssembly (`--compiler dart2wasm`).
:::

## Depurar código de produção {:#debugging}

Chrome, Edge, Firefox e Safari oferecem suporte a source maps tanto para builds de produção em
JavaScript (`.js.map`) quanto em WebAssembly (`.wasm.map`).

:::tip
Sempre que possível, depure builds de desenvolvimento (`webdev serve --debug`) em vez do código de
produção, pois as otimizações fazem inline de funções e minificam os símbolos.
:::

Ao compilar para WebAssembly com [`dart compile wasm`][dart compile wasm],
o compilador gera um source map `<nome>.wasm.map` junto com `<nome>.wasm` e remove
os nomes estáticos de símbolos do binário `.wasm` por padrão (e minifica os nomes de tipos
em tempo de execução a partir de `-O2`).
Passe `--no-strip-wasm` para manter os nomes de símbolos estáticos legíveis nos stack traces
e flamecharts do DevTools do navegador:

```console
$ dart compile wasm -O2 --no-strip-wasm web/main.dart -o build/main.wasm
```

Garanta que seu servidor web sirva o arquivo `.js.map` ou `.wasm.map` gerado junto com
a saída compilada, para que o navegador consiga localizar os arquivos Dart.

Seja qual for o navegador, ative pausa pelo menos em exceções não tratadas.
Para frameworks como `dart:async` que envolvem código do usuário em blocos `try`-`catch`,
ative a pausa em todas as exceções para revelar erros capturados.

### Chrome {:#dart2js-debugging-chrome}

1. Abra o [Chrome DevTools][].
1. Confirme que os source maps estão habilitados (ativados por padrão), conforme descrito em
   [Mapear código pré-processado para código-fonte][source maps].
1. Ative a pausa em todas as exceções ou em exceções não tratadas, conforme descrito em
   [Pausar seu código com breakpoints][chrome-breakpoints].
1. Recarregue sua aplicação.

### Edge {:#dart2js-debugging-ie}

1. Abra o [DevTools do Microsoft Edge][edge-devtools] (<kbd>F12</kbd>).
1. Na ferramenta **Sources**, abra o painel **Breakpoints** e habilite
   **Pause on uncaught exceptions** (ou **Pause on caught exceptions**), conforme descrito em
   [Pausar seu código com breakpoints][edge-breakpoints].
1. Recarregue sua aplicação para inspecionar os arquivos `.dart` com source map na ferramenta **Sources**.

### Firefox {:#dart2js-debugging-firefox}

1. Abra as [**Ferramentas de Desenvolvedor do Firefox**][firefox-devtools].
1. Habilite **Pause on exceptions**:

   ![Habilitar Pause on exceptions no depurador do Firefox](/assets/img/ff-debug.png)

1. Recarregue sua aplicação para ver os arquivos com source map na aba **Debugger**.

### Safari {:#dart2js-debugging-safari}

1. Ative o menu **Develop**, conforme descrito em
   [Habilitando o Web Inspector][safari-web-inspector].
1. Habilite breakpoints em todas as exceções ou em exceções não tratadas, veja
   [Adicionar um breakpoint JavaScript][safari-breakpoints] em
   [Safari Developer Help][safari-dev-help].
1. Recarregue sua aplicação.

## Recursos {:#resources}

* [IDEs e editores Dart][IDE]
* [Documentação do Dart DevTools][Dart DevTools]
* [Documentação da ferramenta `webdev`][webdev]
* [Pacote `webdev` no pub.dev][webdev-pkg]

[Chrome DevTools]: https://developer.chrome.com/docs/devtools/
[chrome-breakpoints]: https://developer.chrome.com/docs/devtools/javascript/breakpoints/
[coverage-pkg]: {{site.pub-pkg}}/coverage
[dart compile wasm]: /tools/dart-compile#wasm
[Dart Debug Extension]: https://chromewebstore.google.com/detail/dart-debug-extension/eljbmlghnomdjgdjmbdekegdkbabckhm
[Dart DevTools]: /tools/dart-devtools
[dart pub global]: /tools/pub/cmd/pub-global
[Dart SDK]: /get-dart
[dart test]: /tools/dart-test
[Dart web app]: /web
[edge-breakpoints]: https://learn.microsoft.com/en-us/microsoft-edge/devtools/javascript/breakpoints#exception-breakpoints
[edge-devtools]: https://learn.microsoft.com/en-us/microsoft-edge/devtools/landing/
[firefox-devtools]: https://firefox-source-docs.mozilla.org/devtools-user/index.html
[Google Chrome]: https://www.google.com/chrome
[IDE]: /tools#editors
[safari-breakpoints]: https://support.apple.com/guide/safari-developer/add-a-javascript-breakpoint-dev5e4caf347/mac
[safari-dev-help]: https://support.apple.com/guide/safari-developer/welcome/mac
[safari-web-inspector]: https://webkit.org/web-inspector/enabling-web-inspector/
[source maps]: https://developer.chrome.com/docs/devtools/javascript/source-maps/
[webdev]: /tools/webdev
[webdev-pkg]: {{site.pub-pkg}}/webdev
