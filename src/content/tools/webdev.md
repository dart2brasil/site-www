---
title: webdev
description: Command-line tools for Dart web development.
ia-translate: true
---

Esta página explica como usar `webdev` para compilar seu aplicativo e
`build_runner` para testar seu aplicativo.

## Configuração

Siga estas instruções para começar a usar `webdev`.

Antes de usar `webdev`, adicione dependências aos pacotes [build_runner][]
e [build_web_compilers][] ao seu aplicativo. O pacote `build_runner`
adiciona recursos de script ao `webdev`.

```console
$ dart pub add build_runner build_web_compilers --dev
```

### Instalando e atualizando webdev

Use `dart pub` para instalar `webdev` para [todos os usuários][all users].

```console
$ dart pub global activate webdev
```

Use o mesmo comando para atualizar `webdev`.
Atualize `webdev` quando você atualizar seu Dart SDK ou quando comandos `webdev` falharem de uma forma que você não consiga explicar.

[all users]: /tools/pub/cmd/pub-global


### Dependendo de pacotes build_*

Para usar `webdev`, você deve estar no diretório raiz de um pacote que
depende dos pacotes **build_runner** e **build_web_compilers**.
Se você estiver testando o aplicativo, ele também deve depender de **build_test**.

Para depender desses pacotes, adicione as seguintes [dev_dependencies][] ao
arquivo `pubspec.yaml` do seu aplicativo:

```yaml
  dev_dependencies:
    # ···
    build_runner: ^2.8.0
    build_test: ^3.4.0
    build_web_compilers: ^4.2.3
```

Como de costume após alterações em `pubspec.yaml`, execute `dart pub get` ou
`dart pub upgrade`:

```console
$ dart pub get
```

## Usando comandos de pacotes Dart para compilar e testar

Esta ferramenta pode compilar de duas maneiras: uma que facilita a depuração
(`serve`) e uma que gera código pequeno e rápido (`build`).

O compilador de desenvolvimento oferece suporte a atualizações incrementais e produz
[módulos Asynchronous Module Definition (AMD).](https://github.com/amdjs/amdjs-api/blob/master/AMD.md#amd).
Com [`webdev serve`](#serve), você pode editar seus arquivos Dart, atualizar no
Chrome e ver suas edições rapidamente. Essa velocidade vem de
compilar módulos atualizados, não todos os pacotes que seu aplicativo requer.

A primeira compilação leva mais tempo, pois compila o aplicativo inteiro.
Enquanto o comando [`serve`](#serve) é executado, compilações sucessivas devem compilar
mais rapidamente.

O compilador de produção gera um único arquivo JavaScript minificado.

Esta seção descreve como usar os seguintes comandos:

[webdev serve](#serve)
: Executa um servidor de desenvolvimento que compila continuamente um aplicativo JavaScript.

[webdev build](#build)
: Compila uma versão implantável de um aplicativo JavaScript.

[build_runner test](#test)
: Executa testes.

Você pode personalizar sua compilação usando arquivos de configuração de compilação.
Para saber mais sobre arquivos de configuração de compilação, consulte o
pacote [build_web_compilers][].

### webdev serve {:#serve}

Para servir uma versão de desenvolvimento do seu aplicativo web, execute o seguinte
comando.

```plaintext
$ webdev serve [--debug | --release] [ [<directory>[:<port>]] ... ]
```

Este comando inicia um servidor de desenvolvimento que serve seu aplicativo e
monitora alterações no código-fonte. Por padrão, este comando serve o
 aplicativo em [localhost:8080](localhost:8080):

```console
$ webdev serve
```

O primeiro `webdev serve` compila lentamente. Após a primeira compilação, ele armazena em cache
os ativos no disco. Isso torna as compilações posteriores mais rápidas.

:::note
O compilador de desenvolvimento oferece suporte **apenas ao Chrome.**
Para visualizar seu aplicativo em outro navegador,
use o compilador de produção.
O compilador de produção oferece suporte às duas versões mais recentes do Chrome,
Edge, Firefox e Safari.
:::

Para habilitar o [Dart DevTools][], adicione a flag `--debug`:

```console
$ webdev serve --debug  # enables Dart DevTools
```

Para usar o compilador de produção em vez do compilador de desenvolvimento, adicione a flag `--release`:

```console
$ webdev serve --release  # uses production compiler
```

Você pode especificar diferentes configurações de diretório-porta.

Por exemplo, o seguinte comando altera a porta de teste do
padrão (8081) para 8083:

```console
$ webdev serve web test:8083 # App: 8080; tests: 8083
```

### webdev build {:#build}

Use o seguinte comando para compilar seu aplicativo:

```plaintext
$ webdev build [--no-release] --output [<dirname>:]<dirname>
```

Por padrão, o comando `build` usa o compilador JavaScript de produção para criar uma versão de produção do seu aplicativo. Adicione `--no-release` para compilar com o compilador JavaScript de desenvolvimento. Use a opção `--output` para controlar onde o Dart compila as pastas de nível superior do projeto e grava sua saída.

O seguinte comando mostra como compilar a pasta `web` de nível superior
do projeto no diretório `build`. Este comando usa o
compilador JavaScript de produção por padrão.

```console
$ webdev build --output web:build
```


### build_runner test {:#test}

Use o comando `build_runner test` para executar os testes de componente do seu aplicativo:

```console
$ dart run build_runner test [build_runner options] -- -p <platform> [test options]
```

:::tip
Se o comando falhar ao carregar o arquivo de teste,
certifique-se de que o `pubspec` do seu aplicativo tenha uma `dev_dependency` em `build_test`.
:::

Por exemplo, veja como executar todos os testes da plataforma Chrome:

```console
$ dart run build_runner test -- -p chrome
```

Para ver todas as opções disponíveis do build_runner, use a opção `--help` ou `-h`:

```console
$ dart run build_runner test -h
```

O Dart passa argumentos após o argumento `--` vazio diretamente para o
runner do [pacote test][test package]. Para ver todas as opções de linha de comando para o
runner do pacote test, use este comando:

```console
$ dart test -h
```

## Mais informações

Para uma lista completa de opções do `webdev`, execute `webdev --help` ou consulte o
[pacote webdev][webdev].

Veja também as seguintes páginas:

* [build_runner:][build_runner]
  Apresenta o build_runner e seus comandos integrados,
  e aponta para mais informações.
* [build_web_compilers:][build_web_compilers]
  Contém informações sobre como configurar compilações,
  com um exemplo de uso de `dart2js_args` para especificar
  [opções do compilador](/tools/dart-compile#js).

[build_runner]: /tools/build_runner
[build_web_compilers]: {{site.pub-pkg}}/build_web_compilers
[Dart DevTools]: /tools/dart-devtools
[dev_dependencies]: /tools/pub/dependencies#dev-dependencies
[test package]: {{site.pub-pkg}}/test
[webdev]: {{site.pub-pkg}}/webdev
