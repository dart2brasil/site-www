---
ia-translate: true
title: "Primeiros passos: Aplicações de linha de comando e servidor"
description: Obtenha o Dart, execute e compile uma pequena aplicação.
prevpage:
  url: /tutorials/server
  title: Tutoriais de linha de comando e servidor Dart
nextpage:
  url: /tutorials/server/cmdline
  title: Escrever aplicações de linha de comando
---

Siga estes passos para começar a usar o Dart SDK para desenvolver aplicações de linha de comando e servidor.
Primeiro você vai brincar com a linguagem Dart no seu navegador, sem necessidade de download.
Depois você vai instalar o Dart SDK, escrever um pequeno programa e executar esse programa usando a Dart VM.
Finalmente, você vai usar um compilador AOT (_ahead of time_) para compilar seu programa finalizado para código de máquina nativo,
que você vai executar usando o runtime Dart.

## 1. Brinque com código Dart no DartPad

Com o [DartPad][DartPad documentation] você pode experimentar com a linguagem Dart e
APIs, sem necessidade de download.

Por exemplo, aqui está um DartPad incorporado que permite você brincar com o código de um
pequeno programa Hello World. Clique em **Run** para executar a aplicação; a saída aparece na
visualização do console. Tente editar o código-fonte—talvez você queira mudar a
saudação para usar outro idioma.

:::note
{% render 'dartpad-embedded-troubleshooting.md' %}
:::

<?code-excerpt "misc/test/samples_test.dart (hello-world)"?>
```dartpad
void main() {
  print('Hello, World!');
}
```

Mais informações:

* [Documentação do DartPad][DartPad documentation]
* [Tour da linguagem Dart][Dart language tour]
* [Documentação da biblioteca core do Dart][Dart core library documentation]

## 2. Instale o Dart

Para desenvolver aplicações Dart, você precisa do Dart SDK.
Para continuar com este guia,
ou [baixe o Dart SDK][dart-download] ou
[instale o Flutter][flutter-download],
que inclui o Dart SDK completo.

[dart-download]: /get-dart
[flutter-download]: {{site.flutter-docs}}/get-started/install

## 3. Crie uma pequena aplicação

Use o comando [`dart create`](/tools/dart-create)
e o template `console` para criar uma aplicação de linha de comando:

```console
$ dart create -t console cli
```

Este comando cria uma pequena aplicação Dart que tem o seguinte:

* Um arquivo fonte Dart principal, `bin/cli.dart`, que contém uma
  função `main()` de nível superior. Este é o ponto de entrada para sua aplicação.
* Um arquivo Dart adicional, `lib/cli.dart`, que contém a funcionalidade da
  aplicação e é importado pelo arquivo `cli.dart`.
* Um arquivo pubspec, `pubspec.yaml`, que contém os metadados da aplicação, incluindo
  informações sobre quais [pacotes](/tools/pub/packages) a aplicação depende
  e quais versões desses pacotes são necessárias.

:::note
Nos bastidores, `dart create` executa [`dart pub get`][], que
escaneia o arquivo pubspec gerado e baixa as dependências.
Se você adicionar outras dependências ao seu arquivo pubspec,
então execute `dart pub get` para baixá-las.
:::

[`dart pub get`]: /tools/pub/cmd/pub-get

## 4. Execute a aplicação

Para executar a aplicação da linha de comando, use a Dart VM executando o
comando [`dart run`](/tools/dart-run) no diretório principal da aplicação:

```console
$ cd cli
$ dart run
Hello world: 42!
```

Se você quiser executar a aplicação com suporte a debugging, veja
[Dart DevTools](/tools/dart-devtools).

## 5. Modifique a aplicação

Vamos personalizar a aplicação que você acabou de criar.

 1. Edite `lib/cli.dart` para calcular um resultado diferente. Por exemplo, divida o
    valor anterior por dois (para detalhes sobre `~/`, veja [Operadores aritméticos][Arithmetic operators]):

    <?code-excerpt "misc/test/tutorial/get_started.dart (calculate)" replace="/~\/ 2/[!$&!]/g"?>
    ```dart
    int calculate() {
      return 6 * 7 [!~/ 2!];
    }
    ```

 1. Salve suas alterações.

 1. Execute novamente o ponto de entrada principal da sua aplicação:

    ```console
    $ dart run
    Hello world: 21!
    ```

Mais informações:
[Escrever aplicações de linha de comando](/tutorials/server/cmdline)

## 6. Compile para produção

Os passos acima usaram a Dart VM (`dart`) para executar a aplicação. A Dart VM é
otimizada para compilação rápida e incremental para fornecer feedback instantâneo
durante o desenvolvimento. Agora que sua pequena aplicação está pronta,
é hora de compilar AOT seu código Dart para código de máquina nativo otimizado.

Use a ferramenta `dart compile` para compilar AOT o programa para código de máquina:

```console
$ dart compile exe bin/cli.dart
```

Note como o programa compilado inicia instantaneamente, completando rapidamente:

```console
$ time bin/cli.exe
Hello world: 21!

real	0m0.016s
user	0m0.008s
sys	0m0.006s
```

## E agora?

Confira estes recursos:

* [Tutoriais](/tutorials) Dart
* Linguagem Dart, bibliotecas e convenções
  * [Tour da linguagem](/language)
  * [Documentação da biblioteca core do Dart](/libraries)
  * [Dart eficaz](/effective-dart)
* Ferramentas e bibliotecas
  * [Dart SDK](/tools/sdk)
  * [Ferramentas Dart](/tools)
  * [IDEs](/tools#editors)
* Outros exemplos de aplicações compiladas nativamente
  * [native_app]({{site.repo.dart.samples}}/tree/main/native_app)

Se você ficar preso, encontre ajuda em [Comunidade e suporte.](/community)

[Arithmetic operators]: /language/operators#arithmetic-operators
[DartPad documentation]: /tools/dartpad
[Dart language tour]: /language
[Dart core library documentation]: /libraries
[ide]: /tools#editors
