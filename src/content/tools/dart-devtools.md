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
você pode usar com tipos comuns de aplicações Dart.

{% assign y = '<span class="material-symbols user-select-none" title="Supported" aria-label="Supported">done</span>' %}
{% assign b = '&nbsp;' %}
{% assign na = '&nbsp;' %}
{% comment %}
  Considered using this instead:
  assign b = '<span class="material-symbols" title="use browser tools instead">web</span>'
{% endcomment %}

| Ferramenta            | [Flutter mobile ou desktop][Flutter devtools] | [Flutter web][Flutter devtools] | [Outras web][Other web] | [Linha de comando][Command-line] |
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

Para informações sobre como usar o Dart DevTools com cada tipo de aplicação
(por exemplo, aplicações de linha de comando),
clique no tipo de aplicação na linha superior.
Para detalhes sobre ferramentas individuais
(por exemplo, o debugger),
clique no nome da ferramenta na coluna da esquerda.

Como a tabela mostra, o debugger e a logging view
são as únicas partes do Dart DevTools disponíveis para todos os tipos de aplicação.
Aplicações web não podem usar as views de timeline, memory e performance;
em vez disso, elas podem usar ferramentas do navegador, como o [Chrome DevTools.][]
O Flutter inspector funciona apenas para aplicações Flutter;
outras aplicações web devem usar ferramentas do navegador, como o Chrome DevTools.

<a id="using-devtools-with-a-command-line-apps" aria-hidden="true"></a>

## Aplicações de linha de comando {:#command-line-apps}

Você pode usar o DevTools para realizar depuração em nível de código-fonte
ou para visualizar informações gerais de log e diagnóstico
de uma aplicação de linha de comando em execução.


### 1. Inicie a aplicação de destino {:#1-start-the-target-app}

Use o comando `dart run --observe` para executar o arquivo principal
da aplicação Dart de linha de comando que você quer depurar ou observar.
Opcionalmente, adicione `--pause-isolates-on-start`,
que interrompe automaticamente a execução no início do script.

```console
$ cd path/to/dart/app
$ dart run --pause-isolates-on-start --observe main.dart

The Dart VM service is listening on http://127.0.0.1:8181/afZySiNbDPg=/
The Dart DevTools debugger and profiler is available at: http://127.0.0.1:8181/afZySiNbDPg=/devtools/#/?uri=ws%3A%2F%2F127.0.0.1%3A8181%2FafZySiNbDPg%3D%2Fws
```

Anote a URL do **Dart DevTools debugger and profiler**.
Você vai precisar dela no próximo passo.

:::important
Esta URL contém um token de segurança e
é diferente a cada execução da sua aplicação.
Se você parar a aplicação e executá-la novamente,
precisará se conectar ao DevTools com a nova URL.
:::

### 2. Abra o DevTools e conecte-se à aplicação de destino {:#2-open-devtools-and-connect-to-the-target-app}

Copie a URL do **Dart DevTools debugger and profiler**
e cole-a na barra de endereços de uma janela do Chrome.

Quando você acessar essa URL no Chrome,
a interface do Dart DevTools aparece,
exibindo informações sobre a aplicação de destino.
Clique em **Debugger** para começar a depurar a aplicação.

<a id="command-line-apps" aria-hidden="true"></a>

## Configurações de depuração no VS Code {:#vs-code-debug-configurations}

Configure o VS Code para iniciar aplicações Dart de linha de comando com o DevTools habilitado, para acessar recursos como a view de Timeline.

### Configurações de depuração no VS Code {:#debug-configurations-in-vs-code}

A tabela a seguir mostra exemplos de configurações de depuração do VS Code para aplicações Dart:

| Configuração | `vmAdditionalArgs` | Descrição |
|---------------|---------------------|-------------|
| Depuração padrão do VS Code | `[]` | Depuração padrão. Inclui debugger e logging; exclui dados de timeline. |
| Com streams de timeline | `["--timeline_streams=VM,Isolate,GC"]` | Habilita streams de timeline para o perfil de timeline, memória e performance. |

{:.table .table-striped}

### Exemplo de launch.json {:#example-launch-json}

Para habilitar os eventos de timeline, adicione esta configuração ao seu `.vscode/launch.json`:

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Dart with DevTools Timeline",
      "type": "dart",
      "request": "launch",
      "vmAdditionalArgs": [
        "--timeline_streams=VM,Isolate,GC"
      ],
      "program": "main.dart"
    }
  ]
}
```

Substitua `"main.dart"` pelo caminho do arquivo principal da sua aplicação.

### Conecte o DevTools {:#connect-devtools}

1. Inicie a depuração no VS Code usando a configuração de launch configurada.

2. No Debug Console ou na saída do terminal do VS Code, procure uma linha semelhante a:
   ```
   The Dart DevTools debugger and profiler is available at: http://127.0.0.1:8181/aBcDeFg123=/devtools/#/?uri=...
   ```

3. Copie a URL do DevTools e cole-a em uma janela do Chrome.

4. No DevTools, visualize a timeline, a memória e a performance da sua aplicação em execução.

<a id="using-devtools-with-a-flutter-app" aria-hidden="true"></a>

## Aplicações Flutter {:#flutter-apps}

Para detalhes sobre como usar o DevTools com uma aplicação Flutter em qualquer plataforma
(incluindo web), consulte a
[documentação do DevTools no flutter.dev.][Flutter devtools]

<a id="using-devtools-with-a-non-flutter-web-app" aria-hidden="true"></a>

## Outras aplicações web {:#other-web-apps}

Para iniciar uma aplicação web de modo que você possa usar o Dart DevTools,
use o comando `webdev serve` com a flag `--debug` ou `--debug-extension`:

```console
$ webdev serve --debug
```

Para mais informações, consulte [Depurando aplicações web em Dart][Debugging Dart web apps].

[App size tool]: {{site.flutter-docs}}/tools/devtools/app-size
[Chrome DevTools.]: https://developer.chrome.com/docs/devtools/
[Command-line]: #command-line-apps
[CPU profiler]: {{site.flutter-docs}}/tools/devtools/cpu-profiler
[Debugger]: {{site.flutter-docs}}/tools/devtools/debugger
[Debugging Dart web apps]: /web/debugging
[Flutter inspector]: {{site.flutter-docs}}/tools/devtools/inspector
[Flutter devtools]: {{site.flutter-docs}}/tools/devtools/overview
[Logging view]: {{site.flutter-docs}}/tools/devtools/logging
[Memory view]: {{site.flutter-docs}}/tools/devtools/memory
[Network view]: {{site.flutter-docs}}/tools/devtools/network
[Other web]: #other-web-apps
[Performance view]: {{site.flutter-docs}}/tools/devtools/performance
[Timeline view]: {{site.flutter-docs}}/tools/devtools/timeline
