---
ia-translate: true
title: "Interoperabilidade com C usando dart:ffi"
description: "Para usar código C em seu programa Dart, utilize a biblioteca `dart:ffi`."
hw: "https://github.com/dart-lang/samples/tree/main/ffi/hello_world"
samples: "https://github.com/dart-lang/samples/tree/main/ffi"
---

Aplicativos Dart mobile, de linha de comando e servidor
executando na [plataforma nativa Dart](/overview#platform)
podem usar a biblioteca `dart:ffi` para chamar APIs nativas em C,
e para ler, escrever, alocar e desalocar memória nativa.
_FFI_ significa [_foreign function interface._][FFI] (interface de função externa).
Outros termos para funcionalidades similares incluem
_interface nativa_ e _bindings de linguagem._

A documentação da API está disponível na
[`referência da API dart:ffi`.]({{site.dart-api}}/dart-ffi/dart-ffi-library.html)

## Baixar arquivos de exemplo {:#download-example-files}

Para trabalhar com os exemplos neste guia,
baixe o diretório completo de [exemplos ffi]({{samples}}).
Ele inclui os seguintes exemplos que mostram como usar a biblioteca `dart:ffi`:

| **Exemplo**     | **Descrição**                                                                                         |
| --------------- | ------------------------------------------------------------------------------------------------------- |
| [hello_world][] | Como chamar uma função C sem argumentos e sem valor de retorno.                                         |
| [primitives][]  | Como chamar funções C que têm argumentos e valores de retorno que são **inteiros ou ponteiros**.            |
| [structs][]     | Como usar structs para passar **strings** para e de C e para lidar com **estruturas C simples e complexas**. |
| [test_utils][]  | Utilitários de teste comuns para todos esses exemplos.                                                     |

{:.table .table-striped }

### Revisando o exemplo hello_world {:#review-the-hello-world-example}

O [exemplo hello_world][hello_world] possui o código mínimo necessário
para chamar uma biblioteca C.
Este exemplo pode ser encontrado no diretório `samples/ffi` que você baixou na
seção anterior.

#### Arquivos {:#files}

O exemplo `hello_world` possui os seguintes arquivos:

| **Arquivo fonte**                  | **Descrição**                                                                |
|----------------------------------|--------------------------------------------------------------------------------|
| [`hello.dart`]                   | Um arquivo Dart que usa a função `hello_world()` de uma biblioteca C.           |
| [`pubspec.yaml`]                 | O arquivo [pubspec](/tools/pub/pubspec) Dart, com um limite inferior de SDK 3.4.   |
| [`hello_library/hello.h`]        | Declara a função `hello_world()`.                                         |
| [`hello_library/hello.c`]        | Um arquivo C que importa `hello.h` e define a função `hello_world()`.      |
| [`hello_library/hello.def`]      | Um arquivo de definição de módulo que especifica informações usadas ao criar um DLL. |
| [`hello_library/CMakeLists.txt`] | Um arquivo de build CMake para compilar o código C em uma biblioteca dinâmica.            |

{:.table .table-striped }

[`hello.dart`]: {{hw}}/hello.dart
[`pubspec.yaml`]: {{hw}}/pubspec.yaml
[`hello_library/hello.h`]: {{hw}}/hello_library/hello.h
[`hello_library/hello.c`]: {{hw}}/hello_library/hello.c
[`hello_library/hello.def`]: {{hw}}/hello_library/hello.def
[`hello_library/CMakeLists.txt`]: {{hw}}/hello_library/CMakeLists.txt

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
Hello World
```

:::note
**No macOS,** executáveis, incluindo a VM Dart (`dart`),
podem carregar apenas **bibliotecas assinadas.**
Para saber mais sobre assinatura de bibliotecas,
consulte o [Guia de Assinatura de Código da Apple.][codesign]
:::

[codesign]: {{site.apple-dev}}/library/content/documentation/Security/Conceptual/CodeSigningGuide/Introduction/Introduction.html

#### Utilizando dart:ffi {:#leverage-dart-ffi}

Para aprender como chamar uma função C usando a biblioteca `dart:ffi`,
revise o [arquivo `hello.dart`]({{hw}}/hello.dart).
Esta seção explica o conteúdo deste arquivo.

1. Importe `dart:ffi`.

   ```dart
   import 'dart:ffi' as ffi;
   ```

2. Importe a biblioteca `path` que você usará para armazenar o caminho da biblioteca dinâmica.

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
   var libraryPath = path.join(Directory.current.path, 'hello_library',
       'libhello.so');
   if (Platform.isMacOS) {
     libraryPath = path.join(Directory.current.path, 'hello_library',
         'libhello.dylib');
   } else if (Platform.isWindows) {
     libraryPath = path.join(Directory.current.path, 'hello_library',
         'Debug', 'hello.dll');
   }
   ```

6. Abra a biblioteca dinâmica que contém a função C.

   ```dart
   final dylib = ffi.DynamicLibrary.open(libraryPath);
   ```

7. Obtenha uma referência à função C,
   e coloque-a em uma variável.
   Este código usa os `typedefs` das etapas 2 e 3,
   junto com a variável da biblioteca dinâmica da etapa 4.
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

* Flutter `dart:ffi` para aplicativos [Android][android]
* Flutter `dart:ffi` para aplicativos [iOS][ios]
* Flutter `dart:ffi` para aplicativos [macOS][macos]
* [Exemplos `dart:ffi`]({{samples}})

## Interagindo com tipos nativos {:#interface-with-native-types}

A biblioteca `dart:ffi` fornece múltiplos tipos que implementam [`NativeType`][]
e representam tipos nativos em C. Você pode instanciar alguns tipos nativos.
Alguns outros tipos nativos podem ser usados apenas como marcadores em assinaturas de tipo.

### Pode instanciar esses marcadores de assinatura de tipo {:#can-instantiate-these-type-signature-markers}

Os seguintes tipos nativos podem ser usados como marcadores em assinaturas de tipo.
Eles ou seus subtipos _podem_ ser instanciados em código Dart.

{% capture dart-ffi -%}
{{site.dart-api}}/dart-ffi
{%- endcapture %}

| **Tipo Dart**   | **Descrição**                                                  |
| --------------- | ---------------------------------------------------------------- |
| [Array][]       | Um array de tamanho fixo de itens. Supertipo de arrays específicos de tipo. |
| [Pointer][]     | Representa um ponteiro para a memória nativa C.                       |
| [Struct][]      | O supertipo de todos os tipos de struct FFI.                           |
| [Union][]       | O supertipo de todos os tipos de union FFI.                            |

{:.table .table-striped }

### Servem apenas como marcadores de assinatura de tipo {:#serve-as-type-signature-markers-only}

A lista a seguir mostra quais tipos nativos agnósticos de plataforma
servem como marcadores em assinaturas de tipo.
Eles _não podem_ ser instanciados em código Dart.

| **Tipo Dart**      | **Descrição**                                   |
| ------------------ | ------------------------------------------------- |
| [Bool][]           | Representa um bool nativo em C.                    |
| [Double][]         | Representa um double nativo de 64 bits em C.           |
| [Float][]          | Representa um float nativo de 32 bits em C.            |
| [Int8][]           | Representa um inteiro nativo com sinal de 8 bits em C.    |
| [Int16][]          | Representa um inteiro nativo com sinal de 16 bits em C.   |
| [Int32][]          | Representa um inteiro nativo com sinal de 32 bits em C.   |
| [Int64][]          | Representa um inteiro nativo com sinal de 64 bits em C.   |
| [NativeFunction][] | Representa um tipo de função em C.                  |
| [Opaque][]         | O supertipo de todos os tipos opacos em C.           |
| [Uint8][]          | Representa um inteiro nativo sem sinal de 8 bits em C.  |
| [Uint16][]         | Representa um inteiro nativo sem sinal de 16 bits em C. |
| [Uint32][]         | Representa um inteiro nativo sem sinal de 32 bits em C. |
| [Uint64][]         | Representa um inteiro nativo sem sinal de 64 bits em C. |
| [Void][]           | Representa o tipo `void` em C.                  |

{:.table .table-striped }

Há também muitos tipos nativos marcadores específicos de [ABI][]
que estendem [AbiSpecificInteger][].
Para saber como esses tipos são mapeados em plataformas específicas,
consulte a documentação da API vinculada na tabela a seguir.

| **Tipo Dart**            | **Descrição**                                    |
| -------------------------| -------------------------------------------------- |
| [AbiSpecificInteger][]   | O supertipo de todos os tipos de inteiros específicos de ABI.   |
| [Int][]                  | Representa o tipo `int` em C.                    |
| [IntPtr][]               | Representa o tipo `intptr_t` em C.               |
| [Long][]                 | Representa o tipo `long int` (`long`) em C.      |
| [LongLong][]             | Representa o tipo `long long` em C.              |
| [Short][]                | Representa o tipo `short` em C.                  |
| [SignedChar][]           | Representa o tipo `signed char` em C.            |
| [Size][]                 | Representa o tipo `size_t` em C.                 |
| [UintPtr][]              | Representa o tipo `uintptr_t` em C.              |
| [UnsignedChar][]         | Representa o tipo `unsigned char` em C.          |
| [UnsignedInt][]          | Representa o tipo `unsigned int` em C.           |
| [UnsignedLong][]         | Representa o tipo `unsigned long int` em C.      |
| [UnsignedLongLong][]     | Representa o tipo `unsigned long long` em C.     |
| [UnsignedShort][]        | Representa o tipo `unsigned short` em C.         |
| [WChar][]                | Representa o tipo `wchar_t` em C.                |

{:.table .table-striped }

## Gerando bindings FFI com `package:ffigen` {:#generate-ffi-bindings-with-package-ffigen}

Para grandes superfícies de API, pode ser demorado
escrever os bindings Dart que se integram ao código C.
Para que o Dart crie wrappers FFI a partir de arquivos de cabeçalho C,
use o gerador de bindings [`package:ffigen`][ffigen].

## Compilar e empacotar assets nativos {:#native-assets}

:::note
O recurso de _Assets Nativos_ é **experimental**,
e está [em desenvolvimento ativo]({{site.repo.dart.sdk}}/issues/50565).
:::

O recurso _Assets Nativos_ deve resolver uma série de problemas associados à
distribuição de pacotes Dart que dependem de código nativo.
Ele faz isso fornecendo ganchos uniformes para integração com vários
sistemas de build envolvidos na construção de aplicativos Flutter e Dart autônomos.

Este recurso deve simplificar como os pacotes Dart dependem e usam código nativo.
Os Assets Nativos devem fornecer os seguintes benefícios:

* Compilar o código nativo ou obter os binários
  usando um gancho de build `hook/build.dart` do pacote.
* Empacotar o [`Asset`][] nativo que o gancho de build `build.dart` relata.
* Tornar os assets nativos disponíveis em tempo de execução por meio de
  funções declarativas `@Native<>() extern` usando o [`assetId`][].

Quando você [opta por participar](#opt-in-to-the-experiment) do experimento nativo,
os comandos `flutter (run|build)` e `dart (run|build)`
compilam e empacotam o código nativo com o código Dart.

### Revisando o exemplo `native_add_library` {:#review-the-native-add-library-example}

O exemplo [`native_add_library`][] inclui o código mínimo para
compilar e empacotar código C em um pacote Dart.

O exemplo inclui os seguintes arquivos:

{% capture native-assets -%}
{{site.repo.dart.org}}/native/blob/main/pkgs/native_assets_cli/example/build/native_add_library
{%- endcapture %}

| **Arquivo fonte**                         | **Descrição**                                                                                                                                                                |
------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| [`src/native_add_library.c`][]          | O arquivo C contendo o código para `add`.                                                                                                                                      |
| [`lib/native_add_library.dart`][]       | O arquivo Dart que invoca a função C `add` no asset `package:native_add_library/native_add_library.dart` por meio de FFI. (Observe que o _id do asset_ é o URI da biblioteca por padrão.) |
| [`test/native_add_library_test.dart`][] | Um teste Dart usando o código nativo.                                                                                                                                             |
| [`hook/build.dart`][]                   | Um gancho de build para compilar `src/native_add_library.c` e declarar o asset compilado com o id `package:native_add_library/native_add_library.dart`.                              |

{:.table .table-striped }

[`src/native_add_library.c`]: {{native-assets}}/src/native_add_library.c
[`lib/native_add_library.dart`]: {{native-assets}}/lib/native_add_library.dart
[`test/native_add_library_test.dart`]: {{native-assets}}/test/native_add_library_test.dart
[`hook/build.dart`]: {{native-assets}}/hook/build.dart

Quando um projeto Dart ou Flutter depende de `package:native_add_library`,
ele invoca o gancho de build `hook/build.dart` nos comandos `run`, `build` e `test`.
O exemplo [`native_add_app`][] mostra um uso de `native_add_library`.

### Revisando a documentação da API de Assets Nativos {:#review-native-asset-api-documentation}

A documentação da API pode ser encontrada para os seguintes pacotes:

* Para saber mais sobre assets nativos em Dart FFI,
  consulte a referência da API `dart:ffi` para [`Native`][] e [`DefaultAsset`][].
* Para saber mais sobre o gancho de build `hook/build.dart`,
  consulte a [`referência da API package:native_assets_cli`][].

### Optando por participar do experimento {:#opt-in-to-the-experiment}

Para aprender como habilitar o experimento e fornecer feedback,
consulte essas questões de acompanhamento:

* [Assets nativos Dart]({{site.repo.dart.sdk}}/issues/50565)
* [Assets nativos Flutter](https://github.com/flutter/flutter/issues/129757)

[`Asset`]: {{site.pub-api}}/native_assets_cli/latest/native_assets_cli/Asset-class.html
[`assetId`]: {{site.dart-api}}/dart-ffi/Native/assetId.html
[`DefaultAsset`]: {{site.dart-api}}/dart-ffi/DefaultAsset-class.html
[`native_add_app`]: {{site.repo.dart.org}}/native/tree/main/pkgs/native_assets_cli/example/build/native_add_app
[`native_add_library`]: {{native-assets}}
[`Native`]: {{site.dart-api}}/dart-ffi/Native-class.html
[`NativeType`]: {{dart-ffi}}/NativeType-class.html
[`package:native_assets_cli` API reference]: {{site.pub-api}}/native_assets_cli/latest/
[ABI]: {{dart-ffi}}/Abi-class.html
[AbiSpecificInteger]: {{dart-ffi}}/AbiSpecificInteger-class.html
[android]: {{site.flutter-docs}}/development/platform-integration/android/c-interop
[Bool]: {{dart-ffi}}/Bool-class.html
[Double]: {{dart-ffi}}/Double-class.html
[FFI]: https://en.wikipedia.org/wiki/Foreign_function_interface
[ffigen]: {{site.pub-pkg}}/ffigen
[Float]: {{dart-ffi}}/Float-class.html
[hello_world]: {{hw}}
[Int]: {{dart-ffi}}/Int-class.html
[Int16]: {{dart-ffi}}/Int16-class.html
[Int32]: {{dart-ffi}}/Int32-class.html
[Int64]: {{dart-ffi}}/Int64-class.html
[Int8]: {{dart-ffi}}/Int8-class.html
[IntPtr]: {{dart-ffi}}/IntPtr-class.html
[ios]: {{site.flutter-docs}}/development/platform-integration/ios/c-interop
[Long]: {{dart-ffi}}/Long-class.html
[LongLong]: {{dart-ffi}}/LongLong-class.html
[macos]: {{site.flutter-docs}}/development/platform-integration/macos/c-interop
[NativeFunction]: {{dart-ffi}}/NativeFunction-class.html
[Opaque]: {{dart-ffi}}/Opaque-class.html
[primitives]: {{samples}}/primitives
[Short]: {{dart-ffi}}/Short-class.html
[SignedChar]: {{dart-ffi}}/SignedChar-class.html
[Size]: {{dart-ffi}}/Size-class.html
[structs]: {{samples}}/structs
[test_utils]: {{samples}}/test_utils
[Uint16]: {{dart-ffi}}/Uint16-class.html
[Uint32]: {{dart-ffi}}/Uint32-class.html
[Uint64]: {{dart-ffi}}/Uint64-class.html
[Uint8]: {{dart-ffi}}/Uint8-class.html
[UintPtr]: {{dart-ffi}}/UintPtr-class.html
[UnsignedChar]: {{dart-ffi}}/UnsignedChar-class.html
[UnsignedInt]: {{dart-ffi}}/UnsignedInt-class.html
[UnsignedLong]: {{dart-ffi}}/UnsignedLong-class.html
[UnsignedLongLong]: {{dart-ffi}}/UnsignedLongLong-class.html
[UnsignedShort]: {{dart-ffi}}/UnsignedShort-class.html
[Void]: {{dart-ffi}}/Void-class.html
[WChar]: {{dart-ffi}}/WChar-class.html
[Array]: {{dart-ffi}}/Array-class.html
[Pointer]: {{dart-ffi}}/Pointer-class.html
[Struct]: {{dart-ffi}}/Struct-class.html
[Union]: {{dart-ffi}}/Union-class.html

