---
ia-translate: true
title: "Interoperação com C usando dart:ffi"
description: "Para usar código C em seu programa Dart, use a biblioteca dart:ffi."
hw: "https://github.com/dart-lang/samples/tree/main/ffi/hello_world"
samples: "https://github.com/dart-lang/samples/tree/main/ffi"
---

Aplicativos Dart para mobile, linha de comando e servidor
executados na [plataforma Dart Native](/overview#platform)
podem usar a biblioteca `dart:ffi` para chamar APIs C nativas,
e para ler, escrever, alocar e desalocar memória nativa.
_FFI_ significa [_interface de função estrangeira_][FFI].
Outros termos para funcionalidades semelhantes incluem
_interface nativa_ e _ligações de linguagem._

A documentação da API está disponível na
[referência da API `dart:ffi`.]({{site.dart-api}}/dart-ffi/dart-ffi-library.html)

## Baixar arquivos de exemplo

Para trabalhar com os exemplos neste guia,
baixe o diretório completo [exemplos de ffi]({{samples}}).
Ele inclui os seguintes exemplos que mostram como usar a biblioteca `dart:ffi`:

| **Exemplo**          | **Descrição**                                                                                             |
| -------------------- | --------------------------------------------------------------------------------------------------------- |
| [hello_world][hello_world] | Como chamar uma função C sem argumentos e sem valor de retorno.                                             |
| [primitives][primitives]  | Como chamar funções C que têm argumentos e retornam valores que são **ints ou ponteiros**.              |
| [structs][structs]     | Como usar structs para passar **strings** para e de C e para lidar com **estruturas C simples e complexas**. |
| [test_utils][test_utils]  | Utilitários de teste comuns para todos esses exemplos.                                                       |

{:.table .table-striped }

### Revisar o exemplo hello_world

O [exemplo hello_world][hello_world] tem o código mínimo necessário
para chamar uma biblioteca C.
Este exemplo pode ser encontrado em `samples/ffi` que você baixou na
seção anterior.

#### Arquivos

O exemplo `hello_world` tem os seguintes arquivos:

| **Arquivo fonte**                | **Descrição**                                                                    |
| -------------------------------- | -------------------------------------------------------------------------------- |
| [`hello.dart`]                   | Um arquivo Dart que usa a função `hello_world()` de uma biblioteca C.           |
| [`pubspec.yaml`]                 | O arquivo [pubspec](/tools/pub/pubspec) do Dart, com um limite inferior de SDK de 3.4. |
| [`hello_library/hello.h`]        | Declara a função `hello_world()`.                                               |
| [`hello_library/hello.c`]        | Um arquivo C que importa `hello.h` e define a função `hello_world()`.            |
| [`hello_library/hello.def`]      | Um arquivo de definição de módulo que especifica informações usadas ao construir uma DLL.   |
| [`hello_library/CMakeLists.txt`] | Um arquivo de compilação CMake para compilar o código C em uma biblioteca dinâmica. |

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

#### Compilar e executar

Os comandos para construir a biblioteca dinâmica e executar o aplicativo Dart seriam
semelhantes à seguinte série.

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
Para saber mais sobre como assinar bibliotecas,
consulte o [Guia de Assinatura de Código][codesign] da Apple.
:::

[codesign]: {{site.apple-dev}}/library/content/documentation/Security/Conceptual/CodeSigningGuide/Introduction/Introduction.html

#### Aproveitar o dart:ffi

Para aprender como chamar uma função C usando a biblioteca `dart:ffi`,
revise o [arquivo `hello.dart`]({{hw}}/hello.dart).
Esta seção explica o conteúdo deste arquivo.

1. Importe `dart:ffi`.

   ```dart
   import 'dart:ffi' as ffi;
   ```

2. Importe a biblioteca de path que você usará para armazenar o caminho da biblioteca dinâmica.

   ```dart
   import 'dart:io' show Platform, Directory;
   import 'package:path/path.dart' as path;
   ```

3. Crie um typedef com a assinatura de tipo FFI da função C.
   Para saber mais sobre os tipos mais usados de acordo com a biblioteca `dart:ffi`
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

7. Obtenha uma referência para a função C,
   e coloque-a em uma variável.
   Este código usa os `typedefs` das etapas 2 e 3,
   juntamente com a variável de biblioteca dinâmica da etapa 4.
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
consulte os [outros exemplos `dart:ffi`](#baixar-arquivos-de-exemplo).

## Agrupar e carregar bibliotecas C

O método para agrupar / empacotar / distribuir e então
carregar uma biblioteca C nativa depende da plataforma e do tipo de biblioteca.

Para saber como, consulte as seguintes páginas e exemplos.

* Flutter `dart:ffi` para aplicativos [Android][android]
* Flutter `dart:ffi` para aplicativos [iOS][ios]
* Flutter `dart:ffi` para aplicativos [macOS][macos]
* [Exemplos `dart:ffi`]({{samples}})

## Interface com tipos nativos

A biblioteca `dart:ffi` fornece vários tipos que implementam [`NativeType`][`NativeType`]
e representam tipos nativos em C. Você pode instanciar alguns tipos nativos.
Alguns outros tipos nativos podem ser usados apenas como marcadores em assinaturas de tipo.

### Pode instanciar esses marcadores de assinatura de tipo

Os seguintes tipos nativos podem ser usados como marcadores em assinaturas de tipo.
Eles ou seus subtipos _podem_ ser instanciados no código Dart.

{% capture dart-ffi -%}
{{site.dart-api}}/dart-ffi
{%- endcapture %}

| **Tipo Dart**     | **Descrição**                                                    |
| ----------------- | ------------------------------------------------------------------ |
| [Array][Array]          | Um array de tamanho fixo de itens. Supertipo de arrays específicos de tipo. |
| [Pointer][Pointer]        | Representa um ponteiro para a memória C nativa.                     |
| [Struct][Struct]         | O supertipo de todos os tipos de struct FFI.                          |
| [Union][Union]          | O supertipo de todos os tipos de union FFI.                           |

{:.table .table-striped }

### Servem como marcadores de assinatura de tipo apenas

A lista a seguir mostra quais tipos nativos independentes de plataforma
que servem como marcadores em assinaturas de tipo.
Eles _não podem_ ser instanciados no código Dart.

| **Tipo Dart**       | **Descrição**                                     |
| ------------------- | --------------------------------------------------- |
| [Bool][Bool]            | Representa um bool nativo em C.                      |
| [Double][Double]          | Representa um double nativo de 64 bits em C.        |
| [Float][Float]           | Representa um float nativo de 32 bits em C.         |
| [Int8][Int8]            | Representa um inteiro nativo de 8 bits com sinal em C. |
| [Int16][Int16]           | Representa um inteiro nativo de 16 bits com sinal em C. |
| [Int32][Int32]           | Representa um inteiro nativo de 32 bits com sinal em C. |
| [Int64][Int64]           | Representa um inteiro nativo de 64 bits com sinal em C. |
| [NativeFunction][NativeFunction]  | Representa um tipo de função em C.                  |
| [Opaque][Opaque]          | O supertipo de todos os tipos opacos em C.            |
| [Uint8][Uint8]           | Representa um inteiro nativo de 8 bits sem sinal em C. |
| [Uint16][Uint16]          | Representa um inteiro nativo de 16 bits sem sinal em C.|
| [Uint32][Uint32]          | Representa um inteiro nativo de 32 bits sem sinal em C.|
| [Uint64][Uint64]          | Representa um inteiro nativo de 64 bits sem sinal em C.|
| [Void][Void]            | Representa o tipo `void` em C.                     |

{:.table .table-striped }

Há também muitos tipos nativos de marcadores específicos de [ABI][ABI]
que estendem [AbiSpecificInteger][AbiSpecificInteger].
Para saber como esses tipos mapeiam em plataformas específicas,
consulte a documentação da API vinculada na tabela a seguir.

| **Tipo Dart**                | **Descrição**                                        |
| -----------------------------| ------------------------------------------------------ |
| [AbiSpecificInteger][AbiSpecificInteger]    | O supertipo de todos os tipos inteiros específicos de ABI. |
| [Int][Int]                     | Representa o tipo `int` em C.                       |
| [IntPtr][IntPtr]                  | Representa o tipo `intptr_t` em C.                  |
| [Long][Long]                    | Representa o tipo `long int` (`long`) em C.         |
| [LongLong][LongLong]                | Representa o tipo `long long` em C.               |
| [Short][Short]                   | Representa o tipo `short` em C.                    |
| [SignedChar][SignedChar]              | Representa o tipo `signed char` em C.            |
| [Size][Size]                    | Representa o tipo `size_t` em C.                   |
| [UintPtr][UintPtr]                 | Representa o tipo `uintptr_t` em C.                |
| [UnsignedChar][UnsignedChar]            | Representa o tipo `unsigned char` em C.         |
| [UnsignedInt][UnsignedInt]             | Representa o tipo `unsigned int` em C.          |
| [UnsignedLong][UnsignedLong]            | Representa o tipo `unsigned long int` em C.     |
| [UnsignedLongLong][UnsignedLongLong]        | Representa o tipo `unsigned long long` em C.    |
| [UnsignedShort][UnsignedShort]           | Representa o tipo `unsigned short` em C.        |
| [WChar][WChar]                   | Representa o tipo `wchar_t` em C.                   |

{:.table .table-striped }

## Gerar ligações FFI com `package:ffigen`

Para grandes superfícies de API, pode ser demorado
escrever as ligações Dart que se integram ao código C.
Para que o Dart crie wrappers FFI a partir de arquivos de cabeçalho C,
use o gerador de ligações [`package:ffigen`][ffigen].

## Construir e agrupar recursos nativos {:#native-assets}

:::note
Os recursos nativos são **experimentais** e
[em desenvolvimento ativo]({{site.repo.dart.sdk}}/issues/50565).
:::

O recurso _Recursos Nativos_ deve resolver vários problemas associados à
distribuição de pacotes Dart que dependem de código nativo.
Ele faz isso fornecendo hooks uniformes para integração com vários
sistemas de compilação envolvidos na construção de aplicativos Flutter e Dart autônomos.

Este recurso deve simplificar como os pacotes Dart dependem e usam código nativo.
Recursos Nativos devem fornecer os seguintes benefícios:

* Construir o código nativo ou obter os binários
  usando um hook de compilação `hook/build.dart` de um pacote.
* Agrupar o [`Asset`][`Asset`] nativo que o hook de compilação `build.dart` relata.
* Tornar os recursos nativos disponíveis em tempo de execução por meio de
  funções `@Native<>() extern` declarativas usando o [`assetId`][`assetId`].

Quando você [aceita](#opt-in-to-the-experiment) o experimento nativo,
os comandos `flutter (run|build)` e `dart (run|build)`
constroem e agrupam código nativo com o código Dart.

### Revisar o exemplo `native_add_library`

O exemplo [`native_add_library`][`native_add_library`] inclui o código mínimo para
construir e agrupar código C em um pacote Dart.

O exemplo inclui os seguintes arquivos:

{% capture native-assets -%}
{{site.repo.dart.org}}/native/blob/main/pkgs/native_assets_cli/example/build/native_add_library
{%- endcapture %}

| **Arquivo fonte**                          | **Descrição**                                                                                                                                                              |
| ------------------------------------------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [`src/native_add_library.c`][`src/native_add_library.c`]           | O arquivo C contendo o código para `add`.                                                                                                                                   |
| [`lib/native_add_library.dart`][`lib/native_add_library.dart`]        | O arquivo Dart que invoca a função C `add` no recurso `package:native_add_library/native_add_library.dart` por meio de FFI. (Observe que o _id do recurso_ é padrão para o URI da biblioteca.) |
| [`test/native_add_library_test.dart`][`test/native_add_library_test.dart`]  | Um teste Dart usando o código nativo.                                                                                                                                         |
| [`hook/build.dart`][`hook/build.dart`]                    | Um hook de compilação para compilar `src/native_add_library.c` e declarar o recurso compilado com o id `package:native_add_library/native_add_library.dart`.                              |

{:.table .table-striped }

[`src/native_add_library.c`]: {{native-assets}}/src/native_add_library.c
[`lib/native_add_library.dart`]: {{native-assets}}/lib/native_add_library.dart
[`test/native_add_library_test.dart`]: {{native-assets}}/test/native_add_library_test.dart
[`hook/build.dart`]: {{native-assets}}/hook/build.dart

Quando um projeto Dart ou Flutter depende de `package:native_add_library`,
ele invoca o hook de compilação `hook/build.dart` nos comandos `run`, `build` e `test`.
O exemplo [`native_add_app`][`native_add_app`] mostra um uso de `native_add_library`.

### Revisar a documentação da API de recursos nativos

A documentação da API pode ser encontrada para os seguintes pacotes:

* Para saber mais sobre recursos nativos em Dart FFI,
  consulte a referência da API `dart:ffi` para [`Native`][`Native`] e [`DefaultAsset`][`DefaultAsset`].
* Para saber mais sobre o hook de compilação `hook/build.dart`,
  consulte a [referência da API `package:native_assets_cli`][`package:native_assets_cli` API reference].

### Aceitar o experimento

Para aprender como habilitar o experimento e fornecer feedback,
consulte estes problemas de rastreamento:

* [Recursos nativos do Dart]({{site.repo.dart.sdk}}/issues/50565)
* [Recursos nativos do Flutter](https://github.com/flutter/flutter/issues/129757)

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
