---
title: Get the Dart SDK
shortTitle: Get Dart
description: >-
  Get the libraries and command-line tools that you need to develop
  Dart web, command-line, and server apps.
channelList: [Stable, Beta, Dev]
---

Esta página descreve como baixar o SDK do Dart.
O SDK do Dart inclui as bibliotecas e as ferramentas de linha de comando que
você precisa para desenvolver aplicativos Dart para linha de comando, servidor e web.

The Dart team supports only the latest stable release of the SDK.
For full details on the SDK release lifecycle and supported versions,
check out the [SDK support policy](/tools/sdk#support-policy).

To learn more about the Dart SDK, consult the [Dart SDK overview](/tools/sdk).

:::tip
Se você instalou ou planeja [instalar o SDK do Flutter][install-flutter], ele
inclui o SDK completo do Dart. Você não precisa instalar o Dart separadamente e pode pular este guia.
:::

## Requisitos do sistema {:#system-requirements}

O Dart suporta as seguintes arquiteturas de hardware e versões de plataforma
para desenvolver e executar código Dart.

{% assign yes = '<span class="material-symbols system-support" style="color: #158477" aria-label="Supported" title="Supported">verified</span>' %}
{% assign no = '<span class="material-symbols system-support" style="color: #D43324" aria-label="Not supported" title="Not supported">dangerous</span>' %}
{% assign dep = '<span class="material-symbols system-support" style="color: #EF6C00" aria-label="Deprecated" title="Deprecated">error</span>' %}
{% assign rem = '<span class="material-symbols system-support" style="color: #E25012" aria-label="Final deprecation" title="Final deprecation">report</span>' %}
{% assign na = '<span class="material-symbols system-support" style="color: #DADCE0" aria-label="Does not exist" title="Does not exist">do_not_disturb_on</span>' %}

| Platform |   x64   | IA32 (x86) |  Arm32  |  Arm64  | RISC-V (RV64GC) | OS Versions                                                                                                                                                                                                  |
|----------|:-------:|:----------:|:-------:|:-------:|:---------------:|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Windows  | {{yes}} |   {{no}}   | {{no}}  | {{yes}} |     {{na}}      | [Windows 11][], [Windows 10][]                                                                                                                                                                               |
| Linux    | {{yes}} |   {{no}}   | {{yes}} | {{yes}} |     {{yes}}     | [Debian stable][],<br>[Ubuntu LTS][] under standard support                                                                                                                                                  |
| macOS    | {{yes}} |   {{no}}   | {{na}}  | {{yes}} |     {{na}}      | Latest three versions of macOS:<br>{% for version in supportedMacosVersions limit:3 %}[{{version.codename}}]({{version.link}}) ({{version.cycle}}){%- unless forloop.last -%}, {% endunless -%} {% endfor %} |

{:.table .table-striped}

{{yes}} Suportado em todos os canais.<br>
{{dep}} O suporte está descontinuado e pode ser removido em uma versão futura do Dart.<br>
{{rem}} O suporte está descontinuado e provavelmente será removido na próxima versão estável.<br>
{{no}} Não suportado em todos os canais.<br>
{{na}} Não suportado pelo sistema operacional.<br>

[Windows 10]: https://www.microsoft.com/en-us/software-download/windows10
[Windows 11]: https://www.microsoft.com/en-us/software-download/windows11
[Debian stable]: https://www.debian.org/releases
[Ubuntu LTS]: https://wiki.ubuntu.com/Releases

## Choose an installation option

Para instalar e atualizar o SDK do Dart a partir do canal estável,
escolha uma das seguintes opções:

1. [Use um gerenciador de pacotes](#install) (Recomendado).

1. Use uma [imagem Docker do Dart][dart-docker].

1. [Instale o Flutter][install-flutter]. 
   Se você instalou ou planeja [instalar o SDK do Flutter][install-flutter],
   ele inclui o SDK completo do Dart. O SDK do Flutter inclui a
   ferramenta CLI [`dart`](/tools/dart-tool) na pasta `bin` do Flutter.

1. Baixe um arquivo ZIP do [Arquivo do SDK](/get-dart/archive).

1. [Compile o SDK a partir do código-fonte][build-source].

:::warning Notice
{% render 'install/sdk-terms.md' %}
:::

{% comment %}
NOTA para os editores: Mantenha o link do arquivo zip como a última coisa no parágrafo,
para que seja fácil de encontrar (mas não mais tentador do que os gerenciadores de pacotes).
{% endcomment %}

## Instale o SDK do Dart {:#install}

Para instalar o SDK do Dart,
use o gerenciador de pacotes apropriado para sua plataforma de desenvolvimento.

Para atualizar o SDK do Dart,
execute o mesmo comando para instalar o SDK do Dart do seu gerenciador de pacotes.

<Tabs key="dev-os" wrapped="true">
  <Tab name="Windows">

  {% render 'install/windows.md', site: site %}

  </Tab>
  <Tab name="Linux">

  {% render 'install/linux.md', site: site %}

  </Tab>
  <Tab name="macOS">

  {% render 'install/macos.md', site: site %}

  </Tab>
</Tabs>

## Referência de canais de lançamento {:#release-channels}

{% for channel in page.channelList %}
{% assign chnl = channel | downcase -%}
{% assign current="`[calculando]`{:.build-rev-" | append: chnl | append: "}" %}
{% case chnl %}
{% when 'stable' %}
{% assign verstring = "`x.y.z`" %}
{% assign examples = "`1.24.3` e `2.1.0`" %}
{% assign schedule = "a cada três meses" %}
{% assign version-use = "construir e implantar aplicativos de produção" %}
{% when 'beta' %}
{% assign verstring = "`x.y.z-a.b.beta`" %}
{% assign examples = "`2.8.0-20.11.beta` e `3.3.0-205.1.beta`" %}
{% assign verdesc = "pré-lançamento" %}
{% assign schedule = "uma vez por mês" %}
{% assign version-use = "testar a compatibilidade do seu aplicativo com as futuras versões estáveis" %}
{% when 'dev' %}
{% assign verstring = "`x.y.z-a.b.dev`" %}
{% assign examples = "`2.8.0-20.11.dev` e `3.2.12-15.33.dev`" %}
{% assign verdesc = "desenvolvimento" %}
{% assign schedule = "duas vezes por semana" %}
{% assign version-use = "testar correções recentes e recursos experimentais" %}
{% endcase %}

### Canal {{channel}}

O Dart publica uma nova versão no canal *{{chnl}}* aproximadamente {{schedule}}.
A versão atual do canal {{chnl}} é {{current}}.

Use as versões do canal **{{chnl}}** para {{version-use}}.

As strings de versão de lançamento do canal **{{channel}}** seguem um formato {{verstring}}:

* `x` : versão principal
* `y` : versão secundária
* `z` : versão de correção
{%- if chnl != 'stable' %}
* `a` : versão de {{verdesc}}
* `b` : versão de correção de {{verdesc}}
{% endif %}

Exemplos de strings de versão do canal {{chnl}} incluem {{examples}}.

Para instalar uma versão do canal {{chnl}},
{%- if chnl != 'stable' %}
baixe o [SDK como um arquivo zip][dl-sdk].
{%- else %}
siga as [instruções nesta página](#install).
{% endif %}

{% endfor -%}

[build-source]: {{site.repo.dart.sdk}}/wiki/Building
[dart-docker]: https://hub.docker.com/_/dart
[dl-sdk]: /get-dart/archive
[install-flutter]: {{site.flutter-docs}}/get-started/install
