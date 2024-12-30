---
ia-translate: true
title: "Interoperação Objective-C e Swift usando package:ffigen"
description: "Para usar código Objective-C e Swift em seu programa Dart, use o package:ffigen."
ffigen: "https://pub.dev/packages/ffigen"
example: "https://github.com/dart-lang/native/tree/main/pkgs/ffigen/example/objective_c"
appledoc: "https://developer.apple.com/documentation"
---

Aplicativos Dart para mobile, linha de comando e servidor
rodando na [plataforma Dart Native](/overview#platform), no macOS ou iOS,
podem usar `dart:ffi` e [`package:ffigen`]({{ffigen}})
para chamar APIs Objective-C e Swift.

:::note
Este recurso de interoperabilidade é **experimental** e
está [em desenvolvimento ativo]({{site.repo.dart.sdk}}/issues/49673).
:::

`dart:ffi` permite que o código Dart interaja com APIs C nativas.
Objective-C é baseado e compatível com C,
então é possível interagir com APIs Objective-C usando apenas `dart:ffi`.
No entanto, fazer isso envolve muito código repetitivo,
então você pode usar `package:ffigen` para gerar automaticamente
as ligações Dart FFI para uma determinada API Objective-C.
Para aprender mais sobre FFI e interagir com código C diretamente,
consulte o [guia de interoperabilidade C](/interop/c-interop).

Você pode gerar cabeçalhos Objective-C para APIs Swift,
permitindo que `dart:ffi` e `package:ffigen` interajam com Swift.

## Exemplo Objective-C

Este guia orienta você por [um exemplo]({{example}})
que usa `package:ffigen` para gerar ligações para
[`AVAudioPlayer`]({{appledoc}}/avfaudio/avaudioplayer?language=objc).
Esta API requer pelo menos o macOS SDK 10.7,
então verifique sua versão e atualize o Xcode se necessário:

```console
$ xcodebuild -showsdks
```

Gerar ligações para envolver uma API Objective-C é semelhante a envolver uma API C.
Direcione `package:ffigen` para o arquivo de cabeçalho que descreve a API,
e então carregue a biblioteca com `dart:ffi`.

`package:ffigen` analisa arquivos de cabeçalho Objective-C
usando [LLVM](https://llvm.org/),
então você precisará instalá-lo primeiro.
Consulte [Instalando LLVM]({{ffigen}}#installing-llvm)
do README do ffigen para mais detalhes.

### Configurando o ffigen

Primeiro, adicione `package:ffigen` como uma dependência de desenvolvimento:

```console
$ dart pub add --dev ffigen
```

Em seguida, configure o ffigen para gerar ligações para o
cabeçalho Objective-C contendo a API.
As opções de configuração do ffigen vão no seu arquivo `pubspec.yaml`,
sob uma entrada `ffigen` de nível superior.
Como alternativa, você pode colocar a configuração do ffigen em seu próprio arquivo `.yaml`.

```yaml
ffigen:
  name: AVFAudio
  description: Bindings for AVFAudio.
  language: objc
  output: 'avf_audio_bindings.dart'
  headers:
    entry-points:
      - '/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/System/Library/Frameworks/AVFAudio.framework/Headers/AVAudioPlayer.h'
```

O `name` é o nome da classe wrapper da biblioteca nativa
que será gerada,
e a `description` será usada na documentação dessa classe.
O `output` é o caminho do arquivo Dart que o ffigen criará.
O ponto de entrada é o arquivo de cabeçalho contendo a API.
Neste exemplo, é o cabeçalho interno `AVAudioPlayer.h`.

Outra coisa importante que você verá,
se você olhar para a [configuração de exemplo]({{example}}/pubspec.yaml),
são as opções de exclusão e inclusão.
Por padrão, `ffigen` gera ligações para tudo
que ele encontra no cabeçalho,
e tudo que essas ligações dependem em outros cabeçalhos.
A maioria das bibliotecas Objective-C depende de bibliotecas internas da Apple,
que são muito grandes.
Se as ligações forem geradas sem nenhum filtro,
o arquivo resultante pode ter milhões de linhas.
Para resolver esse problema,
a configuração do ffigen tem campos que permitem filtrar
todas as funções, structs, enums, etc., que você não está interessado.
Para este exemplo, estamos interessados apenas em `AVAudioPlayer`,
então você pode excluir todo o resto:

```yaml
  exclude-all-by-default: true
  objc-interfaces:
    include:
      - 'AVAudioPlayer'
```

Como `AVAudioPlayer` está explicitamente incluído assim,
`ffigen` exclui todas as outras interfaces.
A flag `exclude-all-by-default` diz ao `ffigen` para
excluir todo o resto.
O resultado é que nada é incluído exceto `AVAudioPlayer`,
e suas dependências, como `NSObject` e `NSString`.
Então, em vez de vários milhões de linhas de ligações,
você acaba com dezenas de milhares.

Se você precisar de um controle mais granular,
você pode excluir ou incluir todas as declarações individualmente,
em vez de usar `exclude-all-by-default`:

```yaml
  functions:
    exclude:
      - '.*'
  structs:
    exclude:
      - '.*'
  unions:
    exclude:
      - '.*'
  globals:
    exclude:
      - '.*'
  macros:
    exclude:
      - '.*'
  enums:
    exclude:
      - '.*'
  unnamed-enums:
    exclude:
      - '.*'
```

Essas entradas `exclude` excluem a expressão regular `'.*'`,
que corresponde a qualquer coisa.

Você também pode usar a opção `preamble`
para inserir texto no topo do arquivo gerado.
Neste exemplo, o `preamble` foi usado
para inserir algumas regras de linter ignore no topo do arquivo gerado:

```yaml
  preamble: |
    // ignore_for_file: camel_case_types, non_constant_identifier_names, unused_element, unused_field, return_of_invalid_type, void_checks, annotate_overrides, no_leading_underscores_for_local_identifiers, library_private_types_in_public_api
```

Consulte o [readme do ffigen]({{ffigen}}#configurations)
para uma lista completa de opções de configuração.

### Gerando as ligações Dart

Para gerar as ligações, navegue até o diretório de exemplo,
e execute o ffigen:

```console
$ dart run ffigen
```

Isso irá procurar no arquivo `pubspec.yaml` por uma entrada `ffigen` de nível superior.
Se você escolheu colocar a configuração do ffigen em um arquivo separado, use a
opção `--config` e especifique esse arquivo:

```console
$ dart run ffigen --config my_ffigen_config.yaml
```

Para este exemplo, isso irá gerar
[avf_audio_bindings.dart]({{example}}/avf_audio_bindings.dart).

Este arquivo contém uma classe chamada `AVFAudio`, que é o wrapper da biblioteca nativa
que carrega todas as funções da API usando FFI,
e fornece métodos wrapper convenientes para chamá-los.
As outras classes neste arquivo são todos wrappers Dart
em torno das interfaces Objective-C que precisamos,
como `AVAudioPlayer` e suas dependências.

### Usando as ligações

Agora você está pronto para carregar e interagir com a biblioteca gerada.
O aplicativo de exemplo, [play_audio.dart]({{example}}/play_audio.dart),
carrega e reproduz arquivos de áudio passados como argumentos de linha de comando.
O primeiro passo é carregar o
[dylib]({{appledoc}}/avfaudio?language=objc)
e instanciar a biblioteca `AVFAudio` nativa:

```dart
import 'dart:ffi';
import 'avf_audio_bindings.dart';

const _dylibPath =
    '/System/Library/Frameworks/AVFAudio.framework/Versions/Current/AVFAudio';

void main(List<String> args) async {
  final lib = AVFAudio(DynamicLibrary.open(_dylibPath));
```

Como você está carregando uma biblioteca interna,
o caminho do dylib está apontando para um dylib de framework interno.
Você também pode carregar seu próprio arquivo `.dylib`,
ou se a biblioteca estiver estaticamente vinculada ao seu aplicativo (geralmente o caso no iOS)
você pode usar [`DynamicLibrary.process()`](
{{site.dart-api}}/dart-ffi/DynamicLibrary/DynamicLibrary.process.html):

```dart
  final lib = AVFAudio(DynamicLibrary.process());
```

O objetivo do exemplo é reproduzir cada um dos arquivos de áudio
especificados como argumentos de linha de comando, um por um.
Para cada argumento,
você primeiro precisa converter o Dart `String` para um `NSString` Objective-C.
O wrapper `NSString` gerado tem um construtor conveniente
que lida com essa conversão,
e um método `toString()` que o converte de volta para um Dart `String`.

```dart
  for (final file in args) {
    final fileStr = NSString(lib, file);
    print('Loading $fileStr');
  }
```

O reprodutor de áudio espera um `NSURL`, então em seguida usamos o método [`fileURLWithPath:`](
{{appledoc}}/foundation/nsurl/1410828-fileurlwithpath?language=objc)
para converter o `NSString` para um `NSURL`.
Como `:` não é um caractere válido em um nome de método Dart,
ele foi traduzido para `_` nas ligações.

```dart
    final fileUrl = NSURL.fileURLWithPath_(lib, fileStr);
```

Agora, você pode construir o `AVAudioPlayer`.
Construir um objeto Objective-C tem dois estágios.
`alloc` aloca a memória para o objeto,
mas não o inicializa.
Métodos com nomes começando com `init*` fazem a inicialização.
Algumas interfaces também fornecem métodos `new*` que fazem ambas as etapas.

Para inicializar o `AVAudioPlayer`,
use o método [`initWithContentsOfURL:error:`][`initWithContentsOfURL:error:`]:

```dart
    final player =
        AVAudioPlayer.alloc(lib).initWithContentsOfURL_error_(fileUrl, nullptr);
```

Objective-C usa contagem de referência para gerenciamento de memória
(através de retain, release e outras funções),
mas no lado do Dart, o gerenciamento de memória é tratado automaticamente.
O objeto wrapper Dart retém uma referência ao objeto Objective-C,
e quando o objeto Dart é coletado pelo coletor de lixo,
o código gerado libera automaticamente essa referência usando um
[`NativeFinalizer`]({{site.dart-api}}/dart-ffi/NativeFinalizer-class.html).

Em seguida, procure a duração do arquivo de áudio,
que você precisará mais tarde para esperar o áudio terminar.
A [`duration`][`duration`] é uma `@property(readonly)`.
Propriedades Objective-C são traduzidas em getters e setters
no objeto wrapper Dart gerado.
Como `duration` é `readonly`, apenas o getter é gerado.

O `NSTimeInterval` resultante é apenas um `double` com alias de tipo,
então você pode usar imediatamente o método `.ceil()` do Dart
para arredondar para o próximo segundo:

```dart
    final durationSeconds = player.duration.ceil();
    print('$durationSeconds sec');
```

Finalmente, você pode usar o método [`play`][`play`] para reproduzir o áudio,
em seguida, verificar o status e aguardar a duração do arquivo de áudio:

```dart
    final status = player.play();
    if (status) {
      print('Playing...');
      await Future<void>.delayed(Duration(seconds: durationSeconds));
    } else {
      print('Failed to play audio.');
    }
```

### Limitações de callbacks e multithreading

Problemas de multithreading são a maior limitação
do suporte experimental do Dart para interoperabilidade Objective-C.
Essas limitações são devido à relação entre
isolates Dart e threads do SO,
e a maneira como as APIs da Apple lidam com multithreading:

* Isolates Dart não são a mesma coisa que threads.
  Isolates são executados em threads,
  mas não têm garantia de execução em nenhuma thread específica,
  e a VM pode alterar a thread em que um isolate está sendo executado
  sem aviso prévio.
  Existe uma [solicitação de recurso aberta][open feature request] para permitir que os isolates sejam
  fixados em threads específicas.
* Embora `ffigen` suporte a conversão
  de funções Dart para blocos Objective-C,
  a maioria das APIs da Apple não faz nenhuma garantia sobre
  em qual thread um callback será executado.
* A maioria das APIs que envolvem interação com a interface do usuário
  só podem ser chamadas na thread principal,
  também chamada de thread da _plataforma_ no Flutter.
* Muitas APIs da Apple [não são thread-safe][not thread safe].

Os dois primeiros pontos significam que um callback criado em um isolate
pode ser invocado em uma thread executando um isolate diferente,
ou nenhum isolate.
Dependendo do tipo de callback que você está usando,
isso pode fazer com que seu aplicativo falhe.
Callbacks criados usando
[`Pointer.fromFunction`][`Pointer.fromFunction`] ou [`NativeCallable.isolateLocal`][`NativeCallable.isolateLocal`]
devem ser invocados na thread do isolate proprietário,
caso contrário, eles irão falhar.
Callbacks criados usando [`NativeCallable.listener`][`NativeCallable.listener`]
podem ser invocados com segurança de qualquer thread.

O terceiro ponto significa que chamar diretamente algumas APIs da Apple
usando as ligações Dart geradas pode não ser thread-safe.
Isso pode travar seu aplicativo ou causar outro comportamento imprevisível.
Você pode contornar essa limitação escrevendo algum
código Objective-C que despacha sua chamada
para a thread principal.
Para mais informações, consulte a [documentação de despacho Objective-C][Objective-C dispatch documentation].

Em relação ao último ponto,
embora os isolates Dart possam alternar entre threads,
eles só são executados em uma thread por vez.
Portanto, a API com a qual você está interagindo
não precisa necessariamente ser thread-safe,
contanto que não seja hostil a threads,
e não tenha restrições sobre qual thread é chamada.

Você pode interagir com segurança com o código Objective-C,
contanto que você mantenha essas limitações em mente.

[`Pointer.fromFunction`]: {{site.dart-api}}/dart-ffi/Pointer/fromFunction.html
[`NativeCallable.isolateLocal`]: {{site.dart-api}}/dart-ffi/NativeCallable/NativeCallable.isolateLocal.html
[`NativeCallable.listener`]: {{site.dart-api}}/dart-ffi/NativeCallable/NativeCallable.listener.html

## Exemplo Swift

Este [exemplo][swift_example] demonstra como
tornar uma classe Swift compatível com Objective-C,
gerar um cabeçalho wrapper e invocá-lo a partir do código Dart.

### Gerando o cabeçalho wrapper Objective-C

As APIs Swift podem ser tornadas compatíveis com Objective-C,
usando a anotação `@objc`.
Certifique-se de tornar quaisquer classes ou métodos que você deseja usar
`public`, e faça com que suas classes estendam `NSObject`.

```swift
import Foundation

@objc public class SwiftClass: NSObject {
  @objc public func sayHello() -> String {
    return "Hello from Swift!";
  }

  @objc public var someField = 123;
}
```

Se você está tentando interagir com uma biblioteca de terceiros,
e não pode modificar o código deles,
você pode precisar escrever uma classe wrapper compatível com Objective-C
que expõe os métodos que você deseja usar.

Para mais informações sobre interoperabilidade Objective-C / Swift,
consulte a [documentação Swift][Swift documentation].

Depois de tornar sua classe compatível,
você pode gerar um cabeçalho wrapper Objective-C.
Você pode fazer isso usando o Xcode,
ou usando o compilador de linha de comando Swift, `swiftc`.
Este exemplo usa a linha de comando:

```console
$ swiftc -c swift_api.swift             \
    -module-name swift_module           \
    -emit-objc-header-path swift_api.h  \
    -emit-library -o libswiftapi.dylib
```

Este comando compila o arquivo Swift, `swift_api.swift`,
e gera um cabeçalho wrapper, `swift_api.h`.
Ele também gera o dylib que você vai carregar mais tarde,
`libswiftapi.dylib`.

Você pode verificar se o cabeçalho foi gerado corretamente abrindo-o,
e verificando se as interfaces são o que você espera.
No final do arquivo,
você deve ver algo como o seguinte:

```objc
SWIFT_CLASS("_TtC12swift_module10SwiftClass")
@interface SwiftClass : NSObject
- (NSString * _Nonnull)sayHello SWIFT_WARN_UNUSED_RESULT;
@property (nonatomic) NSInteger someField;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end
```

Se a interface estiver faltando ou não tiver todos os seus métodos,
certifique-se de que todos estejam anotados com `@objc` e `public`.

### Configurando ffigen

Ffigen só vê o cabeçalho wrapper Objective-C, `swift_api.h`.
Então, a maior parte desta configuração se parece com
o exemplo Objective-C,
incluindo definir a linguagem para `objc`.

```yaml
ffigen:
  name: SwiftLibrary
  description: Bindings for swift_api.
  language: objc
  output: 'swift_api_bindings.dart'
  exclude-all-by-default: true
  objc-interfaces:
    include:
      - 'SwiftClass'
    module:
      'SwiftClass': 'swift_module'
  headers:
    entry-points:
      - 'swift_api.h'
  preamble: |
    // ignore_for_file: camel_case_types, non_constant_identifier_names, unused_element, unused_field, return_of_invalid_type, void_checks, annotate_overrides, no_leading_underscores_for_local_identifiers, library_private_types_in_public_api
```

Como antes, defina o idioma para `objc`,
e o ponto de entrada para o cabeçalho;
exclua tudo por padrão,
e inclua explicitamente a interface que você está vinculando.

Uma diferença importante entre a configuração
para uma API Swift envolvida e uma API Objective-C pura:
a opção `objc-interfaces` -> `module`.
Quando `swiftc` compila a biblioteca,
ele dá à interface Objective-C um prefixo de módulo.
Internamente, `SwiftClass` é realmente registrado como
`swift_module.SwiftClass`.
Você precisa dizer ao `ffigen` sobre esse prefixo,
para que ele carregue a classe correta do dylib.

Nem todas as classes recebem esse prefixo.
Por exemplo, `NSString` e `NSObject`
não receberão um prefixo de módulo,
porque são classes internas.
É por isso que a opção `module` mapeia
do nome da classe para o prefixo do módulo.
Você também pode usar expressões regulares para corresponder
vários nomes de classe de uma vez.

O prefixo do módulo é o que você passou para
`swiftc` na flag `-module-name`.
Neste exemplo, é `swift_module`.
Se você não definir explicitamente esta flag,
o padrão é o nome do arquivo Swift.

Se você não tem certeza de qual é o nome do módulo,
você também pode verificar o cabeçalho Objective-C gerado.
Acima do `@interface`, você encontrará uma macro `SWIFT_CLASS`:

```objc
SWIFT_CLASS("_TtC12swift_module10SwiftClass")
@interface SwiftClass : NSObject
```

A string dentro da macro é um pouco enigmática, mas você pode
ver que ela contém o nome do módulo e o nome da classe:
`"_TtC12`***`swift_module`***`10`***`SwiftClass`***`"`.

Swift pode até mesmo decifrar esse nome para nós:

```console
$ echo "_TtC12swift_module10SwiftClass" | swift demangle
```

Isso gera `swift_module.SwiftClass`.

### Gerando as ligações Dart

Como antes, navegue até o diretório de exemplo,
e execute o ffigen:

```console
$ dart run ffigen
```

Isso gera `swift_api_bindings.dart`.

### Usando as ligações

Interagir com essas ligações é exatamente o mesmo
que para uma biblioteca Objective-C normal:

```dart
import 'dart:ffi';
import 'swift_api_bindings.dart';

void main() {
  final lib = SwiftLibrary(DynamicLibrary.open('libswiftapi.dylib'));
  final object = SwiftClass.new1(lib);
  print(object.sayHello());
  print('field = ${object.someField}');
  object.someField = 456;
  print('field = ${object.someField}');
}
```

Observe que o nome do módulo não é mencionado
na API Dart gerada.
Ele é usado apenas internamente,
para carregar a classe do dylib.

Agora você pode executar o exemplo usando:

```console
$ dart run example.dart
```

[`initWithContentsOfURL:error:`]: {{appledoc}}/avfaudio/avaudioplayer/1387281-initwithcontentsofurl?language=objc
[`duration`]: {{appledoc}}/avfaudio/avaudioplayer/1388395-duration?language=objc
[`play`]: {{appledoc}}/avfaudio/avaudioplayer/1387388-play?language=objc
[Swift documentation]: {{appledoc}}/swift/importing-swift-into-objective-c
[open feature request]: {{site.repo.dart.sdk}}/issues/46943
[`package:cupertino_http`]: {{site.repo.dart.org}}/http/blob/master/pkgs/cupertino_http/src/CUPHTTPClientDelegate.m
[not thread safe]: {{site.apple-dev}}/library/archive/documentation/Cocoa/Conceptual/Multithreading/ThreadSafetySummary/ThreadSafetySummary.html
[Objective-C dispatch documentation]: {{appledoc}}/dispatch?language=objc
[swift_example]: {{site.repo.dart.org}}/native/tree/main/pkgs/ffigen/example/swift
