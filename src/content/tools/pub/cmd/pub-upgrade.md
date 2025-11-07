---
ia-translate: true
title: dart pub upgrade
description: Use `dart pub upgrade` para obter as versões mais recentes de todas as dependências usadas pelo seu aplicativo Dart.
---

_Upgrade_ (atualizar) é um dos comandos da [ferramenta pub](/tools/pub/cmd).

```plaintext
$ dart pub upgrade [opções] [dependências]
```

Like [`dart pub get`](/tools/pub/cmd/pub-get),
`dart pub upgrade` gets dependencies.
The difference is that `dart pub upgrade` ignores any existing
[lockfile](/resources/glossary#lockfile),
so that pub can get the latest versions of all dependencies.
A related command is [`dart pub outdated`](/tools/pub/cmd/pub-outdated),
which you can run to find out-of-date dependencies.

Without any additional arguments, `dart pub upgrade` gets the latest
versions of all the dependencies listed in the
[`pubspec.yaml`](/tools/pub/pubspec) file in the current working
directory, as well as their [transitive
dependencies](/resources/glossary#transitive-dependency).
For example:

```console
$ dart pub upgrade
Dependências atualizadas!
```

Quando `dart pub upgrade` atualiza as versões das dependências, ele grava um lockfile para garantir que
[`dart pub get`](/tools/pub/cmd/pub-get) usará as mesmas versões dessas
dependências. Para [pacotes de aplicativos][], faça o check-in do lockfile
no controle de código-fonte; isso garante que o aplicativo tenha
exatamente as mesmas versões de todas as dependências para todos os
desenvolvedores e quando implantado em produção. Para pacotes comuns, não
faça o check-in do lockfile, porque espera-se que os pacotes funcionem com um intervalo de versões de dependências.

Se um lockfile já existir, `dart pub upgrade` o ignora e gera um novo do zero,
usando as versões mais recentes de todas as dependências.

Consulte a documentação do [`dart pub get`](/tools/pub/cmd/pub-get) para obter mais informações
sobre a resolução de pacotes e o cache de pacotes do sistema.

[application packages]: /resources/glossary#application-package

## Atualizando dependências específicas {:#upgrading-specific-dependencies}

Você pode dizer ao `dart pub upgrade` para atualizar dependências
específicas para a versão mais recente, deixando o resto das
dependências como estão, tanto quanto possível. Por exemplo:

```console
$ dart pub upgrade test args
Dependências atualizadas!
```

Geralmente, nenhuma outra dependência é atualizada; elas permanecem nas
versões que estão bloqueadas no lockfile. No entanto, se as atualizações
solicitadas causarem incompatibilidades com essas versões bloqueadas,
elas serão desbloqueadas seletivamente até que um conjunto compatível de versões seja encontrado.

Isso significa que atualizar uma dependência específica não atualiza por padrão suas
dependências transitivas.

Para atualizar uma dependência específica e todas as suas dependências
transitivas para suas versões mais recentes, use a flag `--unlock-transitive`.

```console
$ dart pub upgrade --unlock-transitive test args
```


## Obtendo uma nova dependência {:#getting-a-new-dependency}

Se uma dependência for adicionada ao pubspec antes que `dart pub upgrade` seja
executado, ele obterá a nova dependência e qualquer uma de suas dependências
transitivas. Isso compartilha o mesmo comportamento do `dart pub get`.


## Removendo uma dependência {:#removing-a-dependency}

Se uma dependência for removida do pubspec antes que `dart pub upgrade` seja
executado, a dependência não estará mais disponível para importação.
Quaisquer dependências transitivas da dependência removida também são
removidas, desde que nenhuma dependência imediata restante também dependa
delas. Este é o mesmo comportamento do `dart pub get`.

## Atualizando offline {:#upgrading-while-offline}

Se você não tiver acesso à rede, ainda poderá executar `dart pub upgrade`.
Como o pub baixa os pacotes para um cache central compartilhado por todos os
pacotes em seu sistema, ele geralmente pode encontrar pacotes baixados
anteriormente sem precisar usar a rede.

No entanto, por padrão, `dart pub upgrade` tenta se conectar se você
tiver alguma dependência hospedada, para que o pub possa detectar versões mais
recentes de dependências. Se você não quiser que o pub faça isso, passe
o sinalizador `--offline`. No modo offline, o pub procura apenas no seu
cache de pacotes local, tentando encontrar um conjunto de versões que
funcionem com o seu pacote a partir do que já
está disponível.

Lembre-se de que o pub gera um lockfile. Se a única versão de alguma
dependência em seu cache for antiga, o `dart pub upgrade` offline
bloqueará seu aplicativo para essa versão antiga. Da próxima vez que
você estiver online, provavelmente desejará executar `dart pub upgrade`
novamente para atualizar para uma versão posterior.

## Opções {:#options}

O comando `dart pub upgrade` suporta as
[opções do `dart pub get`](/tools/pub/cmd/pub-get#options), e mais.
Para opções que se aplicam a todos os comandos pub, consulte
[Opções globais](/tools/pub/cmd#global-options).

### `--[no-]offline` {:#no-offline}

{% render 'tools/pub-option-no-offline.md' %}

### `--dry-run` ou `-n` {:#dry-run-or-n}

Relata as dependências que seriam alteradas, mas não faz as alterações.
Isso é útil se você quiser analisar as
atualizações antes de fazê-las.

### `--[no-]precompile` {:#no-precompile}

Por padrão, o pub pré-compila os executáveis em dependências imediatas
(`--precompile`). Para evitar a pré-compilação,
use `--no-precompile`.

### `--major-versions` {:#major-versions}

Obtém os pacotes que [`dart pub outdated`][] lista como _resolvíveis_,
ignorando qualquer restrição de limite superior no arquivo `pubspec.yaml`.
Também atualiza `pubspec.yaml` com as novas restrições.

[`dart pub outdated`]: /tools/pub/cmd/pub-outdated

:::tip
Faça o commit do arquivo `pubspec.yaml` antes de executar este comando,
para que você possa desfazer as alterações, se necessário.
:::

Para verificar quais dependências serão atualizadas, você pode usar
`dart pub upgrade --major-versions --dry-run`.

### `--tighten` {:#tighten}

Atualiza os limites inferiores das dependências em `pubspec.yaml` para
corresponder às versões resolvidas e retorna uma lista das restrições
alteradas. Pode ser aplicado a [dependências específicas](#upgrading-specific-dependencies).

### `--unlock-transitive` {:#unlock-transitive}

Quando usado com uma lista de pacotes para desbloquear, primeiro o
fechamento transitivo das dependências desses pacotes (na resolução atual)
é computado e, em seguida, todos esses pacotes são desbloqueados.

## Em um workspace {:#in-a-workspace}

Em um [workspace (espaço de trabalho) Pub](/tools/pub/workspaces),
`dart pub upgrade` atualizará todas as dependências na resolução
compartilhada de todos os pacotes do workspace.

`dart pub upgrade --major-versions` e `dart pub upgrade --tighten` atualizarão as
restrições em todos os arquivos `pubspec.yaml` do workspace.

{% render 'pub-problems.md' %}
