---
ia-translate: true
title: dart pub get
description: >-
  Use dart pub get para recuperar as dependências usadas pela sua aplicação Dart.
---

_Get_ (obter) é um dos comandos da [ferramenta pub](/tools/pub/cmd).

```plaintext
$ dart pub get [opções]
```

Este comando obtém todas as dependências listadas no arquivo
[`pubspec.yaml`](/tools/pub/pubspec) no diretório de trabalho atual,
bem como suas
[dependências transitivas](/tools/pub/glossary#transitive-dependency).
Por exemplo:

```console
$ dart pub get
Resolvendo dependências...
Obteve as dependências!
```

Se o [cache do sistema](/tools/pub/glossary#system-cache)
já não contém as dependências, `dart pub get`
atualiza o cache,
baixando as dependências se necessário.
Para mapear os pacotes de volta ao cache do sistema,
este comando cria um arquivo `package_config.json`
no diretório `.dart_tool/`.

Uma vez que as dependências são adquiridas, elas podem ser referenciadas no código Dart.
Por exemplo, se um pacote depende de `test`:

```dart
import 'package:test/test.dart';
```

Quando `dart pub get` obtém novas dependências, ele grava um
[lockfile (arquivo de bloqueio)](/tools/pub/glossary#lockfile) para garantir que futuras
obtenções usem as mesmas versões dessas dependências.
[Pacotes de aplicação][] devem verificar o lockfile no controle de código fonte;
isso garante que a aplicação usará as mesmas versões exatas
de todas as dependências para todos os desenvolvedores e quando implantada em produção.
Pacotes regulares não devem verificar o lockfile, no entanto, já que eles
devem funcionar com uma variedade de versões de dependência.

Se um lockfile já existe, `dart pub get` usa as versões das dependências
bloqueadas nele, se possível. Se uma dependência não está bloqueada, o pub obtém a
versão mais recente dessa dependência que satisfaz todas as [restrições
de versão](/tools/pub/glossary#version-constraint).
Esta é a principal diferença entre `dart pub get` e
[`dart pub upgrade`](/tools/pub/cmd/pub-upgrade), que sempre tenta
obter as versões mais recentes de todas as dependências.

[Pacotes de aplicação]: /tools/pub/glossary#application-package

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

Dependências baixadas pela internet, como as do Git e do
[site pub.dev]({{site.pub}}), são armazenadas em um
[cache em todo o sistema](/tools/pub/glossary#system-cache).
Isso significa que se vários pacotes usam a mesma versão da
mesma dependência, ela só precisa ser
baixada e armazenada localmente uma vez.

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