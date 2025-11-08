---
title: dart pub
description: >-
  The command-line interface for pub, a package management tool for Dart.
ia-translate: true
---

O [gerenciador de pacotes pub](/tools/pub/packages) tem uma interface de linha de comando
que funciona com a
[ferramenta `flutter`][flutter-cli] ou a [ferramenta `dart`][dart-cli].
Com qualquer uma das ferramentas, adicione o comando `pub` seguido de
um subcomando como `get`:

```console
$ dart pub get    # Gets dependencies for a non-Flutter package
$ flutter pub get # Gets dependencies for a Flutter package
```

Este site usa `dart pub <subcommand>` para seus exemplos,
mas se o seu diretório atual contém um app Flutter
ou outro código específico do Flutter,
use `flutter pub <subcommand>` em vez disso.
Para mais informações, veja
[Using packages]({{site.flutter-docs}}/development/packages-and-plugins/using-packages)
no [site do Flutter]({{site.flutter}}).

[flutter-cli]: {{site.flutter-docs}}/reference/flutter-cli
[dart-cli]: /tools/dart-tool

:::version-note
O comando `dart pub` estreou no Dart 2.10.
Embora você ainda possa encontrar exemplos de
uso do comando `pub` autônomo em vez de
`dart pub` ou `flutter pub`,
o comando `pub` autônomo foi removido.
:::

Se você encontrar problemas ao usar a ferramenta pub,
veja [Troubleshooting Pub](/tools/pub/troubleshoot).


## Lista de subcomandos

Documentação detalhada existe para cada um dos seguintes subcomandos do pub:

{% render 'pub-subcommands.md' %}

## Visão geral dos subcomandos

Os subcomandos do Pub se enquadram nas seguintes categorias:

* [Gerenciando dependências de pacotes](#managing-package-dependencies)
* [Executando apps de linha de comando](#running-command-line-apps)
* [Implantando pacotes e apps](#deploying-packages-and-apps)


<a id="managing-apps"></a>
### Gerenciando dependências de pacotes {:#managing-package-dependencies}

O Pub fornece vários subcomandos para gerenciar os
[pacotes dos quais seu código depende](/tools/pub/dependencies).

Neste grupo, os subcomandos mais usados são `get` e
`upgrade`, que recuperam ou atualizam dependências usadas por um pacote.
Toda vez que você modificar um arquivo pubspec,
execute `dart pub get` ou `flutter pub get`
para garantir que as dependências estejam atualizadas. Algumas IDEs
executam esta etapa automaticamente na criação de um projeto,
ou qualquer modificação do pubspec.

[`cache`](/tools/pub/cmd/pub-cache)
: Gerencia o cache de pacotes local do pub. Use este subcomando para adicionar pacotes
  ao seu cache, ou para realizar uma reinstalação limpa de todos os pacotes no
  seu cache.

[`deps`](/tools/pub/cmd/pub-deps)
: Lista todas as dependências usadas pelo pacote atual.

[`downgrade`](/tools/pub/cmd/pub-downgrade)
: Recupera as versões mais baixas de todos os pacotes que estão
  listados como dependências usadas pelo pacote atual. Usado para testar
  a faixa inferior das dependências do seu pacote.

[`get`](/tools/pub/cmd/pub-get)
: Recupera os pacotes que estão listados como dependências para
  o pacote atual.
  Se um arquivo `pubspec.lock` já existir, busca a versão
  de cada dependência (se possível) conforme listado no arquivo de bloqueio.
  Cria ou atualiza o arquivo de bloqueio, conforme necessário.

[`outdated`](/tools/pub/cmd/pub-outdated)
: Examina cada pacote do qual o pacote atual depende,
  determina quais dependências de pacotes estão desatualizadas,
  e oferece conselhos sobre como atualizá-las.
  Use este subcomando quando quiser atualizar dependências de pacotes.

[`upgrade`](/tools/pub/cmd/pub-upgrade)
: Recupera a versão mais recente de cada pacote listado
  como dependências usadas pelo pacote atual. Se um arquivo `pubspec.lock`
  existir, ignora as versões listadas no arquivo de bloqueio e busca
  as versões mais recentes que respeitam as restrições no pubspec.
  Cria ou atualiza o arquivo de bloqueio, conforme necessário.


### Executando apps de linha de comando {:#running-command-line-apps}

O subcomando [`global`](/tools/pub/cmd/pub-global) permite que você
torne um pacote globalmente disponível,
para que você possa executar scripts do diretório `bin` desse pacote.
Para executar scripts globalmente disponíveis, você deve
[adicionar o diretório `bin` do cache do sistema ao seu path][add-path].

[add-path]: /tools/pub/cmd/pub-global#running-a-script-from-your-path

### Implantando pacotes e apps {:#deploying-packages-and-apps}

Com o pub você pode publicar pacotes e apps de linha de comando.

#### Pacotes

Para compartilhar seus pacotes Dart com o mundo, você pode
usar o subcomando [`publish`](/tools/pub/cmd/pub-lish) para fazer upload do
pacote para o [site pub.dev]({{site.pub}}).
Para informações sobre como permitir que outros usuários
modifiquem e façam upload de novas versões do seu pacote,
veja [Uploaders](/tools/pub/publishing#uploaders).


#### Apps de linha de comando

Para qualquer pacote que contenha scripts (qualquer coisa sob o diretório `bin/`),
considere adicionar a tag `executables` ao arquivo pubspec.
Quando um script está listado em `executables`, os usuários podem executar
[`dart pub global activate`](/tools/pub/cmd/pub-global#activating-a-package)
para torná-lo diretamente disponível na linha de comando.


## Opções globais {:#global-options}

Várias opções de linha de comando funcionam com todos os subcomandos do pub.
Estas incluem:

### `--help` ou `-h`

Imprime informações de uso.

### `--trace`

Imprime informações de depuração quando ocorre um erro.

### `--verbose` ou `-v`

Equivalente a `--verbosity=all`.

### `--directory=<dir>` ou `-C <dir>`

Executa o comando no diretório especificado.

### `--[no-]color`

Adiciona cor à saída para ênfase (`--color`).
O padrão depende se você está usando este comando em um terminal.
Em um terminal, `--color` é o padrão,
caso contrário, `--no-color` é o padrão.
Use `--no-color` para desabilitar cor em todos os ambientes.

