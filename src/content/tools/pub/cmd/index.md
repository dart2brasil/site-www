---
ia-translate: true
title: dart pub
description: A interface de linha de comando para o pub, uma ferramenta de gerenciamento de pacotes para Dart.
---

O [gerenciador de pacotes pub](/tools/pub/packages) possui uma interface de linha de comando
que funciona tanto com a ferramenta
[`flutter`][flutter-cli] quanto com a ferramenta [`dart`][dart-cli].
Com qualquer uma das ferramentas, adicione o comando `pub` seguido por
um subcomando como `get`:

```console
$ dart pub get    # Obtém dependências para um pacote não-Flutter
$ flutter pub get # Obtém dependências para um pacote Flutter
```

Este site usa `dart pub <subcomando>` para seus exemplos,
mas se seu diretório atual contém um aplicativo Flutter
ou outro código específico do Flutter,
use `flutter pub <subcomando>` em vez disso.
Para mais informações, veja
[Usando pacotes]({{site.flutter-docs}}/development/packages-and-plugins/using-packages)
no [site do Flutter]({{site.flutter}}).

[flutter-cli]: {{site.flutter-docs}}/reference/flutter-cli
[dart-cli]: /tools/dart-tool

:::version-note
O comando `dart pub` estreou no Dart 2.10.
Embora você ainda possa encontrar exemplos de
usar o comando `pub` independente em vez de
`dart pub` ou `flutter pub`,
o comando `pub` independente foi removido.
:::

Se você encontrar problemas ao usar a ferramenta pub,
consulte [Solução de Problemas do Pub](/tools/pub/troubleshoot).


## Lista de subcomandos {:#list-of-subcommands}

Documentação detalhada existe para cada um dos seguintes subcomandos do pub:

{% render 'pub-subcommands.md' %}

## Visão geral dos subcomandos {:#overview-of-subcommands}

Os subcomandos do Pub se dividem nas seguintes categorias:

* [Gerenciando dependências de pacotes](#managing-package-dependencies)
* [Executando aplicativos de linha de comando](#running-command-line-apps)
* [Implantação de pacotes e aplicativos](#deploying-packages-and-apps)


<a id="managing-apps"></a>
### Gerenciando dependências de pacotes {:#managing-package-dependencies}

O Pub fornece vários subcomandos para gerenciar os
[pacotes dos quais seu código depende](/tools/pub/dependencies).

Neste grupo, os subcomandos mais usados são `get` e
`upgrade`, que recuperam ou atualizam as dependências usadas por um pacote.
Sempre que você modifica um arquivo pubspec,
execute `dart pub get` ou `flutter pub get`
para garantir que as dependências estejam atualizadas. Algumas IDEs
realizam esta etapa automaticamente na criação de um projeto,
ou qualquer modificação do pubspec.

[`cache`](/tools/pub/cmd/pub-cache)
: Gerencia o cache local de pacotes do pub. Use este subcomando para adicionar pacotes
  ao seu cache, ou para realizar uma reinstalação limpa de todos os pacotes em
  seu cache.

[`deps`](/tools/pub/cmd/pub-deps)
: Lista todas as dependências usadas pelo pacote atual.

[`downgrade`](/tools/pub/cmd/pub-downgrade)
: Recupera as versões mais baixas de todos os pacotes que estão
  listados como dependências usadas pelo pacote atual. Usado para testar
  o intervalo inferior das dependências do seu pacote.

[`get`](/tools/pub/cmd/pub-get)
: Recupera os pacotes que estão listados como as dependências para
  o pacote atual.
  Se um arquivo `pubspec.lock` já existir, busca a versão
  de cada dependência (se possível) conforme listado no arquivo de lock (travamento).
  Cria ou atualiza o arquivo de lock, conforme necessário.

[`outdated`](/tools/pub/cmd/pub-outdated)
: Examina todos os pacotes dos quais o pacote atual depende,
  determina quais dependências de pacotes estão desatualizadas,
  e lhe dá conselhos sobre como atualizá-las.
  Use este subcomando quando você quiser atualizar as dependências do pacote.

[`upgrade`](/tools/pub/cmd/pub-upgrade)
: Recupera a versão mais recente de cada pacote listado
  como dependências usadas pelo pacote atual. Se um arquivo `pubspec.lock`
  existir, ignora as versões listadas no arquivo de lock e busca
  as versões mais recentes que respeitam as restrições no pubspec.
  Cria ou atualiza o arquivo de lock, conforme necessário.


### Executando aplicativos de linha de comando {:#running-command-line-apps}

O subcomando [`global`](/tools/pub/cmd/pub-global) permite que você
torne um pacote disponível globalmente,
para que você possa executar scripts do diretório `bin` desse pacote.
Para executar scripts disponíveis globalmente, você deve
[adicionar o diretório `bin` do cache do sistema ao seu path (caminho)][add-path].

[add-path]: /tools/pub/cmd/pub-global#running-a-script-from-your-path

### Implantação de pacotes e aplicativos {:#deploying-packages-and-apps}

Com o pub, você pode publicar pacotes e aplicativos de linha de comando.

#### Pacotes {:#packages}

Para compartilhar seus pacotes Dart com o mundo, você pode
usar o subcomando [`publish`](/tools/pub/cmd/pub-lish) para fazer o upload do
pacote para o [site pub.dev]({{site.pub}}).
Para obter informações sobre como permitir que outros usuários
modifiquem e façam upload de novas versões do seu pacote,
consulte [Uploaders](/tools/pub/publishing#uploaders).


#### Aplicativos de linha de comando {:#command-line-apps}

Para qualquer pacote que contenha scripts (qualquer coisa sob o diretório `bin/`),
considere adicionar a tag `executables` ao arquivo pubspec.
Quando um script é listado em `executables`, os usuários podem executar
[`dart pub global activate`](/tools/pub/cmd/pub-global#activating-a-package)
para torná-lo diretamente disponível na linha de comando.


## Opções globais {:#global-options}

Várias opções de linha de comando funcionam com todos os subcomandos do pub.
Estas incluem:

### `--help` ou `-h` {:#help-or-h}

Imprime informações de uso.

### `--trace` {:#trace}

Imprime informações de depuração quando ocorre um erro.

### `--verbose` ou `-v` {:#verbose-or-v}

Equivalente a `--verbosity=all`.

### `--directory=<dir>` ou `-C <dir>` {:#directory-dir-or-c-dir}

Executa o comando no diretório especificado.

### `--[no-]color` {:#no-color}

Adiciona cor à saída para ênfase (`--color`).
O padrão depende se você está usando este comando em um terminal.
Em um terminal, `--color` é o padrão,
caso contrário, `--no-color` é o padrão.
Use `--no-color` para desabilitar a cor em todos os ambientes.
