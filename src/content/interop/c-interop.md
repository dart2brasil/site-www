---
title: "C interop using dart:ffi"
shortTitle: C interop
description: >-
  To use C code in your Dart program, use the dart:ffi library.
---

Aplicativos Dart mobile, de linha de comando e servidor
executando na [plataforma nativa Dart](/overview#platform)
podem usar a biblioteca `dart:ffi` para chamar APIs nativas em C,
e para ler, escrever, alocar e desalocar memória nativa.
_FFI_ significa [_foreign function interface._][FFI] (interface de função externa).
Outros termos para funcionalidades similares incluem
_interface nativa_ e _bindings de linguagem._

API documentation is available in the
[`dart:ffi` API reference][dart-ffi].

[FFI]: https://en.wikipedia.org/wiki/Foreign_function_interface
[dart-ffi]: {{site.dart-api}}/dart-ffi/dart-ffi-library.html

## Baixar arquivos de exemplo {:#download-example-files}

To work with the examples in this guide,
download the full [ffi samples][] directory.
It includes the following examples show how to use the `dart:ffi` library:

| **Exemplo**     | **Descrição**                                                                                         |
| --------------- | ------------------------------------------------------------------------------------------------------- |
| [hello_world][hello_world] | Como chamar uma função C sem argumentos e sem valor de retorno.                                         |
| [primitives][primitives]  | Como chamar funções C que têm argumentos e valores de retorno que são **inteiros ou ponteiros**.            |
| [structs][structs]     | Como usar structs para passar **strings** para e de C e para lidar com **estruturas C simples e complexas**. |
| [test_utils][test_utils]  | Utilitários de teste comuns para todos esses exemplos.                                                     |

{: .table .table-striped }

[ffi samples]: {{site.repo.dart.samples}}/tree/main/ffi
[hello_world]: {{site.repo.dart.samples}}/tree/main/ffi/hello_world
[primitives]: {{site.repo.dart.samples}}/tree/main/ffi/primitives
[structs]: {{site.repo.dart.samples}}/tree/main/ffi/structs
[test_utils]: {{site.repo.dart.samples}}/tree/main/ffi/test_utils

### Revisando o exemplo hello_world {:#review-the-hello-world-example}

O [exemplo hello_world][hello_world] possui o código mínimo necessário
para chamar uma biblioteca C.
Este exemplo pode ser encontrado no diretório `samples/ffi` que você baixou na
seção anterior.

[hello_world]: {{site.repo.dart.samples}}/tree/main/ffi/hello_world

#### Files

O exemplo `hello_world` possui os seguintes arquivos:

| **Source file**                    | **Description**                                                                |
|------------------------------------|--------------------------------------------------------------------------------|
| [`hello.dart`][]                   | A Dart file that uses the `hello_world()` function from a C library.           |
| [`pubspec.yaml`][]                 | The Dart [pubspec](/tools/pub/pubspec) file, with an SDK lower bound of 3.4.   |
| [`hello_library/hello.h`][]        | Declares the `hello_world()` function.                                         |
| [`hello_library/hello.c`][]        | A C file that imports `hello.h` and defines the `hello_world()` function.      |
| [`hello_library/hello.def`][]      | A module-definition file which specifies information used when building a DLL. |
| [`hello_library/CMakeLists.txt`][] | A CMake build file for compiling the C code into a dynamic library.            |

{: .table .table-striped }

[`hello.dart`]: {{site.repo.dart.samples}}/tree/main/ffi/hello_world/hello.dart
[`pubspec.yaml`]: {{site.repo.dart.samples}}/tree/main/ffi/hello_world/pubspec.yaml
[`hello_library/hello.h`]: {{site.repo.dart.samples}}/tree/main/ffi/hello_world/hello_library/hello.h
[`hello_library/hello.c`]: {{site.repo.dart.samples}}/tree/main/ffi/hello_world/hello_library/hello.c
[`hello_library/hello.def`]: {{site.repo.dart.samples}}/tree/main/ffi/hello_world/hello_library/hello.def
[`hello_library/CMakeLists.txt`]: {{site.repo.dart.samples}}/tree/main/ffi/hello_world/hello_library/CMakeLists.txt

A compilação da biblioteca C cria vários arquivos,
incluindo um arquivo de biblioteca dinâmica chamado
`libhello.dylib` (macOS),
`libhello.dll` (Windows) ou
`libhello.so` (Linux).

#### Compilar e executar {:#build-and-execute}

Os comandos para compilar a biblioteca dinâmica e executar o aplicativo Dart seriam
semelhantes à seguinte sequência.

```console
$ cd hello_library
$ cmake .
...
$ make
...
$ cd ..
$ dart pub get
$ dart run hello.dart
Olá Mundo
```

:::note
**No macOS,** executáveis, incluindo a VM Dart (`dart`),
podem carregar apenas **bibliotecas assinadas.**
Para saber mais sobre assinatura de bibliotecas,
consulte o [Guia de Assinatura de Código da Apple.][codesign]
:::

[codesign]: {{site.apple-dev}}/library/content/documentation/Security/Conceptual/CodeSigningGuide/Introduction/Introduction.html

#### Utilizando dart:ffi {:#leverage-dart-ffi}

To learn how to call a C function using the `dart:ffi` library,
review the [`hello.dart` file][`hello.dart`].
This section explains the contents of this file.

1. Importe `dart:ffi`.

   ```dart
   import 'dart:ffi' as ffi;
   ```

2. Import the path library that you'll use to
   store the path of the dynamic library.

   ```dart
   import 'dart:io' show Platform, Directory;
   import 'package:path/path.dart' as path;
   ```

3. Crie um `typedef` com a assinatura de tipo FFI da função C.  
   Para saber mais sobre os tipos mais usados de acordo com a biblioteca `dart:ffi`,
   consulte [Interagindo com tipos nativos](#interface-with-native-types).

   ```dart
   typedef hello_world_func = ffi.Void Function();
   ```

4. Crie um `typedef` para a variável a ser usada ao chamar a função C.

   ```dart
   typedef HelloWorld = void Function();
   ```

5. Crie uma variável para armazenar o caminho da biblioteca dinâmica.

   ```dart
   final String libraryPath;
   if (Platform.isMacOS) {
     libraryPath = path.join(
       Directory.current.path,
       'hello_library',
       'libhello.dylib',
     );
   } else if (Platform.isWindows) {
     libraryPath = path.join(
       Directory.current.path,
       'hello_library',
       'Debug',
       'hello.dll',
     );
   } else {
     libraryPath = path.join(
       Directory.current.path,
       'hello_library',
       'libhello.so',
     );
   }
   ```

6. Abra a biblioteca dinâmica que contém a função C.

   ```dart
   final dylib = ffi.DynamicLibrary.open(libraryPath);
   ```

7. Get a reference to the C function,
   and put it into a variable.
   This code uses the `typedefs` from steps 2 and 3,
   along with the dynamic library variable from step 4.

   ```dart
   final HelloWorld hello = dylib
       .lookup<ffi.NativeFunction<hello_world_func>>('hello_world')
       .asFunction();
   ```

8. Chame a função C.

   ```dart
   hello();
   ```

Assim que você entender o exemplo `hello_world`,
consulte os [outros exemplos `dart:ffi`](#download-example-files).

## Empacotar e carregar bibliotecas C {:#bundle-and-load-c-libraries}

O método para empacotar/distribuir e então
carregar uma biblioteca C nativa depende da plataforma e do tipo de biblioteca.

Para aprender como, consulte as seguintes páginas e exemplos.

* Flutter `dart:ffi` for [Android][android] apps
* Flutter `dart:ffi` for [iOS][ios] apps
* Flutter `dart:ffi` for [macOS][macos] apps
* [`dart:ffi` examples][ffi-samples]

[android]: {{site.flutter-docs}}/platform-integration/android/c-interop
[ios]: {{site.flutter-docs}}/platform-integration/ios/c-interop
[macos]: {{site.flutter-docs}}/platform-integration/macos/c-interop
[ffi-samples]: {{site.repo.dart.samples}}/tree/main/ffi

## Interagindo com tipos nativos {:#interface-with-native-types}

A biblioteca `dart:ffi` fornece múltiplos tipos que implementam [`NativeType`][`NativeType`]
e representam tipos nativos em C. Você pode instanciar alguns tipos nativos.
Alguns outros tipos nativos podem ser usados apenas como marcadores em assinaturas de tipo.

[`NativeType`]: {{site.dart-api}}/dart-ffi/NativeType-class.html

### Can instantiate these type signature markers

Os seguintes tipos nativos podem ser usados como marcadores em assinaturas de tipo.
Eles ou seus subtipos _podem_ ser instanciados em código Dart.

| **Dart type** | **Description**                                                  |
| ------------- | ---------------------------------------------------------------- |
| [Array][]     | A fixed-sized array of items. Supertype of type specific arrays. |
| [Pointer][]   | Represents a pointer into native C memory.                       |
| [Struct][]    | The supertype of all FFI struct types.                           |
| [Union][]     | The supertype of all FFI union types.                            |

{: .table .table-striped }

[Array]: {{site.dart-api}}/dart-ffi/Array-class.html
[Pointer]: {{site.dart-api}}/dart-ffi/Pointer-class.html
[Struct]: {{site.dart-api}}/dart-ffi/Struct-class.html
[Union]: {{site.dart-api}}/dart-ffi/Union-class.html

### Servem apenas como marcadores de assinatura de tipo {:#serve-as-type-signature-markers-only}

A lista a seguir mostra quais tipos nativos agnósticos de plataforma
servem como marcadores em assinaturas de tipo.
Eles _não podem_ ser instanciados em código Dart.

| **Tipo Dart**                    | **Descrição**                                           |
| -------------------------------- | ------------------------------------------------------- |
| [Bool][Bool]                     | Representa um bool nativo em C.                         |
| [Double][Double]                 | Representa um double nativo de 64 bits em C.            |
| [Float][Float]                   | Representa um float nativo de 32 bits em C.             |
| [Int8][Int8]                     | Representa um inteiro nativo com sinal de 8 bits em C.  |
| [Int16][Int16]                   | Representa um inteiro nativo com sinal de 16 bits em C. |
| [Int32][Int32]                   | Representa um inteiro nativo com sinal de 32 bits em C. |
| [Int64][Int64]                   | Representa um inteiro nativo com sinal de 64 bits em C. |
| [NativeFunction][NativeFunction] | Representa um tipo de função em C.                      |
| [Opaque][Opaque]                 | O supertipo de todos os tipos opacos em C.              |
| [Uint8][Uint8]                   | Representa um inteiro nativo sem sinal de 8 bits em C.  |
| [Uint16][Uint16]                 | Representa um inteiro nativo sem sinal de 16 bits em C. |
| [Uint32][Uint32]                 | Representa um inteiro nativo sem sinal de 32 bits em C. |
| [Uint64][Uint64]                 | Representa um inteiro nativo sem sinal de 64 bits em C. |
| [Void][Void]                     | Representa o tipo `void` em C.                  |

{: .table .table-striped }

Há também muitos tipos nativos marcadores específicos de [ABI][ABI]
que estendem [AbiSpecificInteger][AbiSpecificInteger].
Para saber como esses tipos são mapeados em plataformas específicas,
consulte a documentação da API vinculada na tabela a seguir.

| **Dart type**          | **Description**                                  |
| ---------------------- | ------------------------------------------------ |
| [AbiSpecificInteger][] | The supertype of all ABI-specific integer types. |
| [Int][]                | Represents the `int` type in C.                  |
| [IntPtr][]             | Represents the `intptr_t` type in C.             |
| [Long][]               | Represents the `long int` (`long`) type in C.    |
| [LongLong][]           | Represents the `long long` type in C.            |
| [Short][]              | Represents the `short` type in C.                |
| [SignedChar][]         | Represents the `signed char` type in C.          |
| [Size][]               | Represents the `size_t` type in C.               |
| [UintPtr][]            | Represents the `uintptr_t` type in C.            |
| [UnsignedChar][]       | Represents the `unsigned char` type in C.        |
| [UnsignedInt][]        | Represents the `unsigned int` type in C.         |
| [UnsignedLong][]       | Represents the `unsigned long int` type in C.    |
| [UnsignedLongLong][]   | Represents the `unsigned long long` type in C.   |
| [UnsignedShort][]      | Represents the `unsigned short` type in C.       |
| [WChar][]              | Represents the `wchar_t` type in C.              |

{: .table .table-striped }

[Bool]: {{site.dart-api}}/dart-ffi/Bool-class.html
[Double]: {{site.dart-api}}/dart-ffi/Double-class.html
[Float]: {{site.dart-api}}/dart-ffi/Float-class.html
[Int8]: {{site.dart-api}}/dart-ffi/Int8-class.html
[Int16]: {{site.dart-api}}/dart-ffi/Int16-class.html
[Int32]: {{site.dart-api}}/dart-ffi/Int32-class.html
[Int64]: {{site.dart-api}}/dart-ffi/Int64-class.html
[NativeFunction]: {{site.dart-api}}/dart-ffi/NativeFunction-class.html
[Opaque]: {{site.dart-api}}/dart-ffi/Opaque-class.html
[Uint16]: {{site.dart-api}}/dart-ffi/Uint16-class.html
[Uint32]: {{site.dart-api}}/dart-ffi/Uint32-class.html
[Uint64]: {{site.dart-api}}/dart-ffi/Uint64-class.html
[Uint8]: {{site.dart-api}}/dart-ffi/Uint8-class.html
[Void]: {{site.dart-api}}/dart-ffi/Void-class.html

[ABI]: {{site.dart-api}}/dart-ffi/Abi-class.html
[AbiSpecificInteger]: {{site.dart-api}}/dart-ffi/AbiSpecificInteger-class.html
[Int]: {{site.dart-api}}/dart-ffi/Int-class.html
[IntPtr]: {{site.dart-api}}/dart-ffi/IntPtr-class.html
[Long]: {{site.dart-api}}/dart-ffi/Long-class.html
[LongLong]: {{site.dart-api}}/dart-ffi/LongLong-class.html
[Short]: {{site.dart-api}}/dart-ffi/Short-class.html
[SignedChar]: {{site.dart-api}}/dart-ffi/SignedChar-class.html
[Size]: {{site.dart-api}}/dart-ffi/Size-class.html
[UintPtr]: {{site.dart-api}}/dart-ffi/UintPtr-class.html
[UnsignedChar]: {{site.dart-api}}/dart-ffi/UnsignedChar-class.html
[UnsignedInt]: {{site.dart-api}}/dart-ffi/UnsignedInt-class.html
[UnsignedLong]: {{site.dart-api}}/dart-ffi/UnsignedLong-class.html
[UnsignedLongLong]: {{site.dart-api}}/dart-ffi/UnsignedLongLong-class.html
[UnsignedShort]: {{site.dart-api}}/dart-ffi/UnsignedShort-class.html
[WChar]: {{site.dart-api}}/dart-ffi/WChar-class.html

## Gerando bindings FFI com `package:ffigen` {:#generate-ffi-bindings-with-package-ffigen}

Para grandes superfícies de API, pode ser demorado
escrever os bindings Dart que se integram ao código C.
Para que o Dart crie wrappers FFI a partir de arquivos de cabeçalho C,
use o gerador de bindings [`package:ffigen`][ffigen].

To learn about support for code assets in Dart FFI,
consult the `dart:ffi` API reference for [`Native`][]
and [`DefaultAsset`][].

[ffigen]: {{site.pub-pkg}}/ffigen
[`Native`]: {{site.dart-api}}/dart-ffi/Native-class.html
[`DefaultAsset`]: {{site.dart-api}}/dart-ffi/DefaultAsset-class.html

<a id="native-assets" aria-hidden="true"></a>

## Build and bundle native code {: #build-hooks }

Dart _build hooks_ (formerly known as _native assets_)
enable packages to contain native code assets that are
transparently built, bundled, and made available at runtime.
For more information, see [Hooks][].

[Hooks]: /tools/hooks
