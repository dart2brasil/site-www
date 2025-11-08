---
ia-translate: true
title: "Depurando aplicações web Dart"
shortTitle: Depurando aplicações web
breadcrumb: Depuração
description: "Aprenda como depurar sua aplicação web Dart."
---

Você pode usar uma [IDE Dart][IDE], [Dart DevTools][Dart DevTools], e ferramentas do
navegador como o [Chrome DevTools][Chrome DevTools] para depurar seus aplicativos web Dart.

* Para depurar a lógica do seu aplicativo, use sua IDE, Dart DevTools ou
  ferramentas do navegador. O Dart DevTools tem um suporte melhor do que as
  ferramentas do navegador para inspecionar e recarregar
  automaticamente o código Dart.
* Para depurar a aparência (HTML/CSS) e o desempenho do seu aplicativo,
  use sua IDE ou ferramentas do navegador como o Chrome DevTools.


## Visão geral {:#overview}

Para servir seu aplicativo, use `webdev serve`
(seja na linha de comando ou através da sua IDE) para iniciar o compilador
de desenvolvimento Dart. Para habilitar o Dart DevTools, adicione a
opção `--debug` ou `--debug-extension`
(na linha de comando ou através da sua IDE):

```console
$ webdev serve --debug
```

Ao executar seu aplicativo usando a *flag* `--debug` do `webdev`,
você pode abrir o Dart DevTools pressionando
<kbd>Alt</kbd>+<kbd>D</kbd>
(ou <kbd>Option</kbd>+<kbd>D</kbd> no macOS).

Para abrir o Chrome DevTools, pressione <kbd>Control</kbd>+<kbd>Shift</kbd>+<kbd>I</kbd>
(ou <kbd>Command</kbd>+<kbd>Option</kbd>+<kbd>I</kbd> no macOS).
Se você quiser depurar seu aplicativo usando o Chrome DevTools,
você pode usar [source maps][source maps] (mapas de origem) para exibir seus arquivos de origem Dart
em vez do JavaScript que o compilador produz.
Para mais informações sobre o uso do Chrome DevTools,
veja a [documentação do Chrome DevTools][Chrome DevTools].

[source maps]: https://developer.chrome.com/docs/devtools/javascript/source-maps/

Para usar o Dart DevTools ou o Chrome DevTools para depurar um aplicativo
web Dart, você precisa do seguinte software:

* [Google Chrome.][Google Chrome]
* [Dart SDK][Dart SDK], versão 2.0.0 ou superior.
* Um dos seguintes ambientes de desenvolvimento:
  * Linha de comando: [Pacotes de ferramentas de linha de comando Dart][cl-tools]
    como o webdev (necessário para Dart e Chrome DevTools) e
    devtools (necessário para Dart DevTools).
    <br>_ou_
  * Uma [IDE ou editor Dart][IDE] que suporte desenvolvimento web.
* Um [aplicativo web Dart][Dart web app] para depurar.

[cl-tools]: #getting-command-line-tool-packages

## Primeiros passos com o Dart DevTools {:#using-dart-devtools}

<img src="/assets/img/dart-devtools-screenshot.png" alt="DevTools">

Esta seção guia você através do básico de
usar o Dart DevTools para depurar um aplicativo web.
Se você já tem um aplicativo que está pronto para depurar,
você pode pular a criação do aplicativo de teste (passo 1),
mas você precisará ajustar as instruções para corresponder ao seu aplicativo.

1. _Opcional:_ Clone o [repositório webdev,][webdev repo,] para que você possa usar seu aplicativo de exemplo
   para experimentar o Dart DevTools.

1. _Opcional:_ Instale a [Dart Debug Extension][Dart Debug Extension]
   para que você possa executar seu aplicativo e abrir o Dart DevTools
   em uma instância já em execução do Chrome.

1. No diretório superior do seu aplicativo, execute `dart pub get` para obter suas dependências.

   ```console
   $ cd example
   $ dart pub get
   ```

1. Compile e sirva o aplicativo em modo de depuração,
   usando sua IDE ou `webdev` na linha de comando.

   :::note
   A primeira compilação leva mais tempo,
   porque todo o aplicativo deve ser compilado.
   Depois disso, as atualizações são muito mais rápidas.
   :::

   Se você estiver usando o webdev na linha de comando,
   o comando a ser usado depende se você quer (ou precisa) executar
   o aplicativo e o depurador em uma instância já em execução do Chrome.

   * Se você tem a [Dart Debug Extension][Dart Debug Extension] instalada e quer usar
     uma instância existente do Chrome para depurar:

     ```console
     $ webdev serve --debug-extension
     ```

   * Caso contrário, use o seguinte comando,
     que inicia uma nova instância do Chrome
     e executa o aplicativo:

     ```console
     $ webdev serve --debug
     ```

1. Se seu aplicativo ainda não estiver em execução, abra-o em uma janela do navegador Chrome.
   <br>
   Por exemplo, se você usar `webdev serve --debug-extension` sem argumentos,
   abra [http://127.0.0.1:8080](http://http://127.0.0.1:8080).

1. Abra o Dart DevTools para depurar o aplicativo que está sendo executado na janela atual.

   * Se a Dart Debug Extension estiver instalada e
     você usou a *flag* `--debug-extension` para `webdev`,
     clique no logo do Dart
     <img src="/assets/img/logo/dart-64.png" alt="Logo Dart" class="align-baseline text-icon">
     no canto superior direito da janela do navegador.
     
   * Se você usou a *flag* `--debug` para `webdev`,
     pressione <kbd>Alt</kbd>+<kbd>D</kbd>
     (ou <kbd>Option</kbd>+<kbd>D</kbd> no macOS).
   
   A janela do Dart DevTools aparece
   e exibe o código fonte do arquivo principal do seu aplicativo.

1. Defina um *breakpoint* (ponto de interrupção) dentro de um *timer* (temporizador) ou *event handler* (manipulador de eventos)
   clicando à esquerda de uma de suas linhas de código.
   <br>
   Por exemplo, clique no número da linha da primeira linha dentro de
   um *event handler* ou *callback* de *timer*.

1. Acione o evento que causa a chamada da função.
   A execução para no *breakpoint*.

1. No painel **Variables** (Variáveis), inspecione os valores das variáveis.

1. Retome a execução do script e acione o evento novamente ou pressione **Pause** (Pausar).
   A execução pausa novamente.

1. Tente percorrer o código linha por linha usando os
   botões **Step In** (Entrar), **Step Over** (Pular) e **Step Out** (Sair).

   :::note
   O Dart DevTools não entra no código do SDK.
   Por exemplo, se você pressionar **Step In** em uma chamada para `print()`,
   você vai para a próxima linha, não para o código do SDK que implementa `print()`.
   :::

1. Altere seu código fonte e recarregue a janela do Chrome que está executando o aplicativo.
   O aplicativo é reconstruído e recarregado rapidamente.
   Até que a [issue 1925][issue 1925] seja corrigida,
   você perderá seus *breakpoints* ao recarregar o aplicativo.

1. Clique no botão **Logging** (Registro) para ver os logs stdout, stderr e do sistema.


## Obtendo pacotes de ferramentas de linha de comando {:#getting-command-line-tool-packages}

Se você estiver usando a linha de comando em vez de uma IDE ou editor habilitado para Dart,
então você precisa da [ferramenta webdev][webdev].
O Dart DevTools é fornecido pelo SDK.

```console
$ dart pub global activate webdev
```

Se sua variável de ambiente PATH estiver configurada corretamente,
você agora pode usar essas ferramentas na linha de comando:

```console
$ webdev --help
Uma ferramenta para desenvolver projetos web Dart.
...
```

Para obter informações sobre como configurar o PATH, consulte a
[documentação do `dart pub global`][dart pub global documentation].

Sempre que você atualizar o Dart SDK,
atualize as ferramentas ativando-as novamente:

```console
$ dart pub global activate webdev     # atualiza webdev
```

{% render 'tools/debug-prod-js-code.md', site: site %}

## Recursos {:#resources}

Para aprender mais, veja o seguinte:

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
