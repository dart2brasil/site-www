---
ia-translate: true
title: Extensões nativas para a VM Dart standalone
description: A maneira original para aplicações Dart de linha de comando chamarem funções C/C++.
showToc: false
sitemap: false
---

:::note
O mecanismo de extensão que foi previamente discutido
nesta página—_native extensions_—foi removido no Dart 2.15.

Se você precisar chamar código existente escrito em C ou C++, consulte a
[documentação FFI](/server/c-interop).

Um mecanismo similar às
native extensions—a [API de Embedding do Dart][`include/dart_api.h`]—é
suportado quando a VM Dart é
embarcada como uma biblioteca em outra aplicação.
Para exemplos de como usar a API de Embedding do Dart, consulte
[estes exemplos mantidos pela comunidade][examples].
:::

[`include/dart_api.h`]: {{site.repo.dart.sdk}}/blob/main/runtime/include/dart_api.h
[examples]: https://github.com/fuzzybinary/dart_shared_libray
