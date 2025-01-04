---
ia-translate: true
title: "Começar: Aplicativos de linha de comando e servidor"
description: Obtenha o Dart, execute e compile um pequeno aplicativo.
js: [{url: '/assets/js/inject_dartpad.js', defer: true}]
prevpage:
  url: /tutorials/server
  title: Tutoriais de linha de comando e servidor Dart
nextpage:
  url: /tutorials/server/cmdline
  title: Escrever aplicativos de linha de comando
---

Siga estas etapas para começar a usar o SDK Dart para desenvolver aplicativos de linha de comando e servidor.
Primeiro, você vai experimentar a linguagem Dart no seu navegador, sem necessidade de download.
Em seguida, você vai instalar o SDK Dart, escrever um pequeno programa e executar esse programa usando a Dart VM (máquina virtual Dart).
Finalmente, você vai usar um compilador AOT (_ahead of time_ - antecipado) para compilar seu programa finalizado em código de máquina nativo,
que você executará usando o _runtime_ (tempo de execução) Dart.

## 1. Experimente o código Dart no DartPad {:#1-play-with-dart-code-in-dartpad}

Com o [DartPad](/tools/dartpad), você pode experimentar a linguagem Dart e
APIs, sem necessidade de download.

Por exemplo, aqui está um DartPad incorporado que permite que você experimente o código de um
pequeno programa Hello World. Clique em **Run** (Executar) para executar o aplicativo; a saída aparece na
visualização do console. Tente editar o código-fonte — talvez você queira mudar a
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

* [Documentação do DartPad][]
* [Tour da linguagem Dart][]
* [Documentação da biblioteca principal do Dart][]

## 2. Instale o Dart {:#2-install-dart}

{% include 'get-sdk.md' %}

## 3. Crie um pequeno aplicativo {:#3-create-a-small-app}

Use o comando [`dart create`](/tools/dart-create)
e o _template_ `console` para criar um aplicativo de linha de comando:

```console
$ dart create -t console cli
```

Este comando cria um pequeno aplicativo Dart que tem o seguinte:

* Um arquivo de código-fonte Dart principal, `bin/cli.dart`, que contém uma função
  `main()` de nível superior. Este é o ponto de entrada para o seu aplicativo.
* Um arquivo Dart adicional, `lib/cli.dart`, que contém a funcionalidade do
  aplicativo e é importado pelo arquivo `cli.dart`.
* Um arquivo pubspec, `pubspec.yaml`, que contém os metadados do aplicativo, incluindo
  informações sobre quais [pacotes](/tools/pub/packages) o aplicativo depende
  e quais versões desses pacotes são necessárias.

:::note
Por baixo dos panos (under the hood), `dart create` executa [`dart pub get`][], que
verifica o arquivo pubspec gerado e baixa as dependências.
Se você adicionar outras dependências ao seu arquivo pubspec,
execute `dart pub get` para baixá-las.
:::

[`dart pub get`]: /tools/pub/cmd/pub-get

## 4. Execute o aplicativo {:#4-run-the-app}

Para executar o aplicativo a partir da linha de comando, use a Dart VM executando o
comando [`dart run`](/tools/dart-run) no diretório superior do aplicativo:

```console
$ cd cli
$ dart run
Hello world: 42!
```

Se você quiser executar o aplicativo com suporte de depuração, consulte
[Dart DevTools](/tools/dart-devtools).

## 5. Modifique o aplicativo {:#5-modify-the-app}

Vamos personalizar o aplicativo que você acabou de criar.

 1. Edite `lib/cli.dart` para calcular um resultado diferente. Por exemplo, divida o
    valor anterior por dois (para detalhes sobre `~/`, veja [Operadores aritméticos][]):

    <?code-excerpt "misc/test/tutorial/get_started.dart (calculate)" replace="/~\/ 2/[!$&!]/g"?>
    ```dart
    int calculate() {
      return 6 * 7 [!~/ 2!];
    }
    ```

 1. Salve suas alterações.

 1. Execute novamente o ponto de entrada principal do seu aplicativo:

    ```console
    $ dart run
    Hello world: 21!
    ```

Mais informações:
[Escrever aplicativos de linha de comando](/tutorials/server/cmdline)

## 6. Compile para produção {:#6-compile-for-production}

As etapas acima usaram a Dart VM (`dart`) para executar o aplicativo. A Dart VM é
otimizada para compilação rápida e incremental para fornecer _feedback_ instantâneo
durante o desenvolvimento. Agora que seu pequeno aplicativo está pronto,
é hora de compilar AOT seu código Dart para código de máquina nativo otimizado.

Use a ferramenta `dart compile` para compilar AOT o programa para código de máquina:

```console
$ dart compile exe bin/cli.dart
```

Observe como o programa compilado é iniciado instantaneamente, concluindo rapidamente:

```console
$ time bin/cli.exe
Hello world: 21!

real	0m0.016s
user	0m0.008s
sys	0m0.006s
```

## O que vem a seguir? {:#what-next}

Confira estes recursos:

* [Tutoriais](/tutorials) Dart
* Linguagem, bibliotecas e convenções Dart
  * [Tour da linguagem](/language)
  * [Documentação da biblioteca principal do Dart](/libraries)
  * [Dart eficaz](/effective-dart)
* Ferramentas e bibliotecas
  * [SDK Dart](/tools/sdk)
  * [Ferramentas Dart](/tools)
  * [IDEs](/tools#editors)
* Outros exemplos de aplicativos compilados nativamente
  * [native_app]({{site.repo.dart.org}}/samples/tree/main/native_app)

Se você ficar preso, encontre ajuda em [Comunidade e suporte.](/community)

[Operadores aritméticos]: /language/operators#arithmetic-operators
[Documentação do DartPad]: /tools/dartpad
[Tour da linguagem Dart]: /language
[Documentação da biblioteca principal do Dart]: /libraries
[ide]: /tools#editors
