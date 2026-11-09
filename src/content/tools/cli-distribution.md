---
ia-translate: true
title: Empacotando e distribuindo ferramentas de CLI em Dart
description: Um guia para criar, compilar e distribuir aplicações de linha de comando em Dart.
---

:::version-note
O Dart 3.10 introduziu o suporte ao `dart install`
e aos build hooks estáveis (`hook/build.dart`).
O Dart 3.9 introduziu o comando `dart build cli`
para compilar aplicações de CLI.
:::

Uma ferramenta de CLI em Dart é uma aplicação de linha de comando independente
distribuída pelo gerenciador de pacotes Pub.
Criar suas próprias ferramentas de CLI permite compartilhar utilitários para desenvolvedores,
scripts de build ou aplicações de console para desktop completas
com todo o ecossistema Dart.

## Escrevendo os entrypoints {:#writing-entrypoints}

Quando um usuário instala uma ferramenta via [`dart install`][],
o Pub procura pelos entrypoints definidos no arquivo `pubspec.yaml` do seu pacote.

Crie um script Dart no diretório `bin/` do seu pacote.
Por exemplo, `bin/my_tool.dart`:

```dart
void main(List<String> arguments) {
  print('Hello from my tool!');
}
```

Em seguida, associe esse script a um nome de comando no seu `pubspec.yaml`
usando a seção `executables`:

```yaml
name: my_package
version: 1.0.0
# ... other metadata

executables:
  my_tool: my_tool
```

A chave (`my_tool`) é o nome do comando executável que o Pub coloca no PATH
do usuário, e o valor (`my_tool`) corresponde ao script `bin/my_tool.dart`.

## Compilando com dart build cli {:#compiling-via-dart-build-cli}

A partir do Dart 3.9, você pode compilar explicitamente aplicações de CLI
usando o comando `dart build cli`.

Por baixo dos panos, o `dart install` invoca automaticamente o `dart build cli`
para criar **executáveis nativos autocontidos compilados com AOT** para a sua ferramenta.

A compilação AOT (Ahead-of-Time) significa que sua ferramenta inicia instantaneamente
sem iniciar uma Dart VM nem compilar código dinamicamente com JIT,
o que resulta em tempos de execução muito mais rápidos e consistentes para os seus usuários.

## Acessando o Dart SDK e criando subprocessos {:#access-the-dart-sdk-and-spawn-subprocesses}

Ao criar ferramentas que invocam outros comandos de desenvolvedor
(como `dart format`, `dart test` ou geradores de código),
esteja atento à diferença de ambiente de execução
entre snapshots JIT e binários AOT.

### Comportamento de Platform.resolvedExecutable em AOT {:#platformresolvedexecutable-behavior-in-aot}

No modelo legado `dart pub global activate`
(que rodava dentro da Dart JIT VM),
`Platform.resolvedExecutable` apontava diretamente para o
binário `<dart-sdk>/bin/dart`.
Muitos pacotes legados localizavam as bibliotecas do SDK
navegando a partir desse caminho:

```dart
// ❌ UNSAFE under AOT compilation ('dart install')
final sdkDir = path.dirname(path.dirname(Platform.resolvedExecutable));
```

Com `dart install` (e `dart compile exe`),
`Platform.resolvedExecutable` aponta para **o binário compilado da sua aplicação**
(por exemplo, em
`~/.dart/install/app-bundles/<package>/.../bundle/bin/<executable>`),
**e não** para o runtime do Dart SDK.

Se sua ferramenta depender de `Platform.resolvedExecutable` ou `Platform.executable`:
1. **As buscas no SDK falham**:
   o bundle da aplicação da ferramenta não contém os artefatos do compilador do SDK.
1. **A criação de subprocessos entra em loop infinito**:
   invocar qualquer uma dessas propriedades executa o binário da sua ferramenta novamente
   em vez do executável `dart`.

### Solução recomendada: package:cli_util {:#recommended-solution-packagecli_util}

Para descobrir com segurança o Dart SDK do host e localizar o binário `dart`
tanto na compilação JIT quanto na AOT,
use o [`package:cli_util`][] (versão `^0.6.0` ou posterior):

```yaml
dependencies:
  cli_util: ^0.6.0
```

O `package:cli_util` verifica vários locais de fallback para encontrar o SDK
(o caminho do runtime ativo, a variável de ambiente `DART_SDK`,
o `PATH` do sistema, incluindo o SDK empacotado com o Flutter, e `FLUTTER_ROOT`):

```dart
import 'dart:io';
import 'package:cli_util/cli_util.dart';

void runTool() {
  // 1. Get the path to the Dart SDK root directory (or null if not found)
  final String? sdk = sdkPath;
  if (sdk != null) {
    print('Found Dart SDK at: $sdk');
  }

  // 2. Get the path to the host `dart` executable for subprocess spawning
  final String? dart = dartExecutable;

  if (dart != null) {
    // Safely spawn a child Dart process
    Process.runSync(dart, ['format', '.']);
  }
}
```

## Adicionando build hooks {:#adding-build-hooks}

Se a sua ferramenta de CLI depender de bibliotecas nativas em C/C++
ou precisar empacotar dados ou assets específicos,
você pode usar [code assets e build hooks](/tools/hooks).

Ao escrever um script `hook/build.dart`,
você pode instruir o Dart SDK a compilar ou baixar dependências nativas
quando o usuário instalar seu pacote.
O `dart install` oferece suporte completo a esses hooks,
garantindo que a saída compilada (bibliotecas dinâmicas e assets)
seja colocada ao lado do executável compilado com AOT no bundle da aplicação.

## Distribuição {:#distribution}

Assim que o seu pacote for publicado no pub.dev (ou enviado para um repositório Git),
os usuários podem instalá-lo globalmente usando o comando [`dart install`][]:

```console
$ dart install my_package
```

Esse comando resolve as dependências,
executa os build hooks,
compila o executável com AOT
e coloca o binário resultante no diretório `$DART_DATA_HOME/install/bin`.

Dependendo da plataforma, o local padrão é:

| Plataforma | Caminho padrão |
|---|---|
| **macOS** | `$HOME/Library/Application Support/Dart/install/bin` |
| **Linux** | `$HOME/.local/share/dart/install/bin` (ou `$XDG_DATA_HOME/dart/install/bin`) |
| **Windows** | `%LOCALAPPDATA%\Dart\install\bin` |

### Migrando usuários do pub global {:#migrating-users-from-pub-global}

Se você mantém um pacote de CLI em Dart já existente,
atualize sua documentação (como o seu `README.md`)
para recomendar o `dart install` em vez do comando legado `dart pub global activate`.
O `dart install` gera aplicações mais rápidas e autocontidas,
desacopladas da versão do Dart SDK do host.

[`dart install`]: /tools/dart-install
[`package:cli_util`]: {{site.pub-pkg}}/cli_util
