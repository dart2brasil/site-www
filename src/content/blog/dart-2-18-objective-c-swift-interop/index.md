---
ia-translate: true
title: "Dart 2.18: interoperabilidade com Objective-C e Swift"
description: "Interoperabilidade aprimorada, networking específico de plataforma, inferência de tipos melhorada e uma atualização importante sobre o roteiro da nossa linguagem com null safety…"
publishDate: 2022-08-30
author: mit-mit
image: images/0byFoNx1wnEaO0S6N.webp
category: releases
layout: blog
---


### Interoperabilidade aprimorada, networking específico de plataforma, inferência de tipos melhorada e uma atualização importante sobre o roteiro de null safety {:#enhanced-interoperability-platform-specific-networking-improved-type-inference-and-an-important-update-on-our-null-safety-language-roadmap}

*O Dart 2.18 está disponível hoje. Esta versão traz uma prévia da interoperabilidade com Objective-C e Swift e um novo pacote de networking para iOS/macOS construído sobre essa interoperabilidade. Ela também contém inferência de tipos melhorada para funções genéricas, melhorias de desempenho em código assíncrono, novos recursos do pub.dev e limpeza das nossas ferramentas e bibliotecas principais.*

*Por fim, trazemos os números mais recentes da migração para null safety e uma atualização importante do roteiro rumo a um Dart totalmente null safe. Leia até o final!*

<DashImage src="images/0byFoNx1wnEaO0S6N.webp" alt="Banner de lançamento do Dart 2.18 destacando a interoperabilidade com Objective-C e Swift, HTTP específico de plataforma e o roteiro." />


## Apresentando a interoperabilidade do Dart com Objective-C e Swift {:#introducing-dart-to-objective-c--swift-interop}

Demos uma prévia da foreign function interface (FFI) do Dart para chamar APIs nativas em C em 2020, e a lançamos no Dart 2.12, em março de 2021. Desde esse lançamento, um grande conjunto de pacotes aproveitou esse recurso para se integrar a APIs nativas em C já existentes. Alguns exemplos são [`file_picker`](https://pub.dev/packages/file_picker), [`printing`](https://pub.dev/packages/printing), [`win32`](https://pub.dev/packages/win32), [`objectbox`](https://pub.dev/packages/objectbox), [`realm`](https://pub.dev/packages/realm), [`isar`](https://pub.dev/packages/isar), [`tflite_flutter`](https://pub.dev/packages/tflite_flutter) e [`dbus`](https://pub.dev/packages/dbus).

A equipe do Dart quer que o Dart seja interoperável com todas as principais linguagens nas plataformas em que o Dart roda. O Dart 2.18 alcança o próximo marco nesse objetivo. Seu código Dart pode chamar código Objective-C e Swift, como normalmente é usado nas APIs das plataformas macOS e iOS. O Dart oferece suporte a esse mecanismo de interoperabilidade em qualquer app, desde um app de linha de comando, passando por código de backend, até uma UI em Flutter.

Esse novo mecanismo aproveita o fato de que código Objective-C e Swift pode ser exposto como código C com base em bindings de API. A ferramenta de geração de wrappers da API do Dart, [`ffigen`](https://pub.dev/packages/ffigen), pode criar esses bindings a partir de headers de API. Vejamos um exemplo.

## Exemplo de fuso horário usando Objective-C {:#time-zone-example-using-objective-c}

O macOS tem uma API para consultar informações de fuso horário, exposta na [classe `NSTimeZone`](https://developer.apple.com/documentation/foundation/nstimezone?language=objc]). Você pode consultar essa API para obter o fuso horário e o [offset de fuso horário UTC](https://www.w3.org/International/core/2005/09/timezone.html#:~:text=What%20is%20a%20%22zone%20offset,or%20%22%2D%22%20from%20UTC.) que o usuário configurou no dispositivo.

O exemplo a seguir, um app em Objective-C, usa essa API de fuso horário para obter o fuso horário do sistema e o offset em relação ao GMT:

```objective-c
#import <Foundation/Foundation.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSTimeZone *timezone = [NSTimeZone systemTimeZone]; // Get current time zone.
        NSLog(@"Timezone name: %@", timezone.name);
        NSLog(@"Timezone offset GMT: %ld hours", timezone.secondsFromGMT/60/60);
    }
    return 0;
}
```

O app importa `Foundation.h`, que contém os headers de API da biblioteca Foundation da Apple. Em seguida, dentro do método `main`, ele chama o método `systemTimeZone` da classe `NSTimeZone`. Esse método retorna uma instância de `NSTimeZone` com o fuso horário selecionado no dispositivo. Por fim, o app imprime duas linhas no console, contendo o nome do fuso horário e o offset UTC em horas.

Se você executar esse app, ele deve retornar algo parecido com o seguinte, dependendo da sua localização:

```
Timezone name: Europe/Copenhagen
Timezone offset GMT: 2 hours
```


## Exemplo de fuso horário usando Dart {:#time-zone-example-using-using-dart}

Vamos replicar esse resultado com Dart usando a nova interoperabilidade com Objective-C.

Primeiro, crie um novo app de linha de comando em Dart:

```
$ dart create timezones
```


Depois, edite seu arquivo `pubspec` para conter a configuração do `ffigen`. Essa configuração aponta para o arquivo de header e lista quais interfaces Objective-C devem gerar wrappers:

```yaml
ffigen:
  name: TimeZoneLibrary
  language: objc
  output: "foundation_bindings.dart"
  exclude-all-by-default: true
  objc-interfaces:
    include:
      - "NSTimeZone"
  headers:
    entry-points:
      - "/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/System/Library/Frameworks/Foundation.framework/
         Headers/NSTimeZone.h"
```

Isso seleciona os bindings Objective-C para os headers em `NSTimeZone.h` e inclui apenas as APIs da interface `NSTimeZone`. Para gerar os wrappers, execute o `ffigen`:

```
$ dart run ffigen
```


Esse comando cria um novo arquivo, `foundation_bindings.dart`, que contém um monte de bindings de API gerados. Usando esse arquivo de bindings, podemos escrever nosso método `main` em Dart. Esse método espelha o código Objective-C:

```dart
void main(List<String> args) async {
  const dylibPath =
      '/System/Library/Frameworks/Foundation.framework/Versions/Current/Foundation';
  final lib = TimeZoneLibrary(DynamicLibrary.open(dylibPath));

  final timeZone = NSTimeZone.getLocalTimeZone(lib);
  if (timeZone != null) {
    print('Timezone name: ${timeZone.name}');
    print('Offset from GMT: ${timeZone.secondsFromGMT / 60 / 60} hours');
  }
}
```

Pronto! Esse novo suporte está disponível em estado experimental a partir do Dart 2.18 lançado hoje. Isso reforça o suporte geral de interoperabilidade do Dart para chamar APIs do macOS e do iOS diretamente. Por sua vez, isso complementa os plugins do Flutter com um novo suporte que funciona em qualquer app Dart e permite chamar APIs do macOS e do iOS diretamente a partir de código Dart.

Adoramos receber seu feedback. Conte-nos o que funcionou, o que poderia mudar ou quais problemas você enfrentou, comentando na [issue de feedback](https://github.com/dart-lang/sdk/issues/49673) no GitHub. Para saber mais sobre essa interoperabilidade, veja o [guia de interoperabilidade com Objective-C e Swift](https://dart.dev/guides/libraries/objective-c-interop).

## Bibliotecas http específicas de plataforma {:#platform-specific-http-libraries}

O Dart inclui uma biblioteca `http` geral e multiplataforma. Essa biblioteca permite escrever código sem se preocupar com particularidades de cada plataforma. Em algumas ocasiões, você pode querer escrever código específico para as APIs de rede de uma determinada plataforma.

Por exemplo, a biblioteca de rede da Apple, [`NSURLSession`](https://developer.apple.com/documentation/foundation/nsurlsession), permite especificar que a rede seja apenas Wi-Fi ou que exija uma VPN. Para dar suporte a esses casos de uso, criamos um novo pacote de networking voltado às plataformas macOS e iOS, o [`cupertino_http`](https://pub.dev/packages/cupertino_http). Ele se apoia na nova interoperabilidade com Objective-C mencionada na seção anterior. Ele usa um grande conjunto de wrappers de API [gerados](https://github.com/dart-lang/http/blob/master/pkgs/cupertino_http/ffigen.yaml) a partir das APIs de rede da Apple no Foundation.

## Exemplo com a biblioteca http do Cupertino {:#cupertino-http-library-example}

O exemplo a seguir configura o cliente http de um app Flutter para usar a biblioteca `cupertino_http` no macOS e no iOS, e a biblioteca http comum do `dart:io` nas demais plataformas:

```dart
late Client client;
if (Platform.isIOS || Platform.isMacOS) {
  final config = URLSessionConfiguration.ephemeralSessionConfiguration()
    ..allowsCellularAccess = false
    ..allowsExpensiveNetworkAccess = false;
  client = CupertinoClient.fromSessionConfiguration(config);
} else {
  client = Client(); // Uses an HTTP client based on dart:io
}
```

Depois dessa configuração inicial, o app faz todas as chamadas de rede seguintes pelo cliente específico. Por exemplo, um `get()` do http agora fica parecido com isto:

```dart
final response = await get(
  Uri.https(
    'www.googleapis.com',
    '/books/v1/volumes',
    {'q': 'HTTP', 'maxResults': '40', 'printType': 'books'},
  ),
);
```

Quando você não puder usar a interface de cliente comum, pode chamar as APIs de rede da Apple diretamente usando a biblioteca `cupertino_http`:

```dart
final session = URLSession.sessionWithConfiguration(
    URLSessionConfiguration.backgroundSession('com.example.bgdownload'),
    onFinishedDownloading: (s, t, fileUri) {
      actualContent = File.fromUri(fileUri).readAsStringSync();
    });

final task = session.downloadTaskWithRequest(
    URLRequest.fromUrl(Uri.https(...))
    ..resume();
```

## Networking específico de plataforma em aplicativos multiplataforma {:#platform-specific-networking-in-multi-platform-apps}

Ao projetar esse recurso, o objetivo continuou sendo manter os apps o mais multiplataforma possível. Para atingir essa meta, mantivemos o nosso conjunto geral e multiplataforma de APIs `http` para operações http básicas, e permitimos configurar, por plataforma, qual biblioteca de networking usar. Você pode minimizar a quantidade de código específico de plataforma que precisa escrever usando a [API de Client do `package:http`](https://pub.dev/documentation/http/latest/http/Client-class.html). Essa API pode ser configurada por plataforma, mas usada de forma independente da plataforma.

O Dart 2.18 oferece suporte experimental a duas bibliotecas http específicas de plataforma que implementam a [API de Client](https://pub.dev/documentation/http/latest/http/Client-class.html) do `package:http`:

* [`cupertino_http`](https://pub.dev/packages/cupertino_http), baseada em [`NSURLSession`](https://developer.apple.com/documentation/foundation/nsurlsession), para macOS/iOS.

* [`cronet_http`](https://pub.dev/packages/cronet_http), baseada no [Cronet](https://developer.android.com/guide/topics/connectivity/cronet), a biblioteca de networking popular no Android.

Combinar uma API de cliente comum com várias implementações de HTTP oferece o melhor dos dois mundos. Você pode ter comportamento específico de plataforma e, ao mesmo tempo, manter seus apps a partir de um único conjunto de fontes compartilhado para todas as plataformas. Adoraríamos ouvir seu feedback sobre isso nesta [issue no GitHub](https://github.com/dart-lang/http/issues/764).

## Inferência de tipos melhorada {:#improved-type-inference}

O Dart usa muitas funções genéricas. Considere o método [`fold`](https://api.dart.dev/stable/2.17.6/dart-core/Iterable/fold.html), que reduz uma coleção de elementos a um único valor. O exemplo a seguir calcula a soma de uma lista de inteiros:

```dart
List<int> numbers = [1, 2, 3];
final sum = numbers.fold(0, (x, y) => x + y);
print('The sum of $numbers is $sum');
```


Com o Dart 2.17 ou anterior, esse método retorna um erro de tipo:

```
line 2 • The operator '+' can't be unconditionally invoked 
         because the receiver can be 'null'.
```


A inferência de tipos do Dart não conseguia propagar informações entre os argumentos. Isso resultava em incerteza sobre o tipo de `x`. Para contornar o possível erro, você precisava especificar o tipo:

```dart
final sum = numbers.fold(0, (int x, int y) => x + y);
```


O Dart 2.18 melhora a inferência de tipos. O exemplo anterior passa na análise estática e consegue inferir que `x` e `y` são ints não anuláveis. Essa mudança permite escrever código Dart mais conciso, mantendo todas as propriedades de solidez dos tipos fortemente inferidos.

## Melhorias de desempenho em código assíncrono {:#async-performance-improvements}

Esta versão do Dart melhora a forma como a VM do Dart aplica o método `async` e as funções geradoras `async*`/`sync*`. Isso reduz o tamanho do código. Em dois grandes apps internos do Google, observamos uma redução de cerca de 10% no tamanho do snapshot AOT. Também observamos um aumento de desempenho nos nossos microbenchmarks.

Essas mudanças incluem pequenas alterações de comportamento; para saber mais, veja [o changelog](https://github.com/dart-lang/sdk/blob/master/CHANGELOG.md#dart-vm).

## Melhorias no pub.dev {:#pubdev-improvements}

Junto com o lançamento do 2.18, fizemos duas mudanças no repositório de pacotes `pub.dev`.

Pessoas físicas costumam manter pacotes publicados no `pub.dev` no tempo livre. Isso pode ser caro, tanto em tempo quanto em dinheiro. Para facilitar patrocínios, agora oferecemos suporte a uma nova tag `funding` no `pubspec`, que pode ser usada pelos publicadores de pacotes para listar links de uma ou mais formas de patrociná-lo. Esses links são exibidos no `pub.dev` na barra lateral:

<DashImage src="images/0FteRd2cVBg3Zq7JO.webp" alt="Uma captura de tela mostrando uma seção de link de patrocínio na barra lateral do pub.dev." />


Para saber mais, veja a [documentação do `pubspec`](https://dart.dev/tools/pub/pubspec#funding).

Além disso, gostaríamos de incentivar um ecossistema rico de pacotes open source. Para destacar isso, a pontuação automatizada de pacotes do `pub.dev` concede 10 pontos extras para pacotes que usam uma [licença aprovada pela OSI](https://opensource.org/licenses).

## Algumas mudanças que quebram compatibilidade {:#a-few-breaking-changes}

O Dart tem um forte foco em simplicidade e facilidade de aprendizado. Estamos sempre tentando manter um equilíbrio cuidadoso ao adicionar novas capacidades. Um dos métodos para manter as coisas simples é remover funcionalidades e APIs antigas com pouco uso ou com substitutos melhores. O Dart 2.18 limpa itens dessa categoria, incluindo algumas mudanças menores que quebram compatibilidade:

* Adicionamos a ferramenta de linha de comando unificada `dart` em outubro de 2020. No 2.18, concluímos a transição. Esta versão remove as duas últimas ferramentas descontinuadas, `dart2js` (use `dart compile js`) e `dartanalyzer` (use `dart analyze`).

* Com a introdução do versionamento de linguagem, o `pub` gera um novo arquivo de resolução: `.dart_tool/package_config.json.` O arquivo anterior, `.packages`, usava um formato que não podia conter versões. Descontinuamos o uso do arquivo `.packages`. Se você tiver arquivos `.packages`, pode excluí-los.

* Mixins de classes que não estendem `Object` não podem mais ser usados (mudança que quebra compatibilidade [#48167](https://github.com/dart-lang/sdk/issues/48167)). Esse comportamento nunca foi intencional.

* A propriedade `uri` de `RedirectException` do `dart:io` passou a ser anulável (mudança que quebra compatibilidade [#49045](https://github.com/dart-lang/sdk/issues/49045)).

* Constantes nas APIs de networking do `dart:io` que seguem a convenção SCREAMING_SNAKE foram removidas (mudança que quebra compatibilidade [#34218](https://github.com/dart-lang/sdk/issues/34218); já estavam descontinuadas). Use as constantes lowerCamelCase correspondentes.

* A VM do Dart não restaura mais as configurações iniciais do terminal ao sair. Programas que alteram as configurações `lineMode` e `echoMode` do `Stdin` passam a ser responsáveis por restaurá-las ao encerrar o programa (mudança que quebra compatibilidade [#45630](https://github.com/dart-lang/sdk/issues/45630)).

## Atualização sobre null safety {:#null-safety-update}

Ficamos muito satisfeitos em ver o amplo uso de null safety desde o seu lançamento beta, em novembro de 2020, e o lançamento do [Dart 2.12](/blog/announcing-dart-2-12), em março de 2021.

Primeiro, os desenvolvedores de apps de quase todos os pacotes populares do `pub.dev` migraram para null safety. A análise mostra que 100% dos 250 pacotes mais usados e 98% dos 1.000 mais usados suportam null safety.

Segundo, a maioria dos desenvolvedores de apps trabalha em bases de código com migração completa para null safety. Isso é crucial. O [sound null safety](https://dart.dev/null-safety/understanding-null-safety) completo do Dart só entra em vigor quando você migra todo o código e todas as dependências (incluindo as transitivas). Estamos acompanhando isso por meio de telemetria dos comandos `flutter run`.

O gráfico a seguir mostra as execuções de `flutter run` com null safety unsound versus sound. Antes da introdução de null safety, não havia nenhuma das duas. Em seguida, houve um rápido crescimento do null safety unsound. À medida que os apps começaram a migrar para null safety, os desenvolvedores fizeram uma migração parcial. Algumas partes ainda precisavam ser migradas. Com o tempo, vemos um crescimento muito saudável das sessões com sound null safety. No fim do mês passado, havia quatro vezes mais sessões com sound null safety do que com unsound. Esperamos que, nos próximos trimestres, o sound null safety se aproxime de 100%!

<DashImage src="images/0emVp4pmfOhLhiBJ4.webp" alt="Um gráfico demonstrando o crescimento das execuções com sound null safety em comparação com as unsound ao longo do tempo." />


## Uma atualização importante do roteiro de null safety {:#an-important-null-safety-roadmap-update}

Dar suporte tanto ao null safety unsound quanto ao sound adiciona custo e complexidade.

Primeiro, os desenvolvedores Dart precisam aprender e entender os dois modos. Sempre que ler um trecho de código Dart, verifique a [versão da linguagem](https://dart.dev/language/versioning) para ver se os tipos são não anuláveis por padrão (Dart 2.12 e posteriores) ou anuláveis por padrão (Dart 2.11 e anteriores).

Segundo, dar suporte aos dois modos nos nossos compiladores e runtimes deixa mais lenta a evolução do Dart SDK para suportar novos recursos.

***Com base no custo do null safety unsound e nos números de adoção muito positivos mencionados na seção anterior, nosso objetivo é transitar para suportar apenas o sound null safety e descontinuar os modos sem null safety e com null safety unsound. Tentativamente, planejamos isso para meados de 2023.***

Isso significaria descontinuar o suporte ao Dart 2.11 e anteriores. Arquivos pubspec com uma restrição de SDK cujo limite inferior seja menor que 2.12 deixariam de ser resolvidos no Dart 3 e posteriores. Em código-fonte com marcadores de linguagem, esses marcadores falhariam se definidos como menores que 2.12 (como `// @dart=2.9`).

Se você já migrou para o sound null safety, seu código funcionará com o null safety completo no Dart 3. Se ainda não migrou, migre agora! Para saber mais sobre essas mudanças, veja [esta issue no GitHub](https://github.com/dart-lang/sdk/issues/49530).

## Resumo {:#summary}

O novo suporte para interoperabilidade, networking, inferência de tipos e `pub.dev` está disponível hoje. Para começar, você pode baixar diretamente a [versão Dart 2.18](https://dart.dev/get-dart) ou obtê-la incorporada ao SDK do [Flutter 3.3]({{site.flutter-blog}}/announcing-flutter-3-3-at-flutter-vikings) lançado hoje.
