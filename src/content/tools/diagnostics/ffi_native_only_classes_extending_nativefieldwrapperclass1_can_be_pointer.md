---
ia-translate: true
title: ffi_native_only_classes_extending_nativefieldwrapperclass1_can_be_pointer
description: "Detalhes sobre o diagnóstico ffi_native_only_classes_extending_nativefieldwrapperclass1_can_be_pointer produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Apenas classes que estendem NativeFieldWrapperClass1 podem ser passadas como Pointer._

## Description

O analisador produz este diagnóstico quando uma função ou método anotado
com `@Native` tem um parâmetro em sua assinatura FFI que é um `Pointer`,
mas o tipo do parâmetro Dart correspondente é uma instância de classe que não
estende `NativeFieldWrapperClass1` (ou é um Pointer ou TypedData).

## Example

O código a seguir produz este diagnóstico porque `MyService` não
estende `NativeFieldWrapperClass1`, mas a assinatura `@Native` para seu
método `process` indica que o receptor deve ser passado como um `Pointer<Void>`:

```dart
import 'dart:ffi';

class MyService { // MyService does not extend NativeFieldWrapperClass1
  @Native<Void Function(Pointer<Void>, Int8)>(symbol: 'MyService_process')
  external void [!process!](int data);
}
```

## Common fixes

1.  **Se a classe Dart pretende envolver um objeto nativo:**
    Faça a classe Dart estender `NativeFieldWrapperClass1`. Esta é a
    abordagem correta se a instância da classe Dart tem um objeto nativo
    correspondente cujo ponteiro deve ser passado.
    ```dart
    import 'dart:ffi';

    class MyService extends NativeFieldWrapperClass1 {
      @Native<Void Function(Pointer<Void>, Int8)>(symbol: 'MyService_process')
      external void process(int data);
    }
    ```

2.  **Se você pretende passar um identificador opaco para o objeto Dart:**
    Altere a assinatura FFI na anotação `@Native` para usar `Handle`
    em vez de `Pointer` para o parâmetro. Isso permite passar uma
    referência ao próprio objeto Dart, com o qual o código nativo pode interagir
    usando a API C do Dart.
    ```dart
    import 'dart:ffi';

    class MyService {
      @Native<Void Function(Handle, Int8)>(symbol: 'MyService_process')
      external void process(int data);
    }
    ```
