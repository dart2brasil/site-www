---
title: dart fix
description: "Command-line tool for applying analysis fixes and migrating API usages."
---

O comando `dart fix`
encontra e corrige dois tipos de problemas:

* Problemas de análise identificados por [`dart analyze`][]
  que possuem correções automatizadas associadas
  (às vezes chamadas de _quick-fixes_ ou _ações de código_).

* Usos de API desatualizados ao atualizar para
  versões mais recentes dos SDKs Dart e Flutter.

:::tip
Para aprender sobre `dart fix` em formato de vídeo,
confira este [mergulho profundo][] em **Decoding Flutter**:

<YouTubeEmbed id="OBIuSrg_Quo" title="Using Dart analyze & Dart fix"></YouTubeEmbed>
:::

[mergulho profundo]: {{site.yt.watch}}/OBIuSrg_Quo

<a id="usage"></a>
## Aplicar correções {:#apply-fixes}

Para visualizar as alterações propostas, use a flag `--dry-run` (simulação):

```console
$ dart fix --dry-run
```

Para aplicar as alterações propostas, use a flag `--apply`:

```console
$ dart fix --apply
```

<a id="customization"></a>
## Personalizar o comportamento {:#customize}

O comando `dart fix` só aplica correções
quando há um "problema" identificado por um diagnóstico.
Alguns diagnósticos, como erros de compilação, são implicitamente ativados,
enquanto outros, como lints, devem ser explicitamente ativados
no [arquivo de opções de análise](/tools/analysis),
pois as preferências individuais para estes variam.

Às vezes, você pode aumentar o número de correções que podem ser aplicadas
ativando lints adicionais.
Observe que nem todos os diagnósticos têm correções associadas.

### Exemplo {:#example}

Imagine que você tem um código como este:

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

O Dart 2.17 introduziu um novo recurso de linguagem chamado super initializers (inicializadores super),
que permite escrever o construtor de `Vector3d`
com um estilo mais compacto:

```dart
class Vector3d extends Vector2d {
  final double z;
  Vector3d(super.x, super.y, this.z);
}
```

Para habilitar o `dart fix` para atualizar o código existente para usar esse recurso,
e para garantir que o analisador avise quando você se esquecer de usá-lo posteriormente,
configure seu arquivo `analysis_options.yaml` da seguinte forma:

```yaml
linter:
  rules:
    - use_super_parameters
```

Também precisamos garantir que o código habilite a [versão de linguagem][] necessária.
Os inicializadores super foram introduzidos no Dart 2.17,
então atualize `pubspec.yaml` para ter pelo menos isso
na restrição inferior do SDK:

```yaml
environment:
  sdk: ">=2.17.0 <4.0.0"
```

Você deverá ver o seguinte ao visualizar as alterações propostas:

```console
$ dart fix --dry-run
Computing fixes in myapp (dry run)... 9.0s

1 proposed fixes in 1 files.

lib/myapp.dart
  use_super_parameters • 1 fix
```

Para saber mais sobre como personalizar os resultados e o comportamento da análise,
consulte [Personalizando a análise estática](/tools/analysis).

[`dart analyze`]: /tools/dart-analyze
[versão de linguagem]: /resources/language/evolution#language-versioning

## Suporte no VS Code {:#vs-code-support}

Quando você abre um projeto no VS Code,
o plugin Dart verifica o projeto em busca de problemas que o `dart fix` pode corrigir.
Se encontrar problemas para corrigir, o VS Code exibe um prompt para lembrá-lo.

<img src="/assets/img/tools/vscode/dart_fix_notification.png" width="550" height="175" alt="Notificação do VS Code sobre 'dart fix'">

Depois de executar `dart pub get` ou `dart pub upgrade`,
o VS Code também pode exibir este prompt se as alterações do pacote
adicionarem problemas que o `dart fix` pode corrigir.

Salve todos os seus arquivos antes de executar `dart fix`.
Isso garante que o Dart use as versões mais recentes de seus arquivos.