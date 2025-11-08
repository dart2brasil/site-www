---
ia-translate: true
title: dart pub get
description: "Use dart pub get para recuperar as dependências usadas pela sua aplicação Dart."
---

_Get_ (obter) é um dos comandos da [ferramenta pub](/tools/pub/cmd).

```plaintext
$ dart pub get [opções]
```

This command gets all the dependencies listed in the
[`pubspec.yaml`](/tools/pub/pubspec) file in the current working
directory, as well as their
[transitive dependencies](/resources/glossary#transitive-dependency).
For example:

```console
$ dart pub get
Resolvendo dependências...
Obteve as dependências!
```

If the [system cache](/resources/glossary#pub-system-cache)
doesn't already contain the dependencies, `dart pub get`
updates the cache,
downloading dependencies if necessary.
To map packages back to the system cache,
this command creates a `package_config.json` file
in the `.dart_tool/` directory.

Uma vez que as dependências são adquiridas, elas podem ser referenciadas no código Dart.
Por exemplo, se um pacote depende de `test`:

```dart
import 'package:test/test.dart';
```

When `dart pub get` gets new dependencies, it writes a
[lockfile](/resources/glossary#lockfile) to ensure that future
gets will use the same versions of those dependencies.
[Application packages][] should check in the lockfile to source control;
this ensures the application will use the exact same versions
of all dependencies for all developers and when deployed to production.
Regular packages should not check in the lockfile, though, since they're
expected to work with a range of dependency versions.

If a lockfile already exists, `dart pub get` uses the versions of dependencies
locked in it if possible. If a dependency isn't locked, pub gets the
latest version of that dependency that satisfies all the [version
constraints](/resources/glossary#version-constraint).
This is the primary difference between `dart pub get` and
[`dart pub upgrade`](/tools/pub/cmd/pub-upgrade), which always tries to
get the latest versions of all dependencies.

[Application packages]: /resources/glossary#application-package

## Resolução de Pacotes {:#package-resolution}

Por padrão, o pub cria um arquivo `package_config.json`
no diretório `.dart_tool/` que mapeia de nomes de pacotes para URIs de localização.

:::note
Não inclua o diretório gerado `.dart_tool/` no seu repositório;
adicione-o ao arquivo `.gitignore` do seu repositório.
Para mais informações,
veja [O que não commitar](/tools/pub/private-files).
:::


## Obtendo uma nova dependência {:#getting-a-new-dependency}

Se uma dependência é adicionada ao pubspec e então `dart pub get` é executado,
ele obtém a nova dependência e todas as suas dependências transitivas.
No entanto, o pub não irá alterar as versões de quaisquer
dependências já adquiridas, a menos que seja necessário para obter a nova dependência.


## Removendo uma dependência {:#removing-a-dependency}

Se uma dependência é removida do pubspec e então `dart pub get` é executado,
a dependência não estará mais disponível para importação.
Quaisquer dependências transitivas da dependência removida também são removidas,
contanto que nenhuma dependência imediata restante também dependa delas.
A remoção de uma dependência nunca altera as versões de quaisquer
dependências já adquiridas.


## O cache de pacotes do sistema {:#the-system-package-cache}

Dependencies downloaded over the internet, such as those from Git and the
[pub.dev site]({{site.pub}}), are stored in a
[system-wide cache](/resources/glossary#pub-system-cache).
This means that if multiple packages use the same version of the
same dependency, it only needs to be
downloaded and stored locally once.

Por padrão, o cache de pacotes do sistema está localizado no subdiretório `.pub-cache`
do seu diretório home (no macOS e Linux),
ou em `%LOCALAPPDATA%\Pub\Cache` (no Windows;
a localização pode variar dependendo da versão do Windows).
Você pode configurar a localização do cache definindo a
variável de ambiente [`PUB_CACHE`](/tools/pub/environment-variables)
antes de executar o pub.


## Obtendo estando offline {:#getting-while-offline}

Se você não tiver acesso à rede, você ainda pode executar `dart pub get`.
Como o pub baixa os pacotes para um cache central compartilhado por todos os pacotes
em seu sistema, ele pode muitas vezes encontrar pacotes baixados anteriormente
sem a necessidade de usar a rede.

No entanto, por padrão, `dart pub get` tenta se conectar se você
tiver alguma dependência hospedada,
para que o pub possa detectar versões mais recentes das dependências.
Se você não quiser que o pub faça isso, passe a flag `--offline`.
No modo offline, o pub procura apenas no seu cache de pacotes local,
tentando encontrar um conjunto de versões que funcionam com o seu pacote a partir do que já está
disponível.

Tenha em mente que o pub gera um lockfile (arquivo de bloqueio). Se a
única versão de alguma dependência em seu cache for antiga,
o `dart pub get` offline irá bloquear seu aplicativo nessa versão antiga.
Da próxima vez que você estiver online, você provavelmente vai querer
executar [`dart pub upgrade`](/tools/pub/cmd/pub-upgrade) para atualizar para uma versão mais recente.


## Opções {:#options}

Para opções que se aplicam a todos os comandos pub, veja
[Opções Globais](/tools/pub/cmd#global-options).

### `--[no-]offline` {:#no-offline}

{% render 'tools/pub-option-no-offline.md' %}

### `--dry-run` ou `-n` {:#dry-run-or-n}

Reporta as dependências que seriam alteradas,
mas não realiza as alterações. Isso é útil se você
quiser analisar as atualizações antes de fazê-las.

### `--[no-]precompile` {:#no-precompile}

Por padrão, o pub pré-compila executáveis
em dependências imediatas (`--precompile`).
Para prevenir a pré-compilação, use `--no-precompile`.

### `--enforce-lockfile` {:#enforce-lockfile}

Reforça a resolução do `pubspec.lock` atual.

Falha no `pub get` com uma mensagem de erro se o `pubspec.lock` não especificar
exatamente uma resolução válida de `pubspec.yaml` ou
se algum hash de conteúdo de um pacote hospedado tiver sido alterado.

Útil para CI ou implantação em produção.

Leia [Obter dependências para produção](/tools/pub/packages#get-dependencies-for-production)
para mais detalhes.

{% render 'pub-problems.md' %}