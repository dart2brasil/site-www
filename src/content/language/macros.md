---
ia-translate: true
title: Macros (experimental)
description: Saiba mais sobre o recurso experimental de macros à medida que ele se desenvolve.
---

O [sistema de macros Dart][spec] é um novo e importante recurso de linguagem
***atualmente em desenvolvimento*** que adiciona suporte para
[metaprogramação estática][motivation] à linguagem Dart.

Uma macro Dart é um trecho de código definível pelo usuário que recebe outro código como parâmetros
e opera sobre ele em tempo real para criar, modificar ou adicionar declarações.

Você pode pensar sobre o sistema de macros em duas partes: usar macros e escrever macros.
Esta página aborda cada uma (em alto nível, já que ***o recurso ainda está em pré-visualização***)
nas seções seguintes:

- [**A macro `JsonCodable`**](#the-jsoncodable-macro):
Uma macro pronta que você pode experimentar hoje (por trás de uma flag experimental)
que oferece uma solução perfeita para a
questão comum da tediosa serialização e desserialização de JSON em Dart.

- [**O recurso de macros em geral**](#the-macros-language-feature):
Por que estamos adicionando macros ao Dart, motivando casos de uso,
benefícios em relação às soluções de geração de código existentes,
e uma visão geral superficial de como a escrita de macros funcionará no futuro, uma vez que
o recurso estiver completo.

[spec]: {{site.repo.dart.lang}}/blob/main/working/macros/feature-specification.md
[motivation]: {{site.repo.dart.lang}}/blob/main/working/macros/motivation.md

## A macro `JsonCodable` {:#the-jsoncodable-macro}

:::important
A macro `JsonCodable` não é estável e atualmente está por trás de uma [flag experimental][].
Ela só funciona com Dart `3.5.0-152` ou posterior.
Está disponível no [canal de desenvolvimento do Dart][channel]
ou no [canal master do Flutter][flutter-channel].

A funcionalidade está sujeita a alterações.
:::

A macro [`JsonCodable`][] codifica e decodifica
classes Dart definidas pelo usuário em mapas JSON do tipo `Map<String, Object?>`.
Ela gera dois membros, um método de serialização `toJson` e
um construtor de desserialização `fromJson`.

[experimental flag]: /tools/experiment-flags
[`JsonCodable`]: {{site.pub-pkg}}/json/versions/0.20.0
[channel]: https://dartbrasil.dev/get-dart#release-channels
[flutter-channel]: {{site.flutter-docs}}/release/upgrade#other-channels

### Configure o experimento {:#set-up-the-experiment}

1. Mude para o [canal de desenvolvimento do Dart][channel] ou o
   [canal master do Flutter][flutter-channel].

2. Execute `dart --version` e verifique se você tem a versão `3.5.0-152` ou posterior do Dart.

3. Edite a [restrição do SDK][] no seu pubspec para exigir a versão do Dart: `sdk: ^3.5.0-152`.

4. [Adicione o pacote][] `json` às `dependencies`: `dart pub add json`.

5. [Habilite o experimento][] no arquivo `analysis_options.yaml` do seu pacote
   na raiz do seu projeto:

   ```yaml
   analyzer:
    enable-experiment:
      - macros
   ```

6. Importe o pacote no arquivo que você planeja usá-lo:

   ```dart
   import 'package:json/json.dart';
   ```

7. Execute seu projeto com a flag experimental:

   ```console
   dart run --enable-experiment=macros bin/my_app.dart
   ```

[SDK constraint]: /tools/pub/pubspec#sdk-constraints
[Add the package]: /tools/pub/packages
[Enable the experiment]: /tools/experiment-flags#using-experiment-flags-with-the-dart-analyzer-command-line-and-ide

### Use a macro {:#use-the-macro}

Para usar a macro `JsonCodable`, anexe a anotação à classe que você deseja serializar:

```dart
import 'package:json/json.dart';

@JsonCodable() // Anotação de macro.
class User {
 final int? age;
 final String name;
 final String username;
}
```

A macro introspecta a classe `User` e deriva as implementações de
`fromJson` e `toJson` usando os campos da classe `User`.

Portanto, sem precisar defini-los você mesmo, `toJson` e `fromJson` agora estão
disponíveis para uso em objetos da classe anotada:

```dart
void main() {
 // Dado algum JSON arbitrário:
 var userJson = {
   'age': 5,
   'name': 'Roger',
   'username': 'roger1337'
 };

 // Use os membros gerados:
 var user = User.fromJson(userJson);
 print(user);
 print(user.toJson());
}
```

### Visualize o código gerado {:#view-the-generated-code}

Às vezes, pode ser útil visualizar o código gerado para entender melhor
como uma macro funciona, ou para inspecionar os detalhes do que ela oferece.

Clique no link "**Go to Augmentation**" que aparece sob a anotação
no seu IDE (suportado no VSCode)
para ver como a macro gera `toJson` e `fromJson`.

Se você alterar algo na classe anotada, poderá observar a _augmentation_ gerada
se ajustar em tempo real junto com o código do seu aplicativo:

![Um gif lado a lado da _augmentation_ gerada atualizando à medida que o código que está aumentando é atualizado](/assets/img/language/macro-augmentation.gif)

### Acione diagnósticos personalizados {:#trigger-custom-diagnostics}

A macro `JsonCodable` possui diagnósticos integrados que são emitidos como
diagnósticos da própria linguagem. Por exemplo, se você tentar declarar
manualmente um método `toJson` onde a macro é aplicada, o analisador emitirá
o erro:

```dart
@JsonCodable()
class HasToJson {
 void [!toJson!]() {}
 // Erro: Não é possível gerar um método toJson devido a este existente.
}
```

Você pode pesquisar por "`DiagnosticMessage`" na [definição de `JsonCodable`][json]
para outros erros que a macro irá gerar. Por exemplo, estender uma classe que também não é
serializável, ou se os nomes dos campos não corresponderem exatamente aos nomes das chaves no JSON fornecido.

:::note
Para saber mais sobre como usar a macro `JsonCodable`, como tipos de campos suportados,
tratamento de nulo e genéricos, e muito mais, consulte [o README][].
:::

[the definition of `JsonCodable`]: {{site.repo.dart.sdk}}/blob/master/pkg/json/lib/json.dart
[the README]: {{site.pub-pkg}}/json

## O recurso de linguagem macros {:#the-macros-language-feature}

As macros Dart são uma solução de metaprogramação *estática*, ou geração de código.
Ao contrário das soluções de geração de código *em tempo de execução* (como [build_runner][]),
as macros são totalmente integradas à linguagem Dart
e executadas automaticamente em segundo plano pelas ferramentas Dart.
Isso torna as macros muito mais eficientes do que depender de uma ferramenta secundária:

- **Nada extra para executar**;
 as macros são construídas em tempo real enquanto você escreve seu código.
- **Sem trabalho duplicado** ou recompilação constante prejudicando o desempenho;
 toda a construção e geração de código acontecem diretamente no compilador,
 automaticamente.
- **Não gravadas em disco**, portanto, sem arquivos de peças ou ponteiros para referências geradas;
 as macros aumentam diretamente a classe *existente*.
- **Sem testes confusos/ofuscados**;
 diagnósticos personalizados são emitidos como qualquer outra mensagem do analisador,
 diretamente no IDE.

E também muito mais eficiente e muito menos propenso a erros do que manualmente
escrever soluções para esses tipos de problemas você mesmo.

{% comment %}
Confira estes exemplos mostrando a mesma serialização JSON
implementada de três maneiras diferentes:

- Usando a [`JsonCodable` macro][].
- Usando o [`json_serializable` pacote de geração de código][].
- Manualmente, [com `dart:convert`][].
{% endcomment %}

[build_runner]: /tools/build_runner
[`JsonCodable` macro]: https://github.com/mit-mit/sandbox/blob/main/explorations/json/dart_jsoncodable/bin/main.dart
[`json_serializable` code gen package]: https://github.com/mit-mit/sandbox/blob/main/explorations/json/dart_json_serializable/bin/main.dart
[with `dart:convert`]: https://github.com/mit-mit/sandbox/blob/main/explorations/json/dart_convert/bin/main.dart

### Casos de uso {:#use-cases}

As macros fornecem mecanismos reutilizáveis para abordar padrões caracterizados por tedioso
_boilerplate_, e muitas vezes a necessidade de iterar sobre os campos de uma classe.
Alguns exemplos comuns que esperamos resolver com macros no futuro são:

- **Serialização JSON.** As ferramentas extras necessárias para serializar JSON,
 como o pacote [json_serializable][], não é tão eficiente quanto deveria ser.
 A macro `JsonCodable` fornece uma maneira muito mais limpa de
 gerar código de serialização; [experimente hoje](#the-jsoncodable-macro).

- **Classes de dados.** O recurso [mais solicitado][] do Dart é para classes de dados
 que fornecem automaticamente um construtor e implementações dos métodos `==`,
 `hashCode` e `copyWith()` para cada campo.
 Implementar a solução com macros significaria que os usuários podem personalizar
 suas classes de dados como melhor lhes convier.

- **Padrões Verbose do Flutter.** Um exemplo é dividir um `build` complexo
método em uma agregação de classes de _widget_ menores. É
melhor para o desempenho e torna o código mais fácil de manter. Infelizmente,
escrever todas essas classes menores exige uma tonelada de _boilerplate_, o que desencoraja
usuários. As macros poderiam potencialmente fornecer uma solução que itera sobre um
`build` complexo método para gerar classes de _widget_ menores,
melhorando muito a produtividade e a qualidade do código Flutter.
Você pode conferir uma exploração sobre esse tópico nesta
[proposta][stateful-macro] da equipe do Flutter.

[json_serializable]: {{site.pub-pkg}}/json_serializable
[most requested]: {{site.repo.dart.lang}}/issues/314
[stateful-macro]: {{site.flutter-docs}}/go/stateful-macro

### Como as macros funcionam {:#how-macros-work}

:::important
O recurso de linguagem de macros não é estável e atualmente está por trás de um
[flag experimental][]. A funcionalidade está altamente sujeita a alterações.
Esta seção permanecerá muito genérica até que esteja estável.
:::

Para criar uma macro, você escreve uma declaração de macro semelhante a uma classe,
usando a palavra-chave `macro`.
Uma declaração de macro também deve incluir uma cláusula `implements` para definir
qual interface a macro pode ser aplicada.

Por exemplo, uma macro que é aplicável a classes e adiciona novas declarações à classe,
implementaria a interface `ClassDeclarationsMacro`:

```dart
macro class MyMacro implements ClassDeclarationsMacro {
   const MyMacro();

   // ...
}
```

Enquanto o recurso ainda está em desenvolvimento, você pode encontrar a lista completa de
interfaces de macro [no código-fonte][types].

O construtor `MyMacro` no exemplo acima corresponde à anotação
que você usaria para aplicar a macro a uma declaração.
A sintaxe é a mesma da sintaxe de anotação de metadados existente do Dart:

```dart
@MyMacro()
class A {}
```

Dentro do corpo da declaração de macro é onde você define o código que deseja
a macro [gere](#view-the-generated-code), bem como qualquer
[diagnóstico](#trigger-custom-diagnostics) que você deseja que a macro emita.

Em um nível muito alto, escrever macros essencialmente funciona usando métodos de _builder_
para juntar as *propriedades* de uma declaração com *identificadores* nessas
propriedades. A macro coleta essas informações através da [introspecção][] profunda
do programa.

As macros ainda estão em desenvolvimento, então isso é o máximo de detalhes que podemos fornecer por enquanto.
Se você estiver curioso ou quiser experimentá-las por trás de uma flag experimental,
a melhor orientação é dar uma olhada na implementação das macros existentes:

- Confira a [definição][json] da macro `JsonCodable`,
- Ou qualquer um dos [exemplos][] disponíveis no repositório da linguagem.

[types]: {{site.repo.dart.sdk}}/blob/main/pkg/_macros/lib/src/api/macros.dart
[json]: {{site.repo.dart.sdk}}/blob/master/pkg/json/lib/json.dart
[augmentation]: {{site.repo.dart.lang}}/blob/main/working/augmentation-libraries/feature-specification.md
[examples]: {{site.repo.dart.lang}}/tree/main/working/macros/example

## Linha do tempo {:#timeline}

A data de lançamento estável para macros é atualmente desconhecida.
Isso se deve à complexidade de sua implementação.

As macros funcionam [introspectando][introspection] profundamente o programa no qual
elas são aplicadas. Uma macro pode acabar percorrendo partes distantes do programa
para coletar informações necessárias sobre propriedades e anotações de tipo
para a declaração que está aumentando.

Considerando sua aplicação em grandes bases de código, onde múltiplas macros podem
introspecionar e aumentar a base continuamente em diferentes lugares,
o _design_ de [ordenação][] e [fases][] de execução é especialmente desafiador
e requer cuidadosa consideração.

Estamos trabalhando para um lançamento estável da macro [`JsonCodable`][]
ainda este ano (2024), e um lançamento estável do recurso de linguagem completo
(ou seja, escrever suas próprias macros) no início do próximo ano (2025).

[introspection]: {{site.repo.dart.lang}}/blob/main/working/macros/feature-specification.md#introspection
[ordering]: {{site.repo.dart.lang}}/blob/main/working/macros/feature-specification.md#ordering-in-metaprogramming
[phases]: {{site.repo.dart.lang}}/blob/main/working/macros/feature-specification.md#phases
