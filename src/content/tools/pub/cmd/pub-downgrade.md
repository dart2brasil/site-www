---
title: dart pub downgrade
description: Use dart pub downgrade para obter as versões mais baixas de todas as dependências usadas por seu aplicativo Dart.
ia-translate: true
---

_Downgrade_ é um dos comandos da [ferramenta pub](/tools/pub/cmd).

```plaintext
$ dart pub downgrade [--[no-]offline] [-n|--dry-run] [dependencies...]
```

Sem argumentos adicionais, `dart pub downgrade` obtém as versões mais baixas de
todas as dependências listadas no arquivo [`pubspec.yaml`](/tools/pub/pubspec)
no diretório de trabalho atual, bem como suas [dependências
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

O comando `dart pub downgrade` cria um arquivo de bloqueio. Se já existir um,
pub ignora esse arquivo e gera um novo do zero, usando as versões mais baixas
de todas as dependências.

Consulte a [documentação de `dart pub get`](/tools/pub/cmd/pub-get) para mais informações
sobre resolução de pacotes e o cache do pacote do sistema.


## Fazer downgrade de dependências específicas

É possível dizer ao `dart pub downgrade` para fazer downgrade de dependências específicas para a
versão mais baixa, deixando o resto das dependências sem alteração o máximo
possível. Por exemplo:

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

Se você estiver fazendo downgrade de uma dependência específica, pub tenta encontrar as
versões mais altas de qualquer dependência transitiva que se ajuste às novas
restrições de dependência. Qualquer dependência transitiva geralmente também sofre downgrade
como resultado.


## Obter uma nova dependência

Se uma dependência for adicionada ao pubspec antes de `dart pub downgrade` ser executado,
ela obtém a nova dependência e qualquer uma de suas dependências transitivas.
Isso compartilha o mesmo comportamento de `dart pub get`.


## Remover uma dependência

Se uma dependência for removida do pubspec antes de `dart pub downgrade` ser executado,
a dependência não estará mais disponível para importação.
Qualquer dependência transitiva da dependência removida também será removida,
desde que nenhuma dependência imediata restante também dependa delas.
Este é o mesmo comportamento de `dart pub get`.


## Fazer downgrade enquanto offline

Se você não tiver acesso à rede, ainda poderá executar `dart pub downgrade`.
Como pub baixa pacotes para um cache central compartilhado por todos os pacotes
em seu sistema, muitas vezes pode encontrar pacotes baixados anteriormente
sem precisar usar a rede.

No entanto, por padrão, `dart pub downgrade` tenta ficar online se você
tiver qualquer dependência hospedada.
Se você não quiser que pub faça isso, passe o sinalizador `--offline`.
No modo offline, pub procura apenas em seu cache de pacotes local,
tentando encontrar um conjunto de versões que funcione com seu pacote a partir do que já está
disponível.

## Opções

Para opções que se aplicam a todos os comandos pub, consulte
[Opções globais](/tools/pub/cmd#global-options).

### `--[no-]offline`

{% render 'tools/pub-option-no-offline.md' %}

### `--dry-run` ou `-n`

Relata quais dependências mudariam, mas não altera nenhuma.

### `--tighten`

:::version-note
O suporte para a opção `--tighten` foi adicionado no Dart 3.5.
:::

Atualiza os limites inferiores das dependências em `pubspec.yaml` para corresponder às
versões resolvidas e retorna uma lista das restrições alteradas.
Pode ser aplicado a [dependências específicas](#fazer-downgrade-de-dependências-específicas).

{% render 'pub-problems.md' %}

## Em um workspace

Em um [Pub workspace](/tools/pub/workspaces), `dart pub downgrade` fará
downgrade de todas as dependências em todo o workspace.