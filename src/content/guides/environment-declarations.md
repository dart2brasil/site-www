---
ia-translate: true
title: Configurando aplicativos com declarações de ambiente de compilação
description: >-
  Aprenda sobre o uso de declarações de ambiente de compilação para
  personalizar o comportamento do aplicativo.
lastVerified: 2023-02-23
---

Você pode especificar declarações de ambiente de compilação
ao construir ou executar um aplicativo Dart.
Declarações de ambiente de compilação especificam
opções de configuração como pares de chave-valor
que são acessados e avaliados no momento da compilação.

:::note
Esta página usa "ambiente" para se referir
ao ambiente de compilação do Dart.
O uso comum do termo, em vez disso, se refere
ao ambiente do sistema operacional.
:::

Seu aplicativo pode usar os valores de declarações de ambiente
para alterar sua funcionalidade ou comportamento.
Os compiladores Dart podem eliminar o código que se torna inacessível
devido ao fluxo de controle usando os valores de declaração de ambiente.

Você pode definir e usar declarações de ambiente para:

*   Adicionar funcionalidade durante a depuração, como ativar o registro.
*   Criar versões separadas do seu aplicativo.
*   Configurar o comportamento do aplicativo, como a porta de um servidor HTTP.
*   Habilitar um modo experimental do seu aplicativo para teste.
*   Alternar entre backends de teste e produção.

Para especificar uma declaração de ambiente
ao executar ou compilar um aplicativo Dart,
use a opção `--define` ou sua abreviação, `-D`.
Especifique o par de chave-valor da declaração
usando o formato `<NOME>=<VALOR>`:

```console
$ dart run --define=DEBUG=true -DFLAVOR=free
```

Para aprender como definir essas declarações com outras ferramentas,
confira a seção [especificando declarações de ambiente][specifying environment declarations] neste guia.
Essa seção explica a sintaxe da declaração e
como especificá-las na linha de comando e em IDEs e editores.

[`dart run`]: /tools/dart-run
[`dart compile`]: /tools/dart-compile
[specifying environment declarations]: #specifying-environment-declarations

## Acessando declarações de ambiente

Para acessar os valores de declaração de ambiente especificados,
use um dos construtores `fromEnvironment`
com `const` ou dentro de um contexto constante.
Use [`bool.fromEnvironment`][bool-from] para valores `true` ou `false`,
[`int.fromEnvironment`][int-from] para valores inteiros,
e [`String.fromEnvironment`][string-from] para qualquer outra coisa.

:::note
Os construtores de declaração de ambiente só têm garantia
de funcionar quando invocados como `const`.
A maioria dos compiladores deve ser capaz de avaliar seu valor no tempo de compilação.
:::

Cada um dos construtores `fromEnvironment` requer o
nome ou chave da declaração de ambiente.
Eles também aceitam um argumento nomeado `defaultValue` opcional
para substituir o valor de fallback padrão.
O valor de fallback padrão é usado quando uma declaração não está definida
ou o valor especificado não pode ser analisado como o tipo esperado.

Por exemplo, se você deseja imprimir mensagens de log
somente quando a declaração de ambiente `DEBUG` estiver definida como `true`:

<?code-excerpt "misc/lib/development/environment_declarations.dart (debug-log)"?>
```dart
void log(String message) {
  // Registra a mensagem de depuração se a declaração de ambiente 'DEBUG' for `true`.
  // Se nenhum valor foi especificado, não registre.
  if (const bool.fromEnvironment('DEBUG', defaultValue: false)) {
    print('Debug: $message');
  }
}
```

Neste trecho, se `DEBUG` estiver definido como `false`
durante a compilação, ou não especificado,
os compiladores de produção podem remover completamente a condição e seu corpo.

Os construtores `fromEnvironment` retornam para
um valor padrão quando a declaração não é especificada ou
o valor especificado não pode ser analisado.
Portanto, para verificar especificamente se
uma declaração de ambiente foi especificada,
use o construtor [`bool.hasEnvironment`][bool-has]:

<?code-excerpt "misc/lib/development/environment_declarations.dart (has-debug)"?>
```dart
if (const bool.hasEnvironment('DEBUG')) {
  print('O comportamento de depuração foi configurado!');
}
```

[string-from]: {{site.dart-api}}/dart-core/String/String.fromEnvironment.html
[int-from]: {{site.dart-api}}/dart-core/int/int.fromEnvironment.html
[bool-from]: {{site.dart-api}}/dart-core/bool/bool.fromEnvironment.html
[bool-has]: {{site.dart-api}}/dart-core/bool/bool.hasEnvironment.html

## Especificando declarações de ambiente

:::warning
As ferramentas e compiladores Dart atualmente não
lidam consistentemente com declarações de ambiente
com valores separados por vírgula.
Para acompanhar a padronização desse tratamento,
consulte [o issue 44995 do SDK][SDK issue 44995].
:::

[SDK issue 44995]: {{site.repo.dart.sdk}}/issues/44995

### CLI do Dart

Tanto `dart run` quanto os subcomandos `dart compile` aceitam
qualquer número de opções `-D` ou `--define`
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

Para saber mais sobre como configurar o `webdev` para passar declarações de ambiente
para os compiladores da web de desenvolvimento e produção,
confira [a documentação de configuração do `webdev`][webdev-config].

[webdev-config]: {{site.pub-pkg}}/build_web_compilers#configuring--d-environment-variables

### Visual Studio Code

Em sua configuração de lançamento (`launch.json`) em `configurations`,
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

Para saber mais, confira a documentação para
[configurações de lançamento do VS Code][VSC instructions].

[VSC instructions]: https://code.visualstudio.com/docs/editor/debugging#_launch-configurations

### IDEs JetBrains

Nas **Configurações de Execução/Depuração** para seu projeto,
adicione as declarações de ambiente desejadas em **Opções de VM**:

![Adicionando opção de definição ao IDE Jetbrains](/assets/img/env-decl-jetbrains.png){:width="500"}

Para saber mais, confira a documentação da JetBrains para
[Configurações de Execução/Depuração do Dart][jetbrains-run-debug].

[jetbrains-run-debug]: https://www.jetbrains.com/help/webstorm/run-debug-configuration-dart-command-line-application.html

### Flutter

Para especificar declarações de ambiente para a ferramenta Flutter,
use a opção `--dart-define` em vez disso:

```console
$ flutter run --dart-define=DEBUG=true
```

{%- comment %}
  TODO: Assim que o Flutter adicionar a documentação `--dart-define`:
  Para saber mais, confira a documentação do Flutter sobre `--dart-define`.
{% endcomment -%}
