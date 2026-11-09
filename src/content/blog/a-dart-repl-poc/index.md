---
ia-translate: true
title: "Uma PoC de REPL para Dart"
description: "Hackeando com Dart"
publishDate: 2017-01-17
author: BlackHC
image: images/0lOBcrb2bYgKV6VYT.webp
category: deep-dive
layout: blog
---


<DashImage src="images/0lOBcrb2bYgKV6VYT.webp" alt="Um beija-flor de origami no esquema de cores original do Dart." />


O modo interativo do [Python](https://www.python.org/) é ótimo. O [Dart](http://dartlang.org/) não tem um modo interativo no momento, mas é muito bom para prototipar ideias rapidamente, então vamos ver se conseguimos improvisar alguma coisa!

*Aviso: eu trabalho no Google, mas este post é sobre um projeto pessoal. Não faço parte do time do Dart nem de nada relacionado. Esta é só a minha humilde opinião e a minha história. Vem comigo.*

O modo interativo de linguagens como Python ou Ruby ajudou a torná-las bem acessíveis para iniciantes. Mas elas não são as únicas que usam o conceito de [REPL](https://en.wikipedia.org/wiki/Read%E2%80%93eval%E2%80%93print_loop). Um REPL é um loop de leitura, avaliação e impressão (read-eval-print loop). Shells como BASH ou zsh também usam REPLs quando você interage com eles em um terminal. É também o que você tem ao trabalhar com notebooks no [Jupyter](http://jupyter.org/) (IPython Notebooks), [Matlab](https://www.mathworks.com/products/matlab.html), [Mathematica](https://www.wolfram.com/mathematica/) ou [Maple](https://www.maplesoft.com/products/maple/). Essa forma de computação interativa é muito popular entre pesquisadores.

É assim que o modo interativo do Python se parece:

<DashImage src="images/1sqspbSjstPhKIsIbZBDq-Q.webp" alt="Um usuário interage com o REPL do Python." caption="O bom e velho REPL do Python" />


O Dart não permite avaliar instruções em um escopo global como o Python, então não existe um jeito óbvio de fazer isso corretamente. Em Dart, as instruções precisam estar dentro de funções, e a função main é o ponto de entrada de um programa. Igualzinho a C++ ou C#. Pessoalmente, eu prefiro assim, porque fica mais fácil entender o que está acontecendo quando um programa executa. Mas... eu ainda queria muito um modo interativo. Ele me permitiria brincar com ideias e testar coisas ainda mais rápido. Então vamos ver se conseguimos criar um REPL como prova de conceito!

## Como podemos criar um REPL em dart? {:#how-can-we-create-a-repl-in-dart}

O Dart é muito bom para prototipar. Então vamos fazer exatamente isso e não ficar atolados em questões de design da linguagem :)

Acontece que não existe uma função `eval` como em JavaScript ou Python, e eu não quero escrever um interpretador completo para implementar uma. Ele não seria muito rápido, e eu também não tenho muito tempo. Porém, quando você depura [código Dart no Intellij](https://www.dartlang.org/tools/jetbrains-plugin), pode avaliar expressões enquanto percorre o código passo a passo. Avaliar expressões é exatamente o que queremos fazer, não é? Será que dá para usar esse recurso?

Os recursos de depuração do Dart são expostos pelo seu [VM service](https://github.com/dart-lang/sdk/blob/master/runtime/vm/service/service.md). Ele é um serviço JSON-RPC fornecido pela [Dart VM](https://www.dartlang.org/dart-vm) ao qual você pode se conectar para depurar sua aplicação. A [Natalie Weizenbaum](https://twitter.com/nex3) publicou um artigo sobre o pacote `vm_service_client`, que oferece uma API muito boa para interagir com o VM service: [http://news.dartlang.org/2016/05/unboxing-packages-vmserviceclient.html](http://news.dartlang.org/2016/05/unboxing-packages-vmserviceclient.html)

Então o que podemos fazer é o seguinte: nosso REPL pode se conectar ao seu próprio VM service para avaliar as expressões que lê do terminal! Parece loucura...

<DashImage src="images/0wtt2rUBIRxHnPUHv.webp" alt="Pessoa sorrindo segurando uma banana, com o texto 'You are so crazy lol' sobreposto." />


... mas funciona! Escrevi um [spike rápido](https://github.com/BlackHC/dart_repl/blob/ca3518074c94f48ce5be872b15b58556133a474c/bin/repl.dart) e funciona mesmo. O Dart tem suporte a [programação assíncrona](https://www.dartlang.org/tutorials/language/futures), o que vem bem a calhar, porque impede que o programa bloqueie a si mesmo ao conversar com o próprio VM service.
> # Spikes são um conceito do desenvolvimento guiado por testes: são experimentos rápidos e improvisados que a gente escreve para responder algumas questões técnicas.

Com a questão da viabilidade resolvida, fica fácil escrever uma prova de conceito decente. Para avaliar expressões que vão além de `1 + 1`, precisamos ter suporte a variáveis. Só que variáveis não podem ser criadas com facilidade, porque uma declaração de variável não é uma expressão em Dart. Em Python, você pode simplesmente declarar uma variável na hora atribuindo um valor a ela. Em Dart, podemos simular campos dinâmicos sobrescrevendo `n[oSuchMethod](https://www.dartlang.org/articles/language/emulating-functions#interactions-with-mirrors-and-nosuchmethod)` para criar elementos em um dicionário na hora. Chamo essa classe de `Scope`, e quando [avaliamos expressões dentro de uma instância](https://www.dartdocs.org/documentation/vm_service_client/0.2.3/vm_service_client/VMInstanceRef/evaluate.html) dela, os campos podem ser acessados como variáveis globais.

<DashImage src="images/02PUDlyPF7rchkNmA.webp" alt="Pessoa confusa segurando a cabeça, com o texto 'What do these words mean' sobreposto." />


Na verdade, o código é mais direto:

```dart
// Copyright (c) 2016, Andreas 'blackhc' Kirsch. All rights reserved. Use of 
// this source code is governed by a BSD-style license that can be found in the 
// LICENSE file.
import 'dart:mirrors';

Scope currentScope;

@proxy
class Scope {
  final _scope = <Symbol, dynamic>{};

  Scope();

  Scope.predefined(Map<Symbol, dynamic> symbols) {
    _scope.addAll(symbols);
  }

  factory Scope.clone(Scope other) => new Scope.predefined(other._scope);

  @override
  dynamic noSuchMethod(Invocation invocation) {
    if (invocation.isGetter) {
      if (_scope.containsKey(invocation.memberName)) {
        return _scope[invocation.memberName];
      } else {
        return super.noSuchMethod(invocation);
      }
    } else if (invocation.isSetter) {
      final variable = MirrorSystem.getSymbol(
          MirrorSystem.getName(invocation.memberName).split('=').first);
      _scope[variable] = invocation.positionalArguments.first;
      return null;
    } else if (invocation.isMethod) {
      return Function.apply(_scope[invocation.memberName] as Function,
          invocation.positionalArguments, invocation.namedArguments);
    } else {
      throw new UnsupportedError('Neither setter, nor getter, nor method!');
    }
  }

  @override
  String toString() => _scope.toString();
}
```

Com isso, já dá para fazer coisas como `a = 3`e `b = a*3`:

<DashImage src="images/12tDjwpxSxslDUfiv8enwow.webp" alt="Um usuário avalia expressões simples no REPL do Dart." caption="Expressões simples: FEITO" />


Uma limitação em que esbarramos rapidinho é que só conseguimos acessar símbolos que foram importados no arquivo que declara a classe `Scope`. `import ‘…’;` não pode ser avaliado pelo VM service. Então nada de `dart:io` se não o importarmos explicitamente, e nada de bibliotecas próprias :(

Opa, peraí! O Dart consegue criar novos isolates (workers independentes) a partir de uma URI com [Isolate.spawnUri](https://api.dartlang.org/stable/1.21.1/dart-isolate/Isolate/spawnUri.html). Os usuários poderiam especificar imports adicionais na linha de comando, e o REPL poderia gerar código-fonte incluindo esses imports e então criar um novo isolate com o código gerado, que deixa os imports disponíveis para o usuário.

<DashImage src="images/0bgs2vFlKPkZsFbSO.webp" alt="Pessoa inclinada para a frente numa conversa, com o texto 'That's not enough. We have to go deeper' sobreposto." />


E funciona \o/

<DashImage src="images/1eh9q0mNToXK0R_QiYdrylw.webp" alt="Um usuário importa bibliotecas próprias com sucesso no REPL do Dart." caption="Imports personalizados: FEITO" />


## Suportando mais Dart {:#supporting-more-dart}

Outro problema é que só conseguimos avaliar expressões. Instruções de controle como blocos `if/else` ou loops `while` não são expressões. No caso de instruções, poderíamos envolvê-las em uma closure e executar a closure, o que é uma expressão de chamada de função. Assim, `if (a == 1) print('a is 1!!');` viraria

```
() { if (a == 1) print('a is 1!!'); }();
```


Só precisamos descobrir se a entrada é uma expressão ou uma instrução. Isso é difícil, porque teríamos de escrever um parser de Dart para isso. Mas o Dart é escrito em Dart, e o pacote [`analyzer`](https://pub.dartlang.org/packages/analyzer) fornece de graça um parser capaz de analisar qualquer código Dart!

```dart
// Copyright (c) 2016, Andreas 'blackhc' Kirsch. All rights reserved. Use of 
// this source code is governed by a BSD-style license that can be found in the 
// LICENSE file.
import 'dart:io';

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/error/listener.dart';
import 'package:analyzer/src/dart/scanner/reader.dart';
import 'package:analyzer/src/dart/scanner/scanner.dart';
import 'package:analyzer/src/generated/parser.dart';

bool _tryParse(String code, Function parse) {
  final reader = new CharSequenceReader(code);
  final errorListener = new BooleanErrorListener();
  final scanner = new Scanner(null, reader, errorListener);
  final token = scanner.tokenize();
  final parser = new Parser(null, errorListener);
  final node = parse(parser, token) as AstNode;

  return !errorListener.errorReported &&
      node != null &&
      node.endToken.next.type == TokenType.EOF;
}

bool isExpression(String code) => _tryParse(
    code, (Parser parser, Token token) => parser.parseExpression(token));

bool isStatements(String code) => _tryParse(code, (Parser parser, Token token) {
      final statements = parser.parseStatements(token);
      if (statements.isEmpty) {
        return null;
      }
      return statements.last;
    });
```

E assim, isso também está resolvido.

<DashImage src="images/1uemGA2TzYypx2RmooQfwmg.webp" alt="Um usuário avalia tanto instruções quanto expressões no REPL do Dart." caption="Instruções e expressões: FEITO" />


## Mais imports {:#more-imports}

O último detalhe que nos impede de importar qualquer biblioteca é que, por padrão, um novo Isolate só enxerga os pacotes mencionados no seu `pubspec.yaml`. Mas queremos poder importar qualquer biblioteca. `Isolate.spawnUri` tem um parâmetro `packageConfig` que nos permite especificar um mapa de nome de pacote para caminho do pacote. Basta usar outro parâmetro de linha de comando para apontar para outro pacote e usar a configuração de pacotes dele no nosso Isolate. Uhuu!

Logo esbarramos no problema de que nosso Isolate precisa acessar o pacote `analyzer` (e outros), que talvez não sejam carregados por qualquer que seja o pacote com que você queira brincar na sua sessão do REPL. O pacote [`package_resolver`](https://pub.dartlang.org/packages/package_resolver) vem ao resgate! Com ele, conseguimos manipular configurações de pacotes com facilidade.

```dart
import 'package:package_resolver/package_resolver.dart';

Future<PackageResolver> mergePackageConfigs(String otherPackageRoot) async {
  final currentConfig = await PackageResolver.current.packageConfigMap;
  final otherConfig =
      (await SyncPackageResolver.loadConfig(otherPackageRoot + '/.packages'))
          .packageConfigMap;
  // We do something horrible here: We simply merge the current config with
  // the other. Hoping it will still work..
  final config = <String, Uri>{};
  config.addAll(currentConfig);
  config.addAll(otherConfig);
  return new PackageResolver.config(config);
}
```

Com tudo isso, temos um fluxo de trabalho completo implementado:

<DashImage src="images/1KKIJauKlylkVMaLvhJQq9w.webp" alt="Um usuário importa uma biblioteca de outro pacote no REPL do Dart." caption="Importar qualquer biblioteca de outro pacote: FEITO" />


## O que vem a seguir? {:#whats-next}

Este post ficou longo... A prova de conceito inteira tem **451 linhas de código**, ou seja, quase tão longa quanto este post.

<DashImage src="images/0Xn430bpRfeDmM9uF.webp" alt="Meme do Grumpy Cat com o texto 'THE END IS NEAR - GOOD'." />


O código está em [https://github.com/BlackHC/dart_repl](https://github.com/BlackHC/dart_repl/tree/master/lib). Se você tem o Dart instalado, dá para testar facilmente:

```
pub global activate dart_repl
pub global run dart_repl
```


Curti muito criar essa prova de conceito no meu tempo livre. Todas as peças se encaixaram em poucas horas. O suporte de IDE para Dart no IntelliJ é excelente, e hoje existe uma tonelada de documentação e artigos por aí. Confira, por exemplo, a série Unboxing Packages da [Natalie Weizenbaum](https://twitter.com/nex3): [http://news.dartlang.org/2016/04/unboxing-packages-async-part-3.html](http://news.dartlang.org/2016/04/unboxing-packages-async-part-3.html) e outros. Hackear em baixo nível com Dart é divertido, e há ótimas bibliotecas para soltar a criatividade. O [`code_builder`](https://github.com/dart-lang/code_builder) parece muito promissor, e o [`built_collection`](https://github.com/google/built_collection.dart) oferece coleções imutáveis. O [David Morgan](https://twitter.com/__davidmorgan__) também vem publicando artigos sobre [coleções imutáveis](/blog/darts-built-collection-for-immutable-collections) em Dart.

Para o `dart_repl`, seria legal importar bibliotecas adicionais em tempo de execução sem precisar reiniciar. O time do Dart adicionou recentemente suporte a hot reload na VM. Isso traz principalmente uma experiência melhor no [Flutter](https://flutter.io/) para desenvolvedores de apps mobile. Talvez isso também pudesse ser usado para imports sob demanda e para definir funções e classes no REPL.

De modo geral, o Dart poderia ser ótimo para pesquisa e para pesquisadores, e eu adoraria ver suporte do Jupyter ao Dart. Bastaria implementar a interface de kernel dele para tornar um REPL de Dart como esse compatível... :) Deve ser fácil, né?

<DashImage src="images/00_DI8nuDDB5VwIbc.webp" alt="Meme de encerramento sobre a prova de conceito do REPL do Dart, com o texto 'You Deserve A Cookie'." />
