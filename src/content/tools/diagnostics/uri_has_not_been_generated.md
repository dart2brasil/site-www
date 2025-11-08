---
ia-translate: true
title: uri_has_not_been_generated
description: "Detalhes sobre o diagnóstico uri_has_not_been_generated produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_O destino do URI não foi gerado: '{0}'._

## Descrição

O analisador produz este diagnóstico quando uma diretiva import, export ou part
é encontrada onde o URI se refere a um arquivo que não existe e
o nome do arquivo termina com um padrão que é comumente produzido por
geradores de código, como um dos seguintes:
- `.g.dart`
- `.pb.dart`
- `.pbenum.dart`
- `.pbserver.dart`
- `.pbjson.dart`
- `.template.dart`

## Exemplo

Se o arquivo `lib.g.dart` não existe, o código a seguir produz este
diagnóstico:

```dart
import [!'lib.g.dart'!];
```

## Correções comuns

Se o arquivo é um arquivo gerado, então execute o gerador que gera o
arquivo.

Se o arquivo não é um arquivo gerado, então verifique a ortografia do URI ou
crie o arquivo.
