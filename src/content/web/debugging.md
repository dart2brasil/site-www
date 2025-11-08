---
ia-translate: true
title: Depurando aplicações web Dart
shortTitle: Depurando aplicações web
breadcrumb: Depuração
description: Aprenda como depurar sua aplicação web Dart.
---

Você pode usar uma [IDE Dart][IDE], [Dart DevTools][], e ferramentas de navegador
como [Chrome DevTools][] para depurar suas aplicações web Dart.

* Para depurar a lógica da sua aplicação,
  use sua IDE, Dart DevTools, ou ferramentas de navegador.
  Dart DevTools tem melhor suporte do que ferramentas de navegador
  para inspecionar e recarregar automaticamente código Dart.
* Para depurar a aparência da sua aplicação (HTML/CSS) e performance,
  use sua IDE ou ferramentas de navegador como Chrome DevTools.


## Visão geral

Para servir sua aplicação, use `webdev serve`
(na linha de comando ou através da sua IDE)
para iniciar o compilador de desenvolvimento Dart.
Para habilitar o Dart DevTools, adicione a opção `--debug` ou `--debug-extension`
(na linha de comando ou através da sua IDE):

```console
$ webdev serve --debug
```

Ao executar sua aplicação usando a flag `--debug` do `webdev`,
você pode abrir o Dart DevTools pressionando
<kbd>Alt</kbd>+<kbd>D</kbd>
(ou <kbd>Option</kbd>+<kbd>D</kbd> no macOS).

Para abrir o Chrome DevTools, pressione <kbd>Control</kbd>+<kbd>Shift</kbd>+<kbd>I</kbd>
(ou <kbd>Command</kbd>+<kbd>Option</kbd>+<kbd>I</kbd> no macOS).
Se você quiser depurar sua aplicação usando Chrome DevTools,
você pode usar [source maps][] para exibir seus arquivos fonte Dart
em vez do JavaScript que o compilador produz.
Para mais informações sobre o uso do Chrome DevTools,
veja a [documentação do Chrome DevTools.][Chrome DevTools]

[source maps]: https://developer.chrome.com/docs/devtools/javascript/source-maps/

Para usar o Dart DevTools ou Chrome DevTools
para depurar uma aplicação web Dart, você precisa do seguinte software:

* [Google Chrome.][Google Chrome]
* [Dart SDK][], versão 2.0.0 ou superior.
* Um dos seguintes ambientes de desenvolvimento:
  * Linha de comando: [pacotes de ferramentas de linha de comando Dart][cl-tools]
    como webdev (necessário tanto para Dart quanto para Chrome DevTools) e
    devtools (necessário para Dart DevTools).
    <br>_ou_
  * Uma [IDE ou editor Dart][IDE] que suporte desenvolvimento web.
* Uma [aplicação web Dart][Dart web app] para depurar.

[cl-tools]: #getting-command-line-tool-packages

## Começando com Dart DevTools {:#using-dart-devtools}

<img src="/assets/img/dart-devtools-screenshot.png" alt="DevTools">

Esta seção guia você pelos conceitos básicos de
usar o Dart DevTools para depurar uma aplicação web.
Se você já tem uma aplicação pronta para depurar,
você pode pular a criação da aplicação de teste (passo 1),
mas você precisará ajustar as instruções para corresponder à sua aplicação.

1. _Opcional:_ Clone o [repositório webdev][webdev repo,] para que você possa usar sua aplicação de exemplo
   para experimentar o Dart DevTools.

1. _Opcional:_ Instale a [Dart Debug Extension][]
   para que você possa executar sua aplicação e abrir o Dart DevTools
   em uma instância do Chrome já em execução.

1. No diretório principal da sua aplicação, execute `dart pub get` para obter suas dependências.

   ```console
   $ cd example
   $ dart pub get
   ```

1. Compile e sirva a aplicação em modo debug,
   usando sua IDE ou `webdev` na linha de comando.

   :::note
   A primeira compilação leva mais tempo,
   porque toda a aplicação deve ser compilada.
   Depois disso, as atualizações são muito mais rápidas.
   :::

   Se você estiver usando webdev na linha de comando,
   o comando a usar depende se você quer (ou precisa)
   executar a aplicação e o depurador em uma instância do Chrome já em execução.

   * Se você tem a [Dart Debug Extension][] instalada e quer usar
     uma instância existente do Chrome para depurar:

     ```console
     $ webdev serve --debug-extension
     ```

   * Caso contrário, use o seguinte comando,
     que inicia uma nova instância do Chrome
     e executa a aplicação:

     ```console
     $ webdev serve --debug
     ```

1. Se sua aplicação ainda não estiver em execução, abra-a em uma janela do navegador Chrome.
   <br>
   Por exemplo, se você usar `webdev serve --debug-extension` sem argumentos,
   abra [http://127.0.0.1:8080](http://http://127.0.0.1:8080).

1. Abra o Dart DevTools para depurar a aplicação que está em execução na janela atual.

   * Se a Dart Debug Extension estiver instalada e
     você usou a flag `--debug-extension` com `webdev`,
     clique no logo do Dart
     <img src="/assets/img/logo/dart-64.png" alt="Dart logo" class="align-baseline text-icon">
     no canto superior direito da janela do navegador.

   * Se você usou a flag `--debug` com `webdev`,
     pressione <kbd>Alt</kbd>+<kbd>D</kbd>
     (ou <kbd>Option</kbd>+<kbd>D</kbd> no macOS).

   A janela do Dart DevTools abre
   e exibe o código fonte do arquivo principal da sua aplicação.

1. Defina um breakpoint dentro de um timer ou manipulador de evento
   clicando à esquerda de uma das linhas de código.
   <br>
   Por exemplo, clique no número da linha para a primeira linha dentro
   de um manipulador de evento ou callback de timer.

1. Acione o evento que causa a chamada da função.
   A execução para no breakpoint.

1. No painel **Variables**, inspecione os valores das variáveis.

1. Retome a execução do script, e acione o evento novamente ou pressione **Pause**.
   A execução pausa novamente.

1. Tente percorrer o código linha por linha usando os
   botões **Step In**, **Step Over**, e **Step Out**.

   :::note
   O Dart DevTools não entra no código do SDK.
   Por exemplo, se você pressionar **Step In** em uma chamada para `print()`,
   você vai para a próxima linha, não para o código do SDK que implementa `print()`.
   :::

1. Altere seu código fonte e recarregue a janela do Chrome que está executando a aplicação.
   A aplicação recompila e recarrega rapidamente.
   Até que a [issue 1925][] seja corrigida,
   você perde seus breakpoints ao recarregar a aplicação.

1. Clique no botão **Logging** para ver stdout, stderr, e logs do sistema.


## Obtendo pacotes de ferramentas de linha de comando

Se você está usando a linha de comando em vez de uma IDE ou editor habilitado para Dart,
então você precisa da [ferramenta webdev][webdev].
O Dart DevTools é fornecido pelo SDK.

```console
$ dart pub global activate webdev
```

Se sua variável de ambiente PATH estiver configurada corretamente,
você pode agora usar essas ferramentas na linha de comando:

```console
$ webdev --help
A tool to develop Dart web projects.
...
```

Para informações sobre configurar PATH, veja a
[documentação do `dart pub global`.][dart pub global documentation]

Sempre que você atualizar o Dart SDK,
atualize as ferramentas ativando-as novamente:

```console
$ dart pub global activate webdev     # update webdev
```

{% render 'tools/debug-prod-js-code.md', site: site %}

## Recursos

Para saber mais, veja o seguinte:

* Documentação para [sua IDE][IDE]
* [Documentação do Dart DevTools][Dart DevTools]
* [Documentação da ferramenta webdev][webdev]
* [Documentação do pacote webdev][webdev-pkg]

[Chrome DevTools]: https://developer.chrome.com/docs/devtools/
[Dart Debug Extension]: https://chrome.google.com/webstore/detail/dart-debug-extension/eljbmlghnomdjgdjmbdekegdkbabckhm
[Dart DevTools]: /tools/dart-devtools
[IDE]: /tools#editors
[Dart SDK]: /get-dart
[Dart web app]: /web
[Google Chrome]: https://www.google.com/chrome
[issue 1925]: https://github.com/flutter/devtools/issues/1925
[JavaScript debugging reference]: https://developer.chrome.com/docs/devtools/javascript/reference/
[dart pub global documentation]: /tools/pub/cmd/pub-global
[webdev]: /tools/webdev
[webdev repo,]: {{site.repo.dart.org}}/webdev
[webdev-pkg]: {{site.pub-pkg}}/webdev
