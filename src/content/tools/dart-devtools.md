---
ia-translate: true
title: Dart DevTools
shortTitle: DevTools
description: A suite of debugging and performance tools.
---

Dart DevTools é um conjunto de ferramentas de depuração e desempenho
para Dart e Flutter.
Essas ferramentas são distribuídas como parte da ferramenta `dart`
e interagem com ferramentas como IDEs, `dart run` e `webdev`.

<img src="/assets/img/tools/devtools.png" width="800" alt="Captura de tela da página de Memória do DevTools">

A tabela a seguir mostra quais ferramentas
você pode usar com tipos comuns de aplicativos Dart.

{% assign y = '<span class="material-symbols user-select-none" title="Suportado" aria-label="Suportado">done</span>' %}
{% assign b = '&nbsp;' %}
{% assign na = '&nbsp;' %}
{% comment %}
  Considerado usar isto em vez disso:
  assign b = '<span class="material-symbols" title="use browser tools instead">web</span>'
{% endcomment %}

| Ferramenta                | [Flutter mobile ou desktop][Flutter devtools] | [Flutter web][Flutter devtools] | [Outra web][Other web] | [Linha de comando][Command-line] |
|--------------------------|:---------------------------------------------:|:-------------------------------:|:-------------:|:-----------------:|
| [Debugger][Debugger]            |                     {{y}}                     |              {{y}}              |     {{y}}     |      {{y}}       |
| [Visualização de logs]   |                     {{y}}                     |              {{y}}              |     {{y}}     |      {{y}}       |
| [Ferramenta de tamanho do app][App size tool] |                     {{y}}                     |                                 |               |      {{y}}       |
| [Profiler de CPU][CPU profiler]   |                     {{y}}                     |                                 |               |      {{y}}       |
| [Visualização de memória][Memory view]    |                     {{y}}                     |                                 |               |      {{y}}       |
| [Visualização de rede][Network view]    |                     {{y}}                     |                                 |               |      {{y}}       |
| [Visualização de desempenho][Performance view]  |                     {{y}}                     |                                 |               |      {{y}}       |
| [Inspetor Flutter][Flutter inspector] |                     {{y}}                     |              {{y}}              |               |                  |

{:.table .table-striped .nowrap}

Para obter informações sobre como usar o Dart DevTools com cada tipo de aplicativo
(por exemplo, aplicativos de linha de comando),
clique no tipo de aplicativo na linha superior.
Para detalhes sobre ferramentas individuais
(por exemplo, o debugger),
clique no nome da ferramenta na coluna da esquerda.

Como a tabela mostra, o debugger e a visualização de logs
são as únicas partes do Dart DevTools que estão disponíveis para todos os tipos de aplicativos.
Aplicativos web não podem usar as visualizações de timeline, memória e desempenho;
em vez disso, eles podem usar ferramentas do navegador, como o [Chrome DevTools.][Chrome DevTools.]
O inspetor Flutter funciona apenas para aplicativos Flutter;
outros aplicativos web devem usar ferramentas do navegador, como o Chrome DevTools.


## Usando o DevTools com um aplicativo de linha de comando {:#using-devtools-with-a-command-line-app}

Você pode usar o DevTools para realizar depuração em nível de código-fonte
ou para visualizar informações gerais de log e diagnóstico
para um aplicativo de linha de comando em execução.


### 1. Inicie o aplicativo de destino {:#1-start-the-target-app}

Use o comando `dart run --observe` para executar o arquivo principal
para o aplicativo de linha de comando Dart que você deseja depurar ou observar.
Opcionalmente, adicione `--pause-isolates-on-start`,
que interrompe automaticamente a execução no início do script.

```console
$ cd caminho/para/o/app/dart
$ dart run --pause-isolates-on-start --observe main.dart

O serviço Dart VM está escutando em http://127.0.0.1:8181/afZySiNbDPg=/
O debugger e profiler Dart DevTools está disponível em: http://127.0.0.1:8181/afZySiNbDPg=/devtools/#/?uri=ws%3A%2F%2F127.0.0.1%3A8181%2FafZySiNbDPg%3D%2Fws
```

Observe o URL do **debugger e profiler Dart DevTools**.
Você precisará dele na próxima etapa.

:::important
Este URL contém um token de segurança e
é diferente para cada execução do seu aplicativo.
Se você parar seu aplicativo e executá-lo novamente,
você precisa se conectar ao DevTools com o novo URL.
:::

### 2. Abra o DevTools e conecte-se ao aplicativo alvo {:#2-open-devtools-and-connect-to-the-target-app}

Copie o URL do **debugger e profiler Dart DevTools**,
e cole-o na barra de endereço de uma janela do navegador Chrome.

Quando você visita esse URL no Chrome,
a interface do usuário do Dart DevTools aparece,
exibindo informações sobre o aplicativo alvo.
Clique em **Debugger** para iniciar a depuração do aplicativo.


## Usando o DevTools com um aplicativo Flutter {:#using-devtools-with-a-flutter-app}

Para obter detalhes sobre como usar o DevTools com um aplicativo Flutter para qualquer plataforma
(incluindo web), consulte a
[documentação do DevTools em flutter.dev.][Flutter devtools]


## Usando o DevTools com um aplicativo web não-Flutter {:#using-devtools-with-a-non-flutter-web-app}

Para iniciar um aplicativo web para que você possa usar o Dart DevTools,
use o comando `webdev serve` com a flag `--debug` ou `--debug-extension`:

```console
$ webdev serve --debug
```

Para mais informações, consulte [Depurando aplicativos web Dart][Debugging Dart web apps].

[App size tool]: {{site.flutter-docs}}/tools/devtools/app-size
[Chrome DevTools.]: https://developer.chrome.com/docs/devtools/
[Command-line]: #using-devtools-with-a-command-line-app
[CPU profiler]: {{site.flutter-docs}}/tools/devtools/cpu-profiler
[Debugger]: {{site.flutter-docs}}/tools/devtools/debugger
[Debugging Dart web apps]: /web/debugging
[Flutter inspector]: {{site.flutter-docs}}/tools/devtools/inspector
[Flutter devtools]: {{site.flutter-docs}}/tools/devtools/overview
[Logging view]: {{site.flutter-docs}}/tools/devtools/logging
[Memory view]: {{site.flutter-docs}}/tools/devtools/memory
[Network view]: {{site.flutter-docs}}/tools/devtools/network
[Other web]: #using-devtools-with-a-non-flutter-web-app
[Performance view]: {{site.flutter-docs}}/tools/devtools/performance
[Timeline view]: {{site.flutter-docs}}/tools/devtools/timeline
