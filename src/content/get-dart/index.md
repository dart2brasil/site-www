---
ia-translate: true
title: Obtenha o Dart SDK
shortTitle: Obtenha o Dart
description: >-
  Obtenha as bibliotecas e ferramentas de linha de comando necessárias para desenvolver
  aplicações web, de linha de comando e servidor em Dart.
channelList: [Stable, Beta, Dev]
---

Esta página descreve como baixar o Dart SDK.
O Dart SDK inclui as bibliotecas e ferramentas de linha de comando
necessárias para desenvolver aplicações de linha de comando, servidor e web em Dart.

O time do Dart suporta apenas a versão stable mais recente do SDK.
Para detalhes completos sobre o ciclo de vida das versões do SDK e versões suportadas,
consulte a [política de suporte do SDK](/tools/sdk#support-policy).

Para saber mais sobre o Dart SDK, consulte a [visão geral do Dart SDK](/tools/sdk).

:::tip
Se você já instalou ou planeja [instalar o Flutter SDK][install-flutter], ele
inclui o Dart SDK completo. Você não precisa instalar o Dart separadamente e pode pular este guia.
:::

## Requisitos do sistema

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
{{rem}} O suporte está descontinuado e provavelmente será removido na próxima versão stable.<br>
{{no}} Não suportado em todos os canais.<br>
{{na}} Não suportado pelo sistema operacional.<br>

[Windows 10]: https://www.microsoft.com/en-us/software-download/windows10
[Windows 11]: https://www.microsoft.com/en-us/software-download/windows11
[Debian stable]: https://www.debian.org/releases
[Ubuntu LTS]: https://wiki.ubuntu.com/Releases

## Escolha uma opção de instalação

Para instalar e atualizar o Dart SDK do canal stable,
escolha uma das seguintes opções:

1. [Use um gerenciador de pacotes](#install) (Recomendado).

1. Use uma [imagem Docker do Dart][dart-docker].

1. [Instale o Flutter][install-flutter].
   Se você já instalou ou planeja [instalar o Flutter SDK][install-flutter],
   ele inclui o Dart SDK completo. O Flutter SDK inclui a
   ferramenta CLI [`dart`](/tools/dart-tool) na pasta `bin` do Flutter.

1. Baixe um arquivo ZIP do [Arquivo do SDK](/get-dart/archive).

1. [Compile o SDK a partir do código-fonte][build-source].

:::warning Notice
{% render 'install/sdk-terms.md' %}
:::

{% comment %}
NOTE to editors: Keep the zip file link as the last thing in the paragraph,
so it's easy to find (but not more tempting than package managers).
{% endcomment %}

## Instale o Dart SDK {:#install}

Para instalar o Dart SDK,
use o gerenciador de pacotes apropriado para sua plataforma de desenvolvimento.

Para atualizar o Dart SDK,
execute o mesmo comando para instalar o Dart SDK do seu gerenciador de pacotes.

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

## Referência de canais de versão {:#release-channels}

{% for channel in page.channelList %}
{% assign chnl = channel | downcase -%}
{% assign current="`[calculating]`{:.build-rev-" | append: chnl | append: "}" %}
{% case chnl %}
{% when 'stable' %}
{% assign verstring = "`x.y.z`" %}
{% assign examples = "`1.24.3` and `2.1.0`" %}
{% assign schedule = "every three months" %}
{% assign version-use = "building and deploying production apps" %}
{% when 'beta' %}
{% assign verstring = "`x.y.z-a.b.beta`" %}
{% assign examples = "`2.8.0-20.11.beta` and `3.3.0-205.1.beta`" %}
{% assign verdesc = "pre-release" %}
{% assign schedule = "once a month" %}
{% assign version-use = "testing your app's compatibility with future stable versions" %}
{% when 'dev' %}
{% assign verstring = "`x.y.z-a.b.dev`" %}
{% assign examples = "`2.8.0-20.11.dev` and `3.2.12-15.33.dev`" %}
{% assign verdesc = "development" %}
{% assign schedule = "twice a week" %}
{% assign version-use = "testing recent fixes and experimental features" %}
{% endcase %}

### Canal {{channel}}

O Dart publica uma nova versão no canal *{{chnl}}* aproximadamente {{schedule}}.
A versão {{chnl}} atual é {{current}}.

Use versões do canal **{{chnl}}** para {{version-use}}.

As strings de versão do canal **{{channel}}** seguem o formato {{verstring}}:

* `x` : versão major
* `y` : versão minor
* `z` : versão patch
{%- if chnl != 'stable' %}
* `a` : versão {{verdesc}}
* `b` : versão patch {{verdesc}}
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
