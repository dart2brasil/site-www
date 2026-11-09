---
ia-translate: true
title: "Avançando rápido com valores imutáveis em Dart"
description: "O built_value do Dart oferece valores imutáveis poderosos e práticos para Dart. Os valores podem ser imutáveis, mas o pacote não ficou parado…"
publishDate: 2017-06-30
author: davidmorgan
category: deep-dive
layout: blog
---


O [built_value](https://github.com/google/built_value.dart) do Dart oferece valores imutáveis poderosos e práticos para Dart. Os valores podem ser imutáveis, mas o pacote não ficou parado! Nos seis meses desde a [última vez que escrevi sobre](/blog/darts-built-value-for-immutable-object-models) o built_value, houve dez grandes melhorias no pacote.

Também encontrei alguns usos interessantes do built_value na comunidade Dart:

* O pacote [built_redux](https://github.com/davidmarne/built_redux) é um pacote inspirado no [redux](http://redux.js.org/) que usa built_value. Ele vem com bindings e exemplos para [flutter](https://github.com/davidmarne/flutter_built_redux/tree/master/example), [angular2](https://github.com/davidmarne/angular_built_redux/tree/master/example) e [react-dart](https://github.com/davidmarne/react_built_redux).

* O pacote [built_highcharts](https://github.com/vadimtsushko/built_highcharts) é um wrapper do [highcharts](https://www.highcharts.com/) que usa built_value. A [demo](https://vadimtsushko.github.io/built_highcharts/) é realmente bem bacana.

* E aqui está [outra forma](https://github.com/toufikzitouni/Built-Value-Example) de usar built_value com Flutter.

Enfim, sem mais delongas, aqui estão todas as ótimas novidades do built_value.

## 1. Classes genéricas {:#1-generic-classes}

Modelos de objetos sofisticados usam generics, então é claro que o built_value precisa de [generics](https://github.com/google/built_value.dart/blob/master/example/lib/generics.dart). Agora você pode declarar seu tipo usando generics, e a classe builder gerada também oferece suporte a eles:

```
abstract class GenericValue<T>
    implements Built<GenericValue<T>, GenericValueBuilder<T>> {
  T get value;
  ...
}

var value = new GenericValue<String>((b) => b..value = 'string');
```


Tipos de valor que usam generics são serializáveis, como de costume.

## 2. Plugins de serializer {:#2-serializer-plugins}

A nova API `SerializerPlugin` permite fazer modificações transversais na serialização, executando código arbitrário antes e depois de cada objeto ser serializado ou desserializado.

Você poderia, por exemplo, usar isso para mapear entre duas versões incompatíveis de um protocolo. Mas um exemplo melhor é a próxima melhoria…

## 3. Plugin de serializer “Standard JSON” {:#3-standard-json-serializer-plugin}

Por padrão, o built_value serializa de e para seu próprio formato JSON baseado em listas, por desempenho e flexibilidade.

Mas muita gente precisa interoperar com dados e APIs JSON existentes. O que essas pessoas deveriam fazer?

Agora, você pode instalar o `StandardJsonPlugin` e mudar para um formato JSON padrão, baseado em mapas.

```
final standardSerializers =
    (serializers.toBuilder()
        ..addPlugin(new StandardJsonPlugin())).build();
```


Veja o [exemplo](https://github.com/google/built_value.dart/blob/master/example/lib/example.dart) (perto do final).

## 4. Memoização de getters {:#4-getter-memoization}

Classes imutáveis são ótimas, mas o que fazer com campos *derivados*? Se um campo derivado é caro de calcular, classes imutáveis oferecem duas opções ruins: calculá-los antecipadamente e sempre pagar um custo possivelmente desnecessário, ou recalculá-los sob demanda e potencialmente pagar esse mesmo custo alto muitas vezes.

Entram os getters `@memoized`. Adicione essa anotação a um getter do built_value e ele será calculado de forma preguiçosa (lazy), mas no máximo uma vez; o resultado fica armazenado em um campo oculto na instância.

Desde a `1.1.2`, o próprio built_value é um ótimo exemplo de getters `@memoized`. Um built_value é usado para encapsular um `Element` do analyzer, e o cálculo é [feito de forma preguiçosa nos getters](https://github.com/google/built_value.dart/blob/master/built_value_generator/lib/src/value_source_class.dart):

```
abstract class ValueSourceClass
    implements Built<ValueSourceClass, ValueSourceClassBuilder> {
  ClassElement get element;

  @memoized
  BuiltList<String> get genericParameters =>
      new BuiltList<String>(element.typeParameters
          .map((element) => element.computeNode().toString()));

  @memoized
  BuiltList<ValueSourceField> get fields =>
      ValueSourceField.fromClassElements(element, builderElement);

  // And many more @memoized getters.
}
```


## 5. Geração de código mais rápida {:#5-faster-code-generation}

…e, como resultado da migração para getters memoizados, o built_value agora gera código significativamente mais rápido.

## 6. Factories mais simples {:#6-simpler-factories}

Antes da `0.5.5`, toda classe built_value precisava ter um método factory seguindo um modelo padrão. Esse requisito foi flexibilizado. Aqui estão algumas boas formas de aproveitar essa liberdade maior.

Para classes com um ou dois campos, basta receber exatamente esses campos no construtor:

```
abstract class Value implements Built<Value, ValueBuilder> {
  ClassElement get element;

  factory Value(ClassElement element) =>
      new _$Value._(element: element);
}

void main() {
   var element = getElement();
   var value = new Value(element);
}
```


Ou, quando você quer definir valores padrão para os campos, agora pode fazer isso na factory, em vez de escrever sua própria classe builder:

```
abstract class Value implements Built<Value, ValueBuilder> {
  int get x;
  int get y;
  bool get awesome;

  factory Value([updates(ValueBuilder b)]) =>
      new _$Value((b) => b
          ..awesome = True
          ..update(updates));
}

void main() {
  var value = new Value((b) => b
      ..x = 10
      ..y = 20);
}
```


Por fim, se você gosta de argumentos nomeados, pode expor o construtor baseado em argumentos nomeados em vez do construtor baseado em builder:

```
abstract class Value implements Built<Value, ValueBuilder> {
  int get x;
  int get y;

factory Value({int x, int y}) = _$Value._;

void main() {
  var value = new Value(x: 10, y: 20);
}
```


## 7. toString mais legível e personalizável {:#7-prettier-and-customizable-tostring-output}

Antes da `1.0.0`, a saída do `toString` do built_value era bem plana. Agora, por padrão, ela é indentada, o que facilita a leitura:

```
CompoundValue {
  simpleValue=SimpleValue {
    anInt=1,
  },
}
```


Mas também é personalizável, por meio de uma variável global de nível superior, `newBuiltValueToStringHelper`. Se você preferir o formato antigo:

```
newBuiltValueToStringHelper =
    (className) => new FlatBuiltValueToStringHelper(className);
```


Então:

```
CompoundValue {simpleValue=SimpleValue {anInt=1}}
```


E, se quiser escrever o seu próprio, claro que pode. A classe `BuiltValueToStringHelper` é muito fácil de implementar:

```
abstract class BuiltValueToStringHelper {
  void add(String field, Object value);
  String toString();
}
```


## 8. DateTime e JsonObject serializáveis {:#8-serializable-datetime-and-jsonobject}

A classe `DateTime` do SDK agora é serializável, desde que você use UTC em vez do fuso horário local. (Serializar com o fuso horário local é receita para o desastre!)

E, para ajudar ainda mais na interoperabilidade com dados e APIs JSON existentes, agora existe a classe [`JsonObject`](https://github.com/google/built_value.dart/blob/master/built_value/lib/json_object.dart), que encapsula valores, listas e mapas JSON. Campos do tipo `JsonObject` são serializados diretamente de e para JSON puro.

## 9. Matcher personalizado para testes {:#9-custom-matcher-for-tests}

Os métodos `operator==` gerados no built_value já são bem úteis para testes, mas há uma coisa que eles não oferecem: mensagens de erro facilmente legíveis. Em vez disso, quando uma verificação de igualdade falha em um teste, você recebe o `toString` completo dos valores esperado e real.

Não mais! Agora você pode usar o `built_value_test`, um novo pacote pub. Se você [usá-lo em um teste](https://github.com/google/built_value.dart/blob/master/built_value_test/test/matcher_test.dart), verá erros como este:

```
was <3> instead of <5> at location ['simpleValue']['anInt']
```


Se isso lembra muito a mensagem que você recebe quando a comparação de um mapa falha em um teste, é porque é a mesma coisa: ela é implementada convertendo os valores em mapas e depois comparando.

## 10. Código amigável a dynamic implícito e cast implícito; mensagens de erro melhores {:#10-implicit-dynamic-and-implicit-cast-friendly-code-better-error-messages}

O código gerado pelo built_value foi bastante limpo para passar em dois lints bem rigorosos: ele não usa mais `dynamic` implicitamente em nenhum lugar e não depende mais de casts implícitos.

Essas duas melhorias podem (ou não) levar a um código melhor do compilador.

E foram adicionadas mensagens de erro melhores para quando você declara um campo de serializer com o tipo errado.

Era isso! Obrigado por ler. Se você tiver ideias ou pedidos de recursos para o built_value, passe pelo [issue tracker](https://github.com/google/built_value.dart/issues).
