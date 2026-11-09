---
ia-translate: true
title: dart pub global
description: Use dart pub global para executar scripts Dart hospedados no site pub.dev a partir da linha de comando.
---

:::version-note
**Comando legado:** o suporte a `dart pub global` é legado.
[`dart install`][] é a alternativa recomendada, compilada AOT,
que gera binários autocontidos,
oferece suporte a hooks de build nativos (`hook/build.dart`)
e inicia mais rápido.
Observe que `dart install` exige **Dart 3.10 ou posterior**.

**Nota de migração:** `dart install` coloca os binários
em `$DART_DATA_HOME/install/bin/` (em vez de `~/.pub-cache/bin/`).
Certifique-se de que o seu `PATH` esteja atualizado de acordo.
Além disso, como `dart install` cria executáveis nativos,
você não pode mais passar opções da VM Dart em tempo de execução.
:::

_Global_ é um dos comandos da [ferramenta pub](/tools/pub/cmd).

A opção `global` do pub permite que você execute scripts Dart a partir da
linha de comando quando não estiver dentro de um pacote.
Depois de [ativar um pacote](#activating-a-package), você pode
[executar scripts](#running-a-script) do diretório `bin` desse pacote.
[Desativar um pacote](#deactivating-a-package) o remove da
sua lista de pacotes disponíveis globalmente.

Por exemplo, digamos que você queira usar o [webdev][] para servir
sua aplicação web Dart a partir da linha de comando.

```console
$ dart pub global activate webdev
$ webdev serve
```

Se isso não funcionar, talvez seja necessário
[configurar seu PATH](#running-a-script-from-your-path).

Para executar um script Dart dentro de um pacote, ou de um
pacote do qual o seu pacote depende, consulte [dart run](/tools/dart-run).

## Ativar um pacote {:#activating-a-package}

```plaintext
dart pub global activate [--noexecutables] [--executable=<name>] [--overwrite] <package> [version-constraint]
```

Ative um pacote quando quiser poder executar
um ou mais de seus arquivos executáveis a partir da linha de comando.
Você pode ativar pacotes que estão no
[site pub.dev]({{site.pub}}), em um repositório Git
ou na sua máquina local.
Depois de ativar um pacote, veja [Executar um
script](#running-a-script) para executar scripts do
diretório `bin` do pacote.

Ao ativar um pacote, você pode especificar uma restrição de versão opcional.
Veja a flag [constraint](#options) para exemplos de uso.

:::note
[`dart install`][] é uma alternativa mais recente ao `dart pub global activate`.
:::

### Ativar um pacote no site pub.dev {:#activating-a-package-on-the-pub-dev-site}

```console
$ dart pub global activate <pub.dev package>
```

Especifique um pacote do site pub.dev para ativá-lo. Por exemplo:

```console
$ dart pub global activate markdown
```

### Ativar um pacote com Git {:#activating-a-package-with-git}

```console
$ dart pub global activate --source git <Git URL>
$ dart pub global activate -sgit <Git URL>
```

Use `--source git` (ou `-sgit`, para abreviar) para ativar
um pacote em um repositório Git. Os exemplos a seguir,
que ativam o pacote `async_await` no
[GitHub](https://github.com/), são equivalentes:

```console
$ dart pub global activate --source git https://github.com/dart-lang/async_await.git
$ dart pub global activate -sgit https://github.com/dart-lang/async_await.git
```

O pub espera encontrar o pacote na raiz do repositório Git.
Para especificar outro local,
use a opção `--git-path` com
um caminho relativo à raiz do repositório:

```console
$ dart pub global activate -sgit https://github.com/dart-lang/http.git --git-path pkgs/http/
```

O pub usa o branch padrão do repositório Git. Para especificar um
branch ou commit diferente, use a opção `--git-ref`:

```console
$ dart pub global activate -sgit https://github.com/dart-lang/http.git --git-ref 36f98e900347335af2338a0e087538009b7de2f9
```

### Ativar um pacote na sua máquina local {:#activating-a-package-on-your-local-machine}

```console
$ dart pub global activate --source path <path>
```

Use `activate --source path <path>` para ativar um pacote na sua máquina local.
O exemplo a seguir ativa o pacote `stopwatch` do
diretório `~/dart`:

```console
$ dart pub global activate --source path ~/dart/stopwatch
```

### Atualizar um pacote ativado {:#updating-an-activated-package}

Depois que um pacote for ativado, você pode atualizá-lo ativando o
pacote novamente.

## Executar um script {:#running-a-script}

Você pode executar diretamente um script de um pacote ativado a partir da
linha de comando. Se não conseguir executar o script diretamente,
também pode usar `dart pub global run`.

### Executar um script a partir do seu PATH {:#running-a-script-from-your-path}

Para executar um script diretamente pela linha de comando, adicione o diretório `bin`
do [cache do sistema][system cache] à sua variável de ambiente `PATH`.

Por exemplo, digamos que você ativou o pacote webdev,
mas ainda não consegue executar o comando:

```console
$ dart pub global activate webdev
$ webdev serve
-bash: webdev: command not found
```

Verifique se o diretório `bin` do cache do sistema está no seu PATH.
A seguinte variável `PATH`, no macOS, inclui o cache do sistema:

```console
$ echo $PATH
/Users/<user>/homebrew/bin:/usr/local/bin:/usr/bin:/bin:[!/Users/<user>/.pub-cache/bin!]
```

Se esse diretório estiver faltando no seu `PATH`,
localize o arquivo da sua plataforma e adicione-o.

| Plataforma                           | Localização do cache           |
|--------------------------------------|--------------------------------|
| macOS ou Linux                       | `$HOME/.pub-cache/bin`         |
| Windows<sup><strong>*</strong></sup> | `%LOCALAPPDATA%\Pub\Cache\bin` |

{:.table .table-striped}

<sup><strong>*</strong></sup> A localização exata do cache do sistema
pode variar em diferentes versões do Windows.

Agora você pode invocar o comando diretamente:

```console
$ cd web_project
$ [!webdev serve!]
```

Se o script ainda falhar ao ser executado pela linha de comando, o
pacote pode não estar [configurado](#configuring-package-executables) para
este recurso. Você ainda pode executar o script usando `dart pub global run`.

### Executar um script usando `dart pub global run` {:#running-a-script-using-dart-pub-global-run}

```plaintext
$ dart pub global run <package>:<executable> [args...]
```

Mesmo que um script não esteja configurado para ser executado pela linha de comando,
você ainda pode usar `dart pub global run`.
O comando a seguir executa o script `bin/bar.dart` do
pacote `foo`, passando dois argumentos.

```console
$ dart pub global run foo:bar arg1 arg2
```

### Configurar executáveis de pacote {:#configuring-package-executables}

Se você não for um desenvolvedor de pacotes, pode pular esta seção.

Um pacote pode expor alguns de seus scripts como executáveis
que podem ser executados diretamente pela linha de comando. O script ou os scripts
devem estar listados na
entrada [`executables`](/tools/pub/pubspec#executables)
do arquivo pubspec. Por exemplo, o seguinte arquivo pubspec
identifica `bin/helloworld.dart` como um executável do pacote
helloworld:

```yaml
name: helloworld

executables:
  helloworld:
```

Não listar um script na tag `executables` reduz a
usabilidade do script: scripts não listados podem ser executados com `dart pub global run`, mas não
diretamente pela linha de comando.

## Desativar um pacote {:#deactivating-a-package}

```console
$ dart pub global deactivate <package>
```

Use `deactivate` para remover um pacote da lista de
pacotes globais disponíveis. Por exemplo:

```console
$ dart pub global deactivate markdown
```

Você não pode mais invocar os scripts do pacote com `dart pub global run`
nem pela linha de comando.

## Listar pacotes ativos {:#listing-active-packages}

```console
$ dart pub global list
```

Use `list` para listar todos os pacotes atualmente ativos.

## Opções {:#options}

Para opções que se aplicam a todos os comandos do pub, veja
[Opções globais](/tools/pub/cmd#global-options).

### `[version-constraint]`

Use `dart pub global activate <package> [version-constraint]`
para especificar uma versão específica do pacote.
Por exemplo, o comando a seguir baixa
a versão 0.6.0 do pacote `markdown`:

```console
$ dart pub global activate markdown 0.6.0
```

Se você especificar um intervalo, o pub escolhe a melhor versão que atenda a essa
restrição. Por exemplo:

```console
$ dart pub global activate foo <3.0.0
```

### `--no-executables`

Use `dart pub global activate <package> --no-executables`
para ativar globalmente o pacote especificado,
mas sem colocar nenhum executável em `bin`.
Você precisa usar `dart pub global run` para executar qualquer executável.

### `--executable=<name>` ou `-x <name>` {:#executablename-or-x-name}

Use com `dart pub global activate`
para adicionar o executável especificado ao seu PATH.
Você pode passar mais de uma dessas flags.

Por exemplo, o comando a seguir adiciona `bar` e `baz`
(mas nenhum outro executável que `foo` possa definir)
ao seu PATH.

```console
$ dart pub global activate foo -x bar -x baz
```

### `--overwrite`

Use `dart pub global activate <package> --overwrite`
para sobrescrever quaisquer executáveis globais previamente ativados
com o mesmo nome. Se você não especificar esta flag,
o executável já existente não será substituído.


{% render 'pub-problems.md' %}

[`dart install`]: /tools/dart-install
[system cache]: /resources/glossary#pub-system-cache
[webdev]: /tools/webdev
