---
ia-translate: true
title: dart pub downgrade
description: Use dart pub downgrade para obter as versões mais baixas de todas as dependências usadas pelo seu aplicativo Dart.
---

_Downgrade_ é um dos comandos da [ferramenta pub](/tools/pub/cmd).

```plaintext
$ dart pub downgrade [--[no-]offline] [-n|--dry-run] [dependencies...] 
```

Sem argumentos adicionais, `dart pub downgrade` obtém as versões mais baixas de
todas as dependências listadas no arquivo [`pubspec.yaml`](/tools/pub/pubspec)
no diretório de trabalho atual, além de suas [dependências
transitivas](/resources/glossary#transitive-dependency).
Por exemplo:

```console
$ dart pub downgrade
Resolving dependencies... (1.2s)
+ barback 0.13.0
+ collection 0.9.1
+ path 1.2.0
+ source_maps 0.9.0
+ source_span 1.0.0
+ stack_trace 0.9.1
Changed 6 dependencies!
```

O comando `dart pub downgrade` cria um arquivo de bloqueio. Se ele já existir,
o pub ignora esse arquivo e gera um novo do zero, usando as versões mais baixas
de todas as dependências.

Veja a [documentação de `dart pub get`](/tools/pub/cmd/pub-get) para mais informações
sobre resolução de pacotes e o cache de pacotes do sistema.


## Fazer downgrade de dependências específicas {:#downgrading-specific-dependencies}

É possível dizer ao `dart pub downgrade` para fazer downgrade de dependências específicas para a
versão mais baixa, mantendo as demais dependências o mais inalteradas possível. Por exemplo:

```console
$ dart pub downgrade test
Resolving dependencies...
  barback 0.15.2+2
  bot 0.27.0+2
  browser 0.10.0+2
  chrome 0.6.5
  collection 1.1.0
  path 1.3.0
  pool 1.0.1
  source_span 1.0.2
< stack_trace 0.9.2 (was 1.1.1)
  stagexl 0.10.2
< test 0.10.0 (was 0.11.4)
These packages are no longer being depended on:
- matcher 0.11.3
Changed 3 dependencies!
```

Se você estiver fazendo downgrade de uma dependência específica, o pub tenta encontrar as
versões mais altas de quaisquer dependências transitivas que se encaixem nas novas
restrições de dependência. Essas dependências transitivas geralmente também sofrem downgrade
como resultado.


## Obter uma nova dependência {:#getting-a-new-dependency}

Se uma dependência for adicionada ao pubspec antes de `dart pub downgrade` ser executado,
ela obtém a nova dependência e quaisquer das suas dependências transitivas.
Isso tem o mesmo comportamento de `dart pub get`.


## Remover uma dependência {:#removing-a-dependency}

Se uma dependência for removida do pubspec antes de `dart pub downgrade` ser executado,
a dependência deixa de estar disponível para importação.
Quaisquer dependências transitivas da dependência removida também são removidas,
desde que nenhuma dependência imediata restante também dependa delas.
Este é o mesmo comportamento de `dart pub get`.


## Fazer downgrade offline {:#downgrading-while-offline}

Se você não tiver acesso à rede, ainda pode executar `dart pub downgrade`.
Como o pub baixa pacotes para um cache central compartilhado por todos os pacotes
do seu sistema, ele muitas vezes consegue encontrar pacotes baixados anteriormente
sem precisar usar a rede.

No entanto, por padrão, `dart pub downgrade` tenta acessar a internet se você
tiver qualquer dependência hospedada.
Se você não quiser que o pub faça isso, passe a flag `--offline`.
No modo offline, o pub procura apenas no cache de pacotes local,
tentando encontrar um conjunto de versões que funcione com o seu pacote a partir do que já está
disponível.

## Opções {:#options}

Para opções que se aplicam a todos os comandos do pub, veja
[Opções globais](/tools/pub/cmd#global-options).

### `--[no-]offline`

{% render 'tools/pub-option-no-offline.md' %}

### `--dry-run` ou `-n` {:#dry-run-or-n}

Informa quais dependências mudariam, mas não altera nenhuma.

### `--[no-]example`

Por padrão, o pub também faz downgrade das dependências do
[diretório `example/`][example-dir] do pacote (`--example`).
Para pular o downgrade das dependências de exemplo, use `--no-example`.

[example-dir]: /tools/pub/package-layout#examples

### `--tighten`

:::version-note
O suporte à opção `--tighten` foi adicionado no Dart 3.5.
:::

Atualiza os limites inferiores das dependências em `pubspec.yaml` para corresponder às
versões resolvidas e retorna uma lista das restrições alteradas.
Pode ser aplicada a [dependências específicas](#downgrading-specific-dependencies).

{% render 'pub-problems.md' %}

## Em um workspace {:#in-a-workspace}

Em um [workspace do pub](/tools/pub/workspaces), `dart pub downgrade` faz
downgrade de todas as dependências em todo o workspace.
