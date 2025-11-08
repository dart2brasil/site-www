---
ia-translate: true
title: Configurando aplicações com declarações de ambiente de compilação
description: >-
  Aprenda sobre o uso de declarações de ambiente de compilação
  para customizar o comportamento da aplicação.
showBreadcrumbs: false
lastVerified: 2023-02-23
---

Você pode especificar declarações de ambiente de compilação
ao construir ou executar uma aplicação Dart.
Declarações de ambiente de compilação especificam
opções de configuração como pares chave-valor
que são acessados e avaliados em tempo de compilação.

:::note
Esta página usa "environment" para se referir
ao ambiente de compilação do Dart.
O uso comum do termo em vez disso se refere
ao ambiente do sistema operacional.
:::

Sua aplicação pode usar os valores das declarações de ambiente
para mudar sua funcionalidade ou comportamento.
Compiladores Dart podem eliminar o código tornado inalcançável
devido ao fluxo de controle usando os valores de declaração de ambiente.

Você pode definir e usar declarações de ambiente para:

* Adicionar funcionalidade durante a depuração, como habilitar logging.
* Criar sabores separados de sua aplicação.
* Configurar o comportamento da aplicação, como a porta de um servidor HTTP.
* Habilitar um modo experimental de sua aplicação para testes.
* Alternar entre backends de teste e produção.

Para especificar uma declaração de ambiente
ao executar ou compilar uma aplicação Dart,
use a opção `--define` ou sua abreviação, `-D`.
Especifique o par chave-valor da declaração
usando um formato `<NAME>=<VALUE>`:

```console
$ dart run --define=DEBUG=true -DFLAVOR=free
```

Para aprender como definir essas declarações com outras ferramentas,
confira a seção [especificando declarações de ambiente][] neste guia.
Essa seção explica a sintaxe de declaração e
como especificá-las na linha de comando e em IDEs e editores.

[`dart run`]: /tools/dart-run
[`dart compile`]: /tools/dart-compile
[specifying environment declarations]: #specifying-environment-declarations

## Acessando declarações de ambiente

Para acessar valores de declaração de ambiente especificados,
use um dos construtores `fromEnvironment`
com `const` ou dentro de um contexto constante.
Use [`bool.fromEnvironment`][bool-from] para valores `true` ou `false`,
[`int.fromEnvironment`][int-from] para valores inteiros,
e [`String.fromEnvironment`][string-from] para qualquer outra coisa.

:::note
Os construtores de declaração de ambiente são garantidos
para funcionar apenas quando invocados como `const`.
A maioria dos compiladores deve ser capaz de avaliar seu valor em tempo de compilação.
:::

Cada um dos construtores `fromEnvironment` requer o
nome ou chave da declaração de ambiente.
Eles também aceitam um argumento nomeado opcional `defaultValue`
para sobrescrever o valor de fallback padrão.
O valor de fallback padrão é usado quando uma declaração não está definida
ou o valor especificado não pode ser analisado como o tipo esperado.

Por exemplo, se você quiser imprimir mensagens de log
apenas quando a declaração de ambiente `DEBUG` estiver definida como `true`:

<?code-excerpt "misc/lib/development/environment_declarations.dart (debug-log)"?>
```dart
void log(String message) {
  // Log the debug message if the environment declaration 'DEBUG' is `true`.
  // If there was no value specified, do not log.
  if (const bool.fromEnvironment('DEBUG', defaultValue: false)) {
    print('Debug: $message');
  }
}
```

Neste trecho, se `DEBUG` for definido como `false`
durante a compilação, ou não for especificado de forma alguma,
compiladores de produção podem remover completamente a condição e seu corpo.

Os construtores `fromEnvironment` recorrem a
um valor padrão quando a declaração não está especificada ou
o valor especificado não pode ser analisado.
Portanto, para verificar especificamente se
uma declaração de ambiente foi especificada,
use o construtor [`bool.hasEnvironment`][bool-has]:

<?code-excerpt "misc/lib/development/environment_declarations.dart (has-debug)"?>
```dart
if (const bool.hasEnvironment('DEBUG')) {
  print('Debug behavior was configured!');
}
```

[string-from]: {{site.dart-api}}/dart-core/String/String.fromEnvironment.html
[int-from]: {{site.dart-api}}/dart-core/int/int.fromEnvironment.html
[bool-from]: {{site.dart-api}}/dart-core/bool/bool.fromEnvironment.html
[bool-has]: {{site.dart-api}}/dart-core/bool/bool.hasEnvironment.html

## Especificando declarações de ambiente

:::warning
Ferramentas e compiladores Dart atualmente não
lidam de forma consistente com declarações de ambiente
com valores separados por vírgula.
Para acompanhar a padronização desse tratamento,
referencie [SDK issue 44995][].
:::

[SDK issue 44995]: {{site.repo.dart.sdk}}/issues/44995

### Dart CLI

Tanto `dart run` quanto os subcomandos `dart compile` aceitam
qualquer número das opções `-D` ou `--define`
para especificar valores de declaração de ambiente.

```console
$ dart run --define=DEBUG=true -DFLAVOR=free main.dart
$ dart compile exe --define=DEBUG=true -DFLAVOR=free main.dart
$ dart compile js --define=DEBUG=true -DFLAVOR=free main.dart
$ dart compile aot-snapshot --define=DEBUG=true -DFLAVOR=free main.dart
$ dart compile jit-snapshot --define=DEBUG=true -DFLAVOR=free main.dart
$ dart compile kernel --define=DEBUG=true -DFLAVOR=free main.dart
```

#### `webdev`

Para aprender sobre configurar `webdev` para passar declarações de ambiente
tanto para os compiladores web de desenvolvimento quanto de produção,
confira [a documentação de configuração do `webdev`][webdev-config].

[webdev-config]: {{site.pub-pkg}}/build_web_compilers#configuring--d-environment-variables

### Visual Studio Code

Na sua configuração de lançamento (`launch.json`) sob `configurations`,
adicione uma nova chave `toolArgs` contendo suas declarações de ambiente desejadas:

```json
"configurations": [
    {
        "name": "Dart",
        "request": "launch",
        "type": "dart",
        "toolArgs": [
          "--define=DEBUG=true"
        ]
    }
]
```

Para aprender mais, confira a documentação para
[configurações de lançamento do VS Code.][VSC instructions]

[VSC instructions]: https://code.visualstudio.com/docs/editor/debugging#_launch-configurations

### JetBrains IDEs

Nas **Configurações Run/Debug** para seu projeto,
adicione suas declarações de ambiente desejadas às **opções de VM**:

![Adding define option to Jetbrains IDE](/assets/img/env-decl-jetbrains.png){:width="500"}

Para aprender mais, confira a documentação da JetBrains para
[Configurações Run/Debug do Dart][jetbrains-run-debug].

[jetbrains-run-debug]: https://www.jetbrains.com/help/webstorm/run-debug-configuration-dart-command-line-application.html

### Flutter

Para especificar declarações de ambiente para a ferramenta Flutter,
use a opção `--dart-define` em vez disso:

```console
$ flutter run --dart-define=DEBUG=true
```

{%- comment %}
  TODO: Once Flutter adds `--dart-define` documentation:
  To learn more, check out Flutter's documentation on `--dart-define`.
{% endcomment -%}
