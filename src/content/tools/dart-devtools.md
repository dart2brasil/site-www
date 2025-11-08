---
ia-translate: true
title: Dart DevTools
shortTitle: DevTools
description: Um conjunto de ferramentas de depuração e desempenho.
---

Dart DevTools é um conjunto de ferramentas de depuração e desempenho
para Dart e Flutter.
Essas ferramentas são distribuídas como parte da ferramenta `dart`
e interagem com ferramentas como IDEs, `dart run` e `webdev`.

<img src="/assets/img/tools/devtools.png" width="800" alt="Screenshot of DevTools' Memory page">

A tabela a seguir mostra quais ferramentas
você pode usar com tipos comuns de aplicativos Dart.

{% assign y = '<span class="material-symbols user-select-none" title="Supported" aria-label="Supported">done</span>' %}
{% assign b = '&nbsp;' %}
{% assign na = '&nbsp;' %}
{% comment %}
  Considered using this instead:
  assign b = '<span class="material-symbols" title="use browser tools instead">web</span>'
{% endcomment %}

| Ferramenta            | [Flutter mobile ou desktop][Flutter devtools] | [Flutter web][Flutter devtools] | [Outra web][] | [Linha de comando][] |
|-----------------------|:---------------------------------------------:|:-------------------------------:|:-------------:|:----------------:|
| [Debugger][]          |                     {{y}}                     |              {{y}}              |     {{y}}     |      {{y}}       |
| [Logging view]        |                     {{y}}                     |              {{y}}              |     {{y}}     |      {{y}}       |
| [App size tool][]     |                     {{y}}                     |                                 |               |      {{y}}       |
| [CPU profiler][]      |                     {{y}}                     |                                 |               |      {{y}}       |
| [Memory view][]       |                     {{y}}                     |                                 |               |      {{y}}       |
| [Network view][]      |                     {{y}}                     |                                 |               |      {{y}}       |
| [Performance view][]  |                     {{y}}                     |                                 |               |      {{y}}       |
| [Flutter inspector][] |                     {{y}}                     |              {{y}}              |               |                  |

{:.table .table-striped .nowrap}

Para informações sobre usar Dart DevTools com cada tipo de aplicativo
(por exemplo, aplicativos de linha de comando),
clique no tipo de aplicativo na linha superior.
Para detalhes sobre ferramentas individuais
(por exemplo, o debugger),
clique no nome da ferramenta na coluna esquerda.

Como a tabela mostra, o debugger e a visualização de logging
são as únicas partes do Dart DevTools que estão disponíveis para todos os tipos de aplicativos.
Aplicativos web não podem usar as visualizações de timeline, memória e desempenho;
em vez disso, eles podem usar ferramentas do navegador como o [Chrome DevTools.][]
O Flutter inspector funciona apenas para aplicativos Flutter;
outros aplicativos web devem usar ferramentas do navegador como o Chrome DevTools.


## Usando DevTools com um aplicativo de linha de comando

Você pode usar DevTools para realizar depuração em nível de código fonte
ou para visualizar informações gerais de log e diagnóstico
de um aplicativo de linha de comando em execução.


### 1. Iniciar o aplicativo alvo

Use o comando `dart run --observe` para executar o arquivo principal
do aplicativo Dart de linha de comando que você deseja depurar ou observar.
Opcionalmente adicione `--pause-isolates-on-start`,
que interrompe automaticamente a execução no início do script.

```console
$ cd path/to/dart/app
$ dart run --pause-isolates-on-start --observe main.dart

The Dart VM service is listening on http://127.0.0.1:8181/afZySiNbDPg=/
The Dart DevTools debugger and profiler is available at: http://127.0.0.1:8181/afZySiNbDPg=/devtools/#/?uri=ws%3A%2F%2F127.0.0.1%3A8181%2FafZySiNbDPg%3D%2Fws
```

Observe a URL do **Dart DevTools debugger and profiler**.
Você precisará dela no próximo passo.

:::important
Esta URL contém um token de segurança e
é diferente para cada execução do seu aplicativo.
Se você parar seu aplicativo e executá-lo novamente,
então você precisa conectar ao DevTools com a nova URL.
:::

### 2. Abrir DevTools e conectar ao aplicativo alvo

Copie a URL do **Dart DevTools debugger and profiler**,
e cole-a na barra de endereços de uma janela do navegador Chrome.

Quando você visita essa URL no Chrome,
a interface do Dart DevTools aparece,
exibindo informações sobre o aplicativo alvo.
Clique em **Debugger** para começar a depurar o aplicativo.


## Usando DevTools com um aplicativo Flutter

Para detalhes sobre usar DevTools com um aplicativo Flutter para qualquer plataforma
(incluindo web) consulte a
[documentação do DevTools em flutter.dev.][Flutter devtools]


## Usando DevTools com um aplicativo web não-Flutter

Para executar um aplicativo web para que você possa usar Dart DevTools,
use o comando `webdev serve` com a flag `--debug` ou `--debug-extension`:

```console
$ webdev serve --debug
```

Para mais informações, consulte [Depurando aplicativos web Dart][].

[App size tool]: {{site.flutter-docs}}/tools/devtools/app-size
[Chrome DevTools.]: https://developer.chrome.com/docs/devtools/
[Command-line]: #using-devtools-with-a-command-line-app
[Linha de comando]: #using-devtools-with-a-command-line-app
[CPU profiler]: {{site.flutter-docs}}/tools/devtools/cpu-profiler
[Debugger]: {{site.flutter-docs}}/tools/devtools/debugger
[Debugging Dart web apps]: /web/debugging
[Depurando aplicativos web Dart]: /web/debugging
[Flutter inspector]: {{site.flutter-docs}}/tools/devtools/inspector
[Flutter devtools]: {{site.flutter-docs}}/tools/devtools/overview
[Logging view]: {{site.flutter-docs}}/tools/devtools/logging
[Memory view]: {{site.flutter-docs}}/tools/devtools/memory
[Network view]: {{site.flutter-docs}}/tools/devtools/network
[Other web]: #using-devtools-with-a-non-flutter-web-app
[Outra web]: #using-devtools-with-a-non-flutter-web-app
[Performance view]: {{site.flutter-docs}}/tools/devtools/performance
[Timeline view]: {{site.flutter-docs}}/tools/devtools/timeline
