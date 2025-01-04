---
ia-translate: true
title: Extensões nativas para a VM Dart autônoma
description: A forma original para aplicativos Dart de linha de comando chamarem funções C/C++.
toc: false
---

:::note
O mecanismo de extensão que foi discutido anteriormente
nesta página — _extensões nativas_ — foi removido no Dart 2.15.

Se você precisar chamar código existente escrito em C ou C++, consulte a
[documentação FFI](/server/c-interop).

Um mecanismo semelhante às
extensões nativas — a [Dart Embedding API][`include/dart_api.h`] (API de incorporação Dart) — é
compatível quando a VM Dart é
incorporada como uma biblioteca em outro aplicativo.
Para exemplos de como usar a Dart Embedding API, veja
[estes exemplos mantidos pela comunidade][examples].
:::

[`include/dart_api.h`]: {{site.repo.dart.sdk}}/blob/main/runtime/include/dart_api.h
[examples]: https://github.com/fuzzybinary/dart_shared_libray
