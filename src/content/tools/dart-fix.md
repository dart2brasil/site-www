---
ia-translate: true
title: dart fix
description: >-
  Ferramenta de linha de comando para aplicar correções de análise e migrar usos de API.
---

O comando `dart fix`
encontra e corrige dois tipos de problemas:

* Problemas de análise identificados por [`dart analyze`][]
  que têm correções automatizadas associadas
  (às vezes chamadas de _quick-fixes_ ou _code actions_).

* Usos de API desatualizados ao atualizar para
  versões mais recentes dos SDKs Dart e Flutter.

:::tip
Para aprender sobre `dart fix` em formato de vídeo,
confira este [deep dive][] no **Decoding Flutter**:

<YouTubeEmbed id="OBIuSrg_Quo" title="Using Dart analyze & Dart fix"></YouTubeEmbed>
:::

[deep dive]: {{site.yt.watch}}/OBIuSrg_Quo

<a id="usage"></a>
## Aplicar correções

Para visualizar as mudanças propostas, use a flag `--dry-run`:

```console
$ dart fix --dry-run
```

Para aplicar as mudanças propostas, use a flag `--apply`:

```console
$ dart fix --apply
```

<a id="customization"></a>
## Personalizar comportamento {:#customize}

O comando `dart fix` aplica correções apenas
quando há um "problema" identificado por um diagnóstico.
Alguns diagnósticos, como erros de compilação, são implicitamente habilitados,
enquanto outros, como lints, devem ser explicitamente habilitados
no [arquivo de opções de análise](/tools/analysis),
pois as preferências individuais para estes variam.

Você pode às vezes aumentar o número de correções que podem ser aplicadas
habilitando lints adicionais.
Observe que nem todos os diagnósticos têm correções associadas.

### Exemplo

Imagine que você tem código assim:

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

Dart 2.17 introduziu um novo recurso de linguagem chamado super initializers,
que permite que você escreva o construtor de `Vector3d`
com um estilo mais compacto:

```dart
class Vector3d extends Vector2d {
  final double z;
  Vector3d(super.x, super.y, this.z);
}
```

Para habilitar o `dart fix` a atualizar código existente para usar este recurso,
e para garantir que o analyzer avise quando você esquecer de usá-lo mais tarde,
configure seu arquivo `analysis_options.yaml` da seguinte forma:

```yaml
linter:
  rules:
    - use_super_parameters
```

Também precisamos garantir que o código habilite a [versão de linguagem][language version] necessária.
Super initializers foram introduzidos no Dart 2.17,
então atualize o `pubspec.yaml` para ter pelo menos isso
na restrição inferior do SDK:

```yaml
environment:
  sdk: ">=2.17.0 <4.0.0"
```

Você deve então ver o seguinte ao visualizar as mudanças propostas:

```console
$ dart fix --dry-run
Computing fixes in myapp (dry run)... 9.0s

1 proposed fixes in 1 files.

lib/myapp.dart
  use_super_parameters • 1 fix
```

Para saber mais sobre personalizar resultados e comportamento de análise,
consulte [Personalizando a análise estática](/tools/analysis).

[`dart analyze`]: /tools/dart-analyze
[language version]: /resources/language/evolution#language-versioning

## Suporte do VS Code

Quando você abre um projeto no VS Code,
o plugin Dart escaneia o projeto em busca de problemas que `dart fix` pode reparar.
Se encontrar problemas para reparar, o VS Code exibe um prompt para lembrá-lo.

<img src="/assets/img/tools/vscode/dart_fix_notification.png" width="550" height="175" alt="VS Code notification about 'dart fix'">

Após executar `dart pub get` ou `dart pub upgrade`,
o VS Code também pode exibir este prompt se mudanças de pacote
adicionarem problemas que `dart fix` pode reparar.

Salve todos os seus arquivos antes de executar `dart fix`.
Isso garante que o Dart use as versões mais recentes dos seus arquivos.
