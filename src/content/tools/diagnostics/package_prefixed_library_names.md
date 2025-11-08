---
ia-translate: true
title: package_prefixed_library_names
description: >-
  Detalhes sobre o diagnóstico package_prefixed_library_names
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/package_prefixed_library_names"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_O nome da biblioteca não é um caminho separado por pontos prefixado pelo nome do pacote._

## Description

O analisador produz este diagnóstico quando uma biblioteca tem um nome que
não segue estas diretrizes:

- Prefixe todos os nomes de bibliotecas com o nome do pacote.
- Faça a biblioteca de entrada ter o mesmo nome do pacote.
- Para todas as outras bibliotecas em um pacote, após o nome do pacote adicione o
  caminho separado por pontos para o arquivo Dart da biblioteca.
- Para bibliotecas sob `lib`, omita o nome do diretório superior.

Por exemplo, dado um pacote chamado `my_package`, aqui estão os nomes de bibliotecas
para vários arquivos no pacote:


## Example

Assumindo que o arquivo contendo o código a seguir não está em um arquivo
chamado `special.dart` no diretório `lib` de um pacote chamado `something`
(o que seria uma exceção à regra), o analisador produz este
diagnóstico porque o nome da biblioteca não está em conformidade com as
diretrizes acima:

```dart
library [!something.special!];
```

## Common fixes

Altere o nome da biblioteca para estar em conformidade com as diretrizes.
