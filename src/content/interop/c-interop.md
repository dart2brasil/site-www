---
ia-translate: true
title: "Interoperabilidade C usando dart:ffi"
shortTitle: C interop
description: >-
  Para usar código C no seu programa Dart, use a biblioteca dart:ffi.
---

Aplicações Dart mobile, de linha de comando e servidor
executando na [plataforma Dart Native](/overview#platform)
podem usar a biblioteca `dart:ffi` para chamar APIs C nativas,
e para ler, escrever, alocar e desalocar memória nativa.
_FFI_ significa [_foreign function interface._][FFI]
Outros termos para funcionalidades similares incluem
_native interface_ e _language bindings._

A documentação da API está disponível na
[referência da API `dart:ffi`][dart-ffi].

[FFI]: https://en.wikipedia.org/wiki/Foreign_function_interface
[dart-ffi]: {{site.dart-api}}/dart-ffi/dart-ffi-library.html

## Baixar arquivos de exemplo

Para trabalhar com os exemplos neste guia,
baixe o diretório completo de [exemplos ffi][ffi samples].
Ele inclui os seguintes exemplos que mostram como usar a biblioteca `dart:ffi`:

| **Exemplo**     | **Descrição**                                                                                                       |
| --------------- | ------------------------------------------------------------------------------------------------------------------- |
| [hello_world][] | Como chamar uma função C sem argumentos e sem valor de retorno.                                                     |
| [primitives][]  | Como chamar funções C que têm argumentos e valores de retorno que são **ints ou pointers**.                        |
| [structs][]     | Como usar structs para passar **strings** de e para C e para lidar com **estruturas C simples e complexas**.       |
| [test_utils][]  | Utilitários de teste comuns para todos estes exemplos.                                                             |

{: .table .table-striped }

[ffi samples]: {{site.repo.dart.samples}}/tree/main/ffi
[hello_world]: {{site.repo.dart.samples}}/tree/main/ffi/hello_world
[primitives]: {{site.repo.dart.samples}}/tree/main/ffi/primitives
[structs]: {{site.repo.dart.samples}}/tree/main/ffi/structs
[test_utils]: {{site.repo.dart.samples}}/tree/main/ffi/test_utils

### Revisar o exemplo hello_world

O [exemplo hello_world][hello_world] tem o código mínimo necessário
para chamar uma biblioteca C.
Este exemplo pode ser encontrado em `samples/ffi` que você baixou na
seção anterior.

[hello_world]: {{site.repo.dart.samples}}/tree/main/ffi/hello_world

#### Arquivos

O exemplo `hello_world` tem os seguintes arquivos:

| **Arquivo fonte**                  | **Descrição**                                                                                   |
|------------------------------------|-------------------------------------------------------------------------------------------------|
| [`hello.dart`][]                   | Um arquivo Dart que usa a função `hello_world()` de uma biblioteca C.                           |
| [`pubspec.yaml`][]                 | O arquivo [pubspec](/tools/pub/pubspec) do Dart, com SDK lower bound de 3.4.                    |
| [`hello_library/hello.h`][]        | Declara a função `hello_world()`.                                                               |
| [`hello_library/hello.c`][]        | Um arquivo C que importa `hello.h` e define a função `hello_world()`.                           |
| [`hello_library/hello.def`][]      | Um arquivo module-definition que especifica informações usadas ao compilar uma DLL.             |
| [`hello_library/CMakeLists.txt`][] | Um arquivo de build CMake para compilar o código C em uma biblioteca dinâmica.                  |

{: .table .table-striped }

[`hello.dart`]: {{site.repo.dart.samples}}/tree/main/ffi/hello_world/hello.dart
[`pubspec.yaml`]: {{site.repo.dart.samples}}/tree/main/ffi/hello_world/pubspec.yaml
[`hello_library/hello.h`]: {{site.repo.dart.samples}}/tree/main/ffi/hello_world/hello_library/hello.h
[`hello_library/hello.c`]: {{site.repo.dart.samples}}/tree/main/ffi/hello_world/hello_library/hello.c
[`hello_library/hello.def`]: {{site.repo.dart.samples}}/tree/main/ffi/hello_world/hello_library/hello.def
[`hello_library/CMakeLists.txt`]: {{site.repo.dart.samples}}/tree/main/ffi/hello_world/hello_library/CMakeLists.txt

Compilar a biblioteca C cria vários arquivos,
incluindo um arquivo de biblioteca dinâmica chamado
`libhello.dylib` (macOS),
`libhello.dll` (Windows), ou
`libhello.so` (Linux).

#### Compilar e executar

Os comandos para compilar a biblioteca dinâmica e executar a aplicação Dart
se assemelham à seguinte série.

```console
$ cd hello_library
$ cmake .
...
$ make
...
$ cd ..
$ dart pub get
$ dart run hello.dart
Hello World
```

:::note
**No macOS,** executáveis, incluindo a Dart VM (`dart`),
podem carregar apenas **bibliotecas assinadas.**
Para saber mais sobre assinatura de bibliotecas,
consulte o [Guia de Assinatura de Código da Apple][codesign].
:::

[codesign]: {{site.apple-dev}}/library/content/documentation/Security/Conceptual/CodeSigningGuide/Introduction/Introduction.html

#### Aproveitar dart:ffi

Para aprender como chamar uma função C usando a biblioteca `dart:ffi`,
revise o [arquivo `hello.dart`][`hello.dart`].
Esta seção explica o conteúdo deste arquivo.

1. Importe `dart:ffi`.

   ```dart
   import 'dart:ffi' as ffi;
   ```

2. Importe a biblioteca path que você usará para
   armazenar o caminho da biblioteca dinâmica.

   ```dart
   import 'dart:io' show Platform, Directory;
   import 'package:path/path.dart' as path;
   ```

3. Crie um typedef com a assinatura de tipo FFI da função C.
   Para aprender sobre os tipos mais usados de acordo com a biblioteca `dart:ffi`,
   consulte [Interface com tipos nativos](#interface-with-native-types).

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

7. Obtenha uma referência para a função C
   e coloque-a em uma variável.
   Este código usa os `typedefs` dos passos 2 e 3,
   junto com a variável da biblioteca dinâmica do passo 4.

   ```dart
   final HelloWorld hello = dylib
       .lookup<ffi.NativeFunction<hello_world_func>>('hello_world')
       .asFunction();
   ```

8. Chame a função C.

   ```dart
   hello();
   ```

Depois de entender o exemplo `hello_world`,
consulte os [outros exemplos `dart:ffi`](#download-example-files).

## Empacotar e carregar bibliotecas C

O método para empacotar / distribuir e então
carregar uma biblioteca C nativa depende da plataforma e tipo de biblioteca.

Para aprender como, consulte as seguintes páginas e exemplos.

* Flutter `dart:ffi` para aplicações [Android][android]
* Flutter `dart:ffi` para aplicações [iOS][ios]
* Flutter `dart:ffi` para aplicações [macOS][macos]
* [Exemplos `dart:ffi`][ffi-samples]

[android]: {{site.flutter-docs}}/platform-integration/android/c-interop
[ios]: {{site.flutter-docs}}/platform-integration/ios/c-interop
[macos]: {{site.flutter-docs}}/platform-integration/macos/c-interop
[ffi-samples]: {{site.repo.dart.samples}}/tree/main/ffi

## Interface com tipos nativos

A biblioteca `dart:ffi` fornece múltiplos tipos que implementam [`NativeType`][]
e representam tipos nativos em C. Você pode instanciar alguns tipos nativos.
Alguns outros tipos nativos podem ser usados apenas como marcadores em assinaturas de tipo.

[`NativeType`]: {{site.dart-api}}/dart-ffi/NativeType-class.html

### Podem instanciar estes marcadores de assinatura de tipo

Os seguintes tipos nativos podem ser usados como marcadores em assinaturas de tipo.
Eles ou seus subtipos _podem_ ser instanciados em código Dart.

| **Tipo Dart** | **Descrição**                                                    |
| ------------- | ---------------------------------------------------------------- |
| [Array][]     | Um array de tamanho fixo de itens. Supertipo de arrays de tipos específicos. |
| [Pointer][]   | Representa um pointer na memória C nativa.                       |
| [Struct][]    | O supertipo de todos os tipos struct FFI.                        |
| [Union][]     | O supertipo de todos os tipos union FFI.                         |

{: .table .table-striped }

[Array]: {{site.dart-api}}/dart-ffi/Array-class.html
[Pointer]: {{site.dart-api}}/dart-ffi/Pointer-class.html
[Struct]: {{site.dart-api}}/dart-ffi/Struct-class.html
[Union]: {{site.dart-api}}/dart-ffi/Union-class.html

### Servem apenas como marcadores de assinatura de tipo

A seguinte lista mostra quais tipos nativos agnósticos de plataforma
servem como marcadores em assinaturas de tipo.
Eles _não podem_ ser instanciados em código Dart.

| **Tipo Dart**      | **Descrição**                                      |
| ------------------ | -------------------------------------------------- |
| [Bool][]           | Representa um bool nativo em C.                    |
| [Double][]         | Representa um double de 64 bits nativo em C.       |
| [Float][]          | Representa um float de 32 bits nativo em C.        |
| [Int8][]           | Representa um inteiro signed de 8 bits nativo em C.|
| [Int16][]          | Representa um inteiro signed de 16 bits nativo em C.|
| [Int32][]          | Representa um inteiro signed de 32 bits nativo em C.|
| [Int64][]          | Representa um inteiro signed de 64 bits nativo em C.|
| [NativeFunction][] | Representa um tipo de função em C.                 |
| [Opaque][]         | O supertipo de todos os tipos opaque em C.         |
| [Uint8][]          | Representa um inteiro unsigned de 8 bits nativo em C.|
| [Uint16][]         | Representa um inteiro unsigned de 16 bits nativo em C.|
| [Uint32][]         | Representa um inteiro unsigned de 32 bits nativo em C.|
| [Uint64][]         | Representa um inteiro unsigned de 64 bits nativo em C.|
| [Void][]           | Representa o tipo `void` em C.                     |

{: .table .table-striped }

Também existem muitos tipos nativos marcadores específicos de [ABI][]
que estendem [AbiSpecificInteger][].
Para aprender como estes tipos mapeiam em plataformas específicas,
consulte a documentação da API vinculada na seguinte tabela.

| **Tipo Dart**          | **Descrição**                                           |
| ---------------------- | ------------------------------------------------------- |
| [AbiSpecificInteger][] | O supertipo de todos os tipos inteiros específicos de ABI. |
| [Int][]                | Representa o tipo `int` em C.                           |
| [IntPtr][]             | Representa o tipo `intptr_t` em C.                      |
| [Long][]               | Representa o tipo `long int` (`long`) em C.             |
| [LongLong][]           | Representa o tipo `long long` em C.                     |
| [Short][]              | Representa o tipo `short` em C.                         |
| [SignedChar][]         | Representa o tipo `signed char` em C.                   |
| [Size][]               | Representa o tipo `size_t` em C.                        |
| [UintPtr][]            | Representa o tipo `uintptr_t` em C.                     |
| [UnsignedChar][]       | Representa o tipo `unsigned char` em C.                 |
| [UnsignedInt][]        | Representa o tipo `unsigned int` em C.                  |
| [UnsignedLong][]       | Representa o tipo `unsigned long int` em C.             |
| [UnsignedLongLong][]   | Representa o tipo `unsigned long long` em C.            |
| [UnsignedShort][]      | Representa o tipo `unsigned short` em C.                |
| [WChar][]              | Representa o tipo `wchar_t` em C.                       |

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

## Gerar bindings FFI com `package:ffigen`

Para superfícies de API grandes, pode ser demorado
escrever os bindings Dart que integram com o código C.
Para fazer o Dart criar wrappers FFI a partir de arquivos header C,
use o gerador de bindings [`package:ffigen`][ffigen].

Para aprender sobre suporte para code assets em Dart FFI,
consulte a referência da API `dart:ffi` para [`Native`][]
e [`DefaultAsset`][].

[ffigen]: {{site.pub-pkg}}/ffigen
[`Native`]: {{site.dart-api}}/dart-ffi/Native-class.html
[`DefaultAsset`]: {{site.dart-api}}/dart-ffi/DefaultAsset-class.html

<a id="native-assets" aria-hidden="true"></a>

## Compilar e empacotar código nativo {: #build-hooks }

Os _build hooks_ do Dart (anteriormente conhecidos como _native assets_)
permitem que pacotes contenham code assets nativos que são
transparentemente compilados, empacotados e disponibilizados em tempo de execução.
Para mais informações, veja [Hooks][].

[Hooks]: /tools/hooks
