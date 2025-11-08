---
ia-translate: true
title: dart pub downgrade
description: "Use dart pub downgrade para obter as versões mais baixas de todas as dependências usadas pela sua aplicação Dart."
---

_Downgrade_ (rebaixar) é um dos comandos da [ferramenta pub](/tools/pub/cmd).

```plaintext
$ dart pub downgrade [--[no-]offline] [-n|--dry-run] [dependências...]
```

Without any additional arguments, `dart pub downgrade` gets the lowest versions of
all the dependencies listed in the [`pubspec.yaml`](/tools/pub/pubspec) file
in the current working directory, as well as their [transitive
dependencies](/resources/glossary#transitive-dependency).
For example:

```console
$ dart pub downgrade
Resolvendo dependências... (1.2s)
+ barback 0.13.0
+ collection 0.9.1
+ path 1.2.0
+ source_maps 0.9.0
+ source_span 1.0.0
+ stack_trace 0.9.1
Alteradas 6 dependências!
```

O comando `dart pub downgrade` cria um arquivo de lock (bloqueio). Se já existir um,
o pub ignora esse arquivo e gera um novo do zero, usando as versões mais baixas
de todas as dependências.

Veja a documentação de [`dart pub get`](/tools/pub/cmd/pub-get) para mais informações
sobre resolução de pacotes e o cache de pacotes do sistema.


## Rebaixando dependências específicas {:#downgrading-specific-dependencies}

É possível instruir o `dart pub downgrade` a rebaixar dependências específicas para a
versão mais baixa, mantendo as demais dependências o mais intactas possível.
Por exemplo:

```console
$ dart pub downgrade test
Resolvendo dependências...
  barback 0.15.2+2
  bot 0.27.0+2
  browser 0.10.0+2
  chrome 0.6.5
  collection 1.1.0
  path 1.3.0
  pool 1.0.1
  source_span 1.0.2
< stack_trace 0.9.2 (era 1.1.1)
  stagexl 0.10.2
< test 0.10.0 (era 0.11.4)
Estes pacotes não são mais necessários:
- matcher 0.11.3
Alteradas 3 dependências!
```

Se você estiver rebaixando uma dependência específica, o pub tenta encontrar as
versões mais altas de quaisquer dependências transitivas que se encaixem nas novas
restrições de dependência. Quaisquer dependências transitivas são geralmente também
rebaixadas como resultado.


## Obtendo uma nova dependência {:#getting-a-new-dependency}

Se uma dependência for adicionada ao pubspec antes de `dart pub downgrade` ser
executado, ele obtém a nova dependência e quaisquer de suas dependências transitivas.
Isso compartilha o mesmo comportamento que `dart pub get`.


## Removendo uma dependência {:#removing-a-dependency}

Se uma dependência for removida do pubspec antes de `dart pub downgrade` ser
executado, a dependência não estará mais disponível para importação.
Quaisquer dependências transitivas da dependência removida também são removidas,
contanto que nenhuma dependência imediata restante também dependa delas.
Este é o mesmo comportamento de `dart pub get`.


## Rebaixando enquanto offline {:#downgrading-while-offline}

Se você não tiver acesso à rede, ainda pode executar `dart pub downgrade`.
Como o pub baixa pacotes para um cache central compartilhado por todos os pacotes
em seu sistema, ele pode frequentemente encontrar pacotes baixados anteriormente
sem precisar usar a rede.

No entanto, por padrão, `dart pub downgrade` tenta se conectar se você
tiver alguma dependência hospedada.
Se você não quiser que o pub faça isso, passe a flag `--offline`.
No modo offline, o pub procura apenas em seu cache de pacotes local,
tentando encontrar um conjunto de versões que funcionem com seu pacote a partir do que já
está disponível.

## Opções {:#options}

Para opções que se aplicam a todos os comandos pub, veja
[Opções globais](/tools/pub/cmd#global-options).

### `--[no-]offline` {:#no-offline}

{% render 'tools/pub-option-no-offline.md' %}

### `--dry-run` ou `-n` {:#dry-run-or-n}

Relata quais dependências seriam alteradas, mas não altera nenhuma.

### `--tighten` {:#tighten}

:::version-note
O suporte para a opção `--tighten` foi adicionado no Dart 3.5.
:::

Atualiza os limites inferiores das dependências em `pubspec.yaml` para corresponder às
versões resolvidas e retorna uma lista das restrições alteradas.
Pode ser aplicado a [dependências específicas](#downgrading-specific-dependencies).

{% render 'pub-problems.md' %}

## Em um workspace (espaço de trabalho) {:#in-a-workspace}

Em um [workspace Pub](/tools/pub/workspaces), `dart pub downgrade` irá
rebaixar todas as dependências em todo o workspace.