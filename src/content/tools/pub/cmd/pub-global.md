---
title: dart pub global
description: Use dart pub global para executar scripts Dart hospedados no site pub.dev a partir da linha de comando.
ia-translate: true
---

_Global_ é um dos comandos da [ferramenta pub](/tools/pub/cmd).

A opção `global` do Pub permite que você execute scripts Dart a partir da
linha de comando quando você não está dentro de um pacote.
Depois de [ativar um pacote](#ativar-um-pacote), você pode
[executar scripts](#executar-um-script) do diretório `bin` desse pacote.
[Desativar um pacote](#desativar-um-pacote) o remove da
sua lista de pacotes disponíveis globalmente.

Por exemplo, digamos que você queira usar [webdev][] para servir
seu aplicativo web Dart a partir da linha de comando.

```console
$ dart pub global activate webdev
$ webdev serve
```

Se isso não funcionar, você pode precisar
[configurar seu caminho](#executar-um-script-a-partir-do-seu-path).

Para executar um script Dart dentro de um pacote, ou de um
pacote do qual seu pacote depende, consulte [dart run](/tools/dart-run).

## Ativar um pacote

```plaintext
dart pub global activate [--noexecutables] [--executable=<name>] [--overwrite] <package> [version-constraint]
```

Ative um pacote quando quiser ser capaz de executar
um ou mais de seus arquivos executáveis a partir da linha de comando.
Você pode ativar pacotes que residem no
[site pub.dev]({{site.pub}}), um repositório Git,
ou sua máquina local.
Depois de ter ativado um pacote, consulte [Executar um
script](#executar-um-script) para executar scripts do
diretório `bin` do pacote.

Quando você ativa um pacote, pode especificar uma restrição de versão opcional.
Consulte o sinalizador [constraint](#options) para exemplos de uso.

:::note
[`dart install`][] é uma alternativa mais recente para `dart pub global activate`.
:::

### Ativar um pacote no site pub.dev

```console
$ dart pub global activate <pub.dev package>
```

Especifique um pacote no site pub.dev para ativá-lo. Por exemplo:

```console
$ dart pub global activate markdown
```

### Ativar um pacote com Git

```console
$ dart pub global activate --source git <Git URL>
$ dart pub global activate -sgit <Git URL>
```

Use `--source git` (ou `-sgit`, para resumir) para ativar
um pacote em um repositório Git. Os exemplos a seguir,
que ativam o pacote `async_await` em
[GitHub](https://github.com/), são equivalentes:

```console
$ dart pub global activate --source git https://github.com/dart-lang/async_await.git
$ dart pub global activate -sgit https://github.com/dart-lang/async_await.git
```

Pub espera encontrar o pacote na raiz do repositório Git.
Para especificar uma localização diferente,
use a opção `--git-path` com
um caminho relativo à raiz do repositório:

```console
$ dart pub global activate -sgit https://github.com/dart-lang/http.git --git-path pkgs/http/
```

Pub usa o branch padrão do repositório Git. Para especificar um
branch ou commit diferente, use a opção `--git-ref`:

```console
$ dart pub global activate -sgit https://github.com/dart-lang/http.git --git-ref 36f98e900347335af2338a0e087538009b7de2f9
```

### Ativar um pacote em sua máquina local

```console
$ dart pub global activate --source path <path>
```

Use `activate --source path <path>` para ativar um pacote em sua máquina local.
O exemplo a seguir ativa o pacote `stopwatch` do
diretório `~/dart`:

```console
$ dart pub global activate --source path ~/dart/stopwatch
```

### Atualizar um pacote ativado

Depois que um pacote foi ativado, você pode atualizá-lo ativando o
pacote novamente.

## Executar um script

Você pode executar diretamente um script de um pacote ativado a partir da
linha de comando. Se você não conseguir executar o script diretamente,
você também pode usar `dart pub global run`.

### Executar um script a partir do seu PATH

Para executar um script diretamente a partir da linha de comando, adicione o `bin`
do [cache do sistema][] ao sua variável de ambiente `PATH`.

Por exemplo, digamos que você tenha ativado o pacote webdev,
mas ainda não consiga executar o comando:

```console
$ dart pub global activate webdev
$ webdev serve
-bash: webdev: command not found
```

Verifique se o diretório `bin` do cache do sistema está em seu caminho.
A seguinte variável `PATH`, no macOS, inclui o cache do sistema:

```console
$ echo $PATH
/Users/<user>/homebrew/bin:/usr/local/bin:/usr/bin:/bin:[!/Users/<user>/.pub-cache/bin!]
```

Se este diretório estiver faltando em seu `PATH`,
localize o arquivo para sua plataforma e adicione-o.

| Plataforma                           | Localização do Cache               |
|--------------------------------------|--------------------------------|
| macOS ou Linux                       | `$HOME/.pub-cache/bin`         |
| Windows<sup><strong>*</strong></sup> | `%LOCALAPPDATA%\Pub\Cache\bin` |

{:.table .table-striped}

<sup><strong>*</strong></sup> A localização exata do cache do sistema
pode variar para diferentes versões do Windows.

Agora você pode invocar diretamente o comando:

```console
$ cd web_project
$ [!webdev serve!]
```

Se o script ainda falhar ao ser executado a partir da linha de comando, o
pacote pode não estar [configurado](#configurar-executáveis-de-pacote) para
este recurso. Você ainda pode executar o script usando `dart pub global run`.

### Executar um script usando `dart pub global run`

```plaintext
$ dart pub global run <package>:<executable> [args...]
```

Mesmo que um script não esteja configurado para ser executado a partir da linha de comando,
você ainda pode usar `dart pub global run`.
O comando a seguir executa o script `bin/bar.dart` do
pacote `foo`, passando dois argumentos.

```console
$ dart pub global run foo:bar arg1 arg2
```

### Configurar executáveis de pacote

Se você não for um desenvolvedor de pacotes, pode pular esta seção.

Um pacote pode expor alguns de seus scripts como executáveis
que podem ser executados diretamente a partir da linha de comando. O script ou scripts
devem estar listados na
entrada [`executables`](/tools/pub/pubspec#executables)
do arquivo pubspec. Por exemplo, o seguinte arquivo pubspec
identifica `bin/helloworld.dart` como um executável para o pacote
helloworld:

```yaml
name: helloworld

executables:
  helloworld:
```

A falha em listar um script sob a tag `executables` reduz a
usabilidade do script: scripts não listados podem ser executados usando `dart pub global run`, mas não
diretamente a partir da linha de comando.

## Desativar um pacote

```console
$ dart pub global deactivate <package>
```

Use `deactivate` para remover um pacote da lista de
pacotes globais disponíveis. Por exemplo:

```console
$ dart pub global deactivate markdown
```

Você não pode mais invocar os scripts do pacote usando `dart pub global run`,
ou a partir da linha de comando.

## Listar pacotes ativos

```console
$ dart pub global list
```

Use `list` para listar todos os pacotes atualmente ativos.

## Opções

Para opções que se aplicam a todos os comandos pub, consulte
[Opções globais](/tools/pub/cmd#global-options).

### `[version-constraint]`

Use `dart pub global activate <package> [version-constraint]`
para especificar uma versão específica do pacote.
Por exemplo, o comando a seguir puxa
a versão 0.6.0 do pacote `markdown`:

```console
$ dart pub global activate markdown 0.6.0
```

Se você especificar um intervalo, pub escolhe a melhor versão que atende a essa
restrição. Por exemplo:

```console
$ dart pub global activate foo <3.0.0
```

### `--no-executables`

Use `dart pub global activate <package> --no-executables`
para ativar globalmente o pacote especificado,
mas não coloque nenhum executável em `bin`.
Você tem que usar `dart pub global run` para executar quaisquer executáveis.

### `--executable=<name>` ou `-x <name>`

Use com `dart pub global activate`
para adicionar o executável especificado ao seu PATH.
Você pode passar mais de um desses sinalizadores.

Por exemplo, o comando a seguir adiciona `bar` e `baz`,
(mas não nenhum outro executável que `foo` possa definir)
ao seu PATH.

```console
$ dart pub global activate foo -x bar -x baz
```

### `--overwrite`

Use `dart pub global activate <package> --overwrite`
para sobrescrever quaisquer executáveis globais previamente ativados
com o mesmo nome. Se você não especificar este sinalizador,
o executável pré-existente não será substituído.


{% render 'pub-problems.md' %}

[`dart install`]: /tools/dart-install
[system cache]: /resources/glossary#pub-system-cache
[webdev]: /tools/webdev
