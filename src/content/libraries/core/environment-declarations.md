---
ia-translate: true
title: "Configurando aplicativos com declarações de ambiente de compilação"
description: Learn about using compilation environment declarations to customize application behavior.
showBreadcrumbs: false
lastVerified: 2023-02-23
---

Você pode especificar declarações de ambiente de compilação (compilation environment declarations) ao criar ou executar um aplicativo Dart.  As declarações de ambiente de compilação especificam opções de configuração como pares chave-valor que são acessados e avaliados em tempo de compilação.

:::note
Esta página usa "ambiente" para se referir ao ambiente de compilação Dart. O uso comum do termo, em vez disso, refere-se ao ambiente do sistema operacional.
:::

Seu aplicativo pode usar os valores das declarações de ambiente para alterar sua funcionalidade ou comportamento. Os compiladores Dart podem eliminar o código que se torna inacessível devido ao fluxo de controle usando os valores das declarações de ambiente.

Você pode definir e usar declarações de ambiente para:

* Adicionar funcionalidades durante a depuração, como habilitar logs.
* Criar versões separadas (flavors) do seu aplicativo.
* Configurar o comportamento do aplicativo, como a porta de um servidor HTTP.
* Ativar um modo experimental do seu aplicativo para testes.
* Alternar entre backends de teste e produção.

Para especificar uma declaração de ambiente ao executar ou compilar um aplicativo Dart, use a opção `--define` ou sua abreviação, `-D`. Especifique o par chave-valor da declaração usando o formato `<NAME>=<VALUE>`:

```console
$ dart run --define=DEBUG=true -DFLAVOR=free
```

Para aprender como definir essas declarações com outras ferramentas, consulte a seção [especificando declarações de ambiente][] neste guia. Essa seção explica a sintaxe da declaração e como especificá-las na linha de comando e em IDEs e editores.

[`dart run`]: /tools/dart-run
[`dart compile`]: /tools/dart-compile
[especificando declarações de ambiente]: #especificando-declaracoes-de-ambiente

## Acessando declarações de ambiente {:#acessando-declaracoes-de-ambiente}

Para acessar os valores das declarações de ambiente especificadas, use um dos construtores `fromEnvironment` com `const` ou dentro de um contexto constante. Use [`bool.fromEnvironment`][bool-from] para valores `true` ou `false`, [`int.fromEnvironment`][int-from] para valores inteiros e [`String.fromEnvironment`][string-from] para qualquer outro valor.

:::note
Os construtores de declaração de ambiente só são garantidos para funcionar quando invocados como `const`. A maioria dos compiladores precisa ser capaz de avaliar seu valor em tempo de compilação.
:::

Cada um dos construtores `fromEnvironment` exige o nome ou a chave da declaração de ambiente. Eles também aceitam um argumento nomeado `defaultValue` opcional para substituir o valor de retorno padrão. O valor padrão é usado quando uma declaração não é definida ou o valor especificado não pode ser analisado como o tipo esperado.

Por exemplo, se você quiser imprimir mensagens de log apenas quando a declaração de ambiente `DEBUG` estiver definida como `true`:

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

Neste trecho, se `DEBUG` estiver definido como `false` durante a compilação ou não especificado, os compiladores de produção podem remover completamente a condição e seu corpo.

Os construtores `fromEnvironment` retornam um valor padrão quando a declaração não é especificada ou o valor especificado não pode ser analisado. Portanto, para verificar especificamente se uma declaração de ambiente foi especificada, use o construtor [`bool.hasEnvironment`][bool-has]:

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

## Especificando declarações de ambiente {:#especificando-declaracoes-de-ambiente}

:::warning
As ferramentas e compiladores Dart atualmente não manipulam consistentemente declarações de ambiente com valores separados por vírgula. Para acompanhar a padronização desse tratamento, consulte a [issue 44995 do SDK][].
:::

[issue 44995 do SDK]: {{site.repo.dart.sdk}}/issues/44995

### Dart CLI {:#dart-cli}

Tanto `dart run` quanto os subcomandos `dart compile` aceitam qualquer número de opções `-D` ou `--define` para especificar valores de declaração de ambiente.

```console
$ dart run --define=DEBUG=true -DFLAVOR=free main.dart
$ dart compile exe --define=DEBUG=true -DFLAVOR=free main.dart
$ dart compile js --define=DEBUG=true -DFLAVOR=free main.dart
$ dart compile aot-snapshot --define=DEBUG=true -DFLAVOR=free main.dart
$ dart compile jit-snapshot --define=DEBUG=true -DFLAVOR=free main.dart
$ dart compile kernel --define=DEBUG=true -DFLAVOR=free main.dart
```

#### `webdev` {:#webdev}

Para saber mais sobre como configurar o `webdev` para passar declarações de ambiente para os compiladores web de desenvolvimento e produção, consulte a [documentação de configuração do `webdev`][webdev-config].

[webdev-config]: {{site.pub-pkg}}/build_web_compilers#configuring--d-environment-variables

### Visual Studio Code {:#visual-studio-code}

Na sua configuração de inicialização (`launch.json`) em `configurations`,
adicione uma nova chave `toolArgs` contendo as declarações de ambiente desejadas:

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

Para saber mais, consulte a documentação sobre [configurações de inicialização do VS Code.][VSC instructions]

[VSC instructions]: https://code.visualstudio.com/docs/editor/debugging#_launch-configurations

### IDEs JetBrains {:#jetbrains-ides}

Nas **Configurações de Execução/Depuração** do seu projeto, adicione as declarações de ambiente desejadas às **Opções de VM**:

![Adicionando a opção define ao IDE Jetbrains](/assets/img/env-decl-jetbrains.png){:width="500"}

Para saber mais, consulte a documentação da JetBrains sobre [Configurações de Execução/Depuração do Dart][jetbrains-run-debug].

[jetbrains-run-debug]: https://www.jetbrains.com/help/webstorm/run-debug-configuration-dart-command-line-application.html

### Flutter {:#flutter}

Para especificar declarações de ambiente para a ferramenta Flutter, use a opção `--dart-define`:

```console
$ flutter run --dart-define=DEBUG=true
```

{%- comment %}
  TODO: Once Flutter adds `--dart-define` documentation:
  Para saber mais, consulte a documentação do Flutter sobre `--dart-define`.
{% endcomment -%}

