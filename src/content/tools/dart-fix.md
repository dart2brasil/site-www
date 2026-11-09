---
ia-translate: true
title: dart fix
description: >-
  Ferramenta de linha de comando para aplicar correções de análise e migrar usos de API.
---

O comando `dart fix`
encontra e corrige dois tipos de problemas:

* Problemas de análise identificados pelo [`dart analyze`][]
  que têm correções automatizadas associadas
  (às vezes chamadas de _quick fixes_ ou _code actions_).

* Usos de API desatualizados ao atualizar para
  versões mais recentes dos SDKs do Dart e do Flutter, ou de dependências
  que fornecem correções orientadas a dados.

  Se você é mantenedor de um pacote,
  para ajudar seus usuários a migrar quando você alterar a API do seu pacote,
  pode criar [correções orientadas a dados][data-driven fixes].

:::tip
Para aprender sobre o `dart fix` em formato de vídeo,
confira este [deep dive][] sobre o **Decoding Flutter**:

<YouTubeEmbed id="OBIuSrg_Quo" title="Using Dart analyze & Dart fix"></YouTubeEmbed>
:::

[deep dive]: {{site.yt.watch}}/OBIuSrg_Quo

## Aplique as correções {:#apply-fixes}

Para visualizar as alterações propostas, use a flag `--dry-run`:

```console
$ dart fix --dry-run
```

Para aplicar as alterações propostas, use a flag `--apply`:

```console
$ dart fix --apply
```

## Opções para `dart fix` {:#options-for-dart-fix}

As opções a seguir podem ser usadas com o comando `dart fix`.

### `-h`, `--help` {:#h--help}

Exibe as informações de uso do `dart fix`.

```console
$ dart fix --help
```

### `-n`, `--dry-run` {:#n--dry-run}

Visualiza as alterações propostas sem modificar nenhum arquivo.

```console
$ dart fix --dry-run
```

### `--apply` {:#apply}

Aplica as alterações propostas diretamente nos arquivos de código-fonte.

```console
$ dart fix --apply
```

### `--code` {:#code}

Aplica correções apenas para um ou mais códigos de diagnóstico específicos.
Especifique vários códigos de diagnóstico como uma lista separada por vírgulas.

```console
$ dart fix --apply --code=prefer_single_quotes,use_super_parameters
```

### `--compare-to-golden` {:#compare-to-golden}

Compara o resultado da aplicação das correções com
arquivos golden que contêm o código resultante esperado,
sem modificar os arquivos de código-fonte.

```console
$ dart fix --compare-to-golden
```

Mantenedores de pacotes podem usar esta opção para verificar suas correções orientadas a dados.
Para aprender a configurar e executar esses testes,
consulte [Teste suas correções][Test your fixes].

<a id="customization"></a>
## Personalize as correções baseadas em análise {:#customize}

O comando `dart fix` aplica correções apenas
quando há um "problema" identificado por um diagnóstico.
Alguns diagnósticos, como erros de compilação, são habilitados implicitamente,
enquanto outros, como lints, precisam ser habilitados explicitamente
no [arquivo de opções de análise](/tools/analysis),
já que as preferências individuais por eles variam.

Às vezes você pode aumentar o número de correções que podem ser aplicadas
habilitando lints adicionais.
Observe que nem todos os diagnósticos têm correções associadas.

### Exemplo {:#example}

Imagine que você tenha um código assim:

```dart
class Vector2d {
  final double x, y;
  Vector2d(this.x, this.y);
}

class Vector3d extends Vector2d {
  final double z;
  Vector3d(final double x, final double y, this.z) : super(x, y);
}
```

O Dart 2.17 introduziu um novo recurso de linguagem chamado super initializers,
que permite escrever o construtor de `Vector3d`
com um estilo mais compacto:

```dart
class Vector3d extends Vector2d {
  final double z;
  Vector3d(super.x, super.y, this.z);
}
```

Para habilitar o `dart fix` a atualizar o código existente para usar esse recurso,
e para garantir que o analyzer avise quando você esquecer de usá-lo depois,
configure seu arquivo `analysis_options.yaml` da seguinte forma:

```yaml title="analysis_options.yaml"
linter:
  rules:
    - use_super_parameters
```

Certifique-se também de que seu código habilita a [versão da linguagem][language version] necessária.
Os super initializers foram introduzidos no Dart 2.17,
então atualize o `pubspec.yaml` para ter pelo menos essa versão
na restrição inferior do SDK:

```yaml title="pubspec.yaml"
environment:
  sdk: ">=2.17.0 <4.0.0"
```

Você deverá então ver o seguinte ao visualizar as alterações propostas:

```console
$ dart fix --dry-run
Computing fixes in myapp (dry run)... 9.0s

1 proposed fixes in 1 files.

lib/myapp.dart
  use_super_parameters • 1 fix
```

Para saber mais sobre a personalização dos resultados e do comportamento da análise,
consulte [Personalizando a análise estática](/tools/analysis).

## Suporte em IDEs {:#ide-support}

Quando você abre um projeto em um editor com suporte ao Dart,
o analyzer do Dart escaneia o projeto em busca de problemas que o `dart fix` pode corrigir.
Se encontrar problemas para corrigir,
o editor pode exibir avisos e oferecer quick fixes (code actions).

<a id="vs-code-support"></a>
### VS Code {:#vs-code}

No VS Code,
a extensão Dart exibe um aviso quando há correções disponíveis:

<img src="/assets/img/tools/vscode/dart_fix_notification.png" width="550" height="175" alt="VS Code notification about 'dart fix'">

Depois de executar `dart pub get` ou `dart pub upgrade`,
o VS Code também pode exibir esse aviso se as alterações de pacotes
adicionarem problemas que o `dart fix` pode corrigir.

Salve todos os seus arquivos antes de executar `dart fix`.
Isso garante que o Dart use as versões mais recentes dos seus arquivos.

### IntelliJ IDEA e Android Studio {:#intellij-idea-and-android-studio}

Nas [IDEs da JetBrains](/tools/jetbrains-plugin),
pressione <kbd>Alt</kbd> + <kbd>Enter</kbd> no Windows ou Linux
ou <kbd>Option</kbd> + <kbd>Return</kbd> no macOS
sobre qualquer diagnóstico de código destacado para ver e aplicar os quick fixes disponíveis.

[`dart analyze`]: /tools/dart-analyze
[data-driven fixes]: /tools/pub/data-driven-fixes
[Test your fixes]: /tools/pub/data-driven-fixes#test-your-fixes
[language version]: /language/versioning
