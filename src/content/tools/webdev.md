---
ia-translate: true
title: webdev
description: Ferramentas de linha de comando para desenvolvimento web em Dart.
---

Esta página explica como usar o `webdev` para compilar seu aplicativo e
o `build_runner` para testar seu aplicativo.

## Configuração {:#setup}

Siga estas instruções para começar a usar o `webdev`.

Antes de usar o `webdev`, adicione dependências aos pacotes [build_runner][]
e [build_web_compilers][] ao seu aplicativo. O pacote `build_runner`
adiciona recursos de script ao `webdev`.

```console
$ dart pub add build_runner build_web_compilers --dev
```

### Instalando e atualizando o webdev {:#installing-and-updating-webdev}

Use `dart install` para instalar o `webdev` globalmente.

```console
$ dart install webdev
```

Use o mesmo comando para atualizar o `webdev`.
Atualize o `webdev` quando atualizar seu Dart SDK,
ou quando os comandos do `webdev` falharem de um jeito que você não consiga explicar.

### Dependendo dos pacotes build_* {:#depending-on-build-packages}

Para usar o `webdev`, você precisa estar no diretório raiz de um pacote que
depende dos pacotes **build_runner** e **build_web_compilers**.
Se você estiver testando o aplicativo, ele também precisa depender do **build_test**.

Para depender desses pacotes, adicione as seguintes [dev_dependencies][] ao
arquivo `pubspec.yaml` do seu aplicativo:

```yaml
  dev_dependencies:
    # ···
    build_runner: ^2.15.1
    build_test: ^3.5.16
    build_web_compilers: ^4.8.5
```

Como de costume, após alterações no `pubspec.yaml`, execute `dart pub get` ou
`dart pub upgrade`:

```console
$ dart pub get
```

## Usando comandos de pacotes Dart para compilar e testar {:#using-commands-from-dart-packages-to-compile-and-test}

Esta ferramenta pode compilar de duas maneiras: uma que facilita a depuração
(`serve`) e outra que gera código pequeno e rápido (`build`).

O compilador de desenvolvimento oferece suporte a atualizações incrementais e produz
[módulos Asynchronous Module Definition (AMD)][amd-modules].
Com o [`webdev serve`](#serve), você pode editar seus arquivos Dart, atualizar no
Chrome e ver suas edições em pouco tempo. Essa velocidade vem da
compilação dos módulos atualizados, e não de todos os pacotes que seu aplicativo requer.

A primeira compilação é a mais demorada, pois compila o aplicativo inteiro.
Enquanto o comando [`serve`](#serve) estiver em execução, as compilações seguintes devem ser mais rápidas.

O compilador de produção gera um único arquivo JavaScript minificado.

Esta seção descreve como usar os seguintes comandos:

[webdev serve](#serve)
: Executa um servidor de desenvolvimento que compila continuamente um aplicativo JavaScript.

[webdev build](#build)
: Compila uma versão implantável de um aplicativo JavaScript.

[build_runner test](#test)
: Executa os testes.

Você pode personalizar sua compilação usando arquivos de configuração de build.
Para saber mais sobre esses arquivos, veja o
pacote [build_web_compilers][].

:::version-note
A partir do Dart 3.14 (com o `webdev` 4.1.0 e
[`build_web_compilers`][build_web_compilers] 4.9.0),
passe a flag `--no-deprecated-js-interop` para comandos do `webdev`
como `webdev serve` e `webdev build`
para proibir bibliotecas `dart:*` obsoletas e pacotes que as importam
(incluindo `package:js`).
Para configurar o `build.yaml` diretamente,
defina `deprecated-js-interop: false` em `global_options`
para os quatro builders do `build_web_compilers`
(`build_web_compilers:ddc`, `build_web_compilers:ddc_modules`,
`build_web_compilers:dart2js_modules` e `build_web_compilers:entrypoint`).
Para mais detalhes, consulte
[Proibir bibliotecas JS interop obsoletas][disallow-legacy].
:::

[amd-modules]: https://github.com/amdjs/amdjs-api/blob/master/AMD.md#amd

### webdev serve {:#serve}

Para servir uma versão de desenvolvimento do seu aplicativo web, execute o seguinte
comando.

```plaintext
$ webdev serve [--debug | --release] [ [<directory>[:<port>]] ... ]
```

Este comando inicia um servidor de desenvolvimento que serve seu aplicativo e
monitora as alterações no código-fonte. Por padrão, o comando serve o
 aplicativo em [localhost:8080](localhost:8080):

```console
$ webdev serve
```

O primeiro `webdev serve` compila devagar. Após a primeira compilação, ele armazena em cache
os assets no disco. Isso torna as compilações seguintes mais rápidas.

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

Para usar o compilador de produção em vez do de desenvolvimento, adicione a flag `--release`:

```console
$ webdev serve --release  # uses production compiler
```

Você pode especificar diferentes configurações de diretório e porta.

Por exemplo, o comando a seguir altera a porta de teste do
padrão (8081) para 8083:

```console
$ webdev serve web test:8083 # App: 8080; tests: 8083
```

### webdev build {:#build}

Use o seguinte comando para compilar seu aplicativo:

```plaintext
$ webdev build [--no-release] --output [<dirname>:]<dirname>
```

Por padrão, o comando `build` usa o compilador JavaScript de produção para criar uma versão de produção do seu aplicativo. Adicione `--no-release` para compilar com o compilador JavaScript de desenvolvimento. Use a opção `--output` para controlar onde o Dart compila as pastas de nível superior do projeto e grava a saída.

O comando a seguir mostra como compilar a pasta `web`, de nível superior no
projeto, no diretório `build`. Este comando usa o
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
verifique se o `pubspec` do seu aplicativo tem uma `dev_dependency` em `build_test`.
:::

Por exemplo, veja como executar todos os testes da plataforma Chrome:

```console
$ dart run build_runner test -- -p chrome
```

Para ver todas as opções disponíveis do build_runner, use a opção `--help` ou `-h`:

```console
$ dart run build_runner test -h
```

O Dart passa os argumentos após o argumento `--` vazio diretamente para o
runner do [pacote test][test package]. Para ver todas as opções de linha de comando do
runner do pacote test, use este comando:

```console
$ dart test -h
```

## Mais informações {:#more-information}

Para uma lista completa das opções do `webdev`, execute `webdev --help` ou consulte o
[pacote webdev][webdev].

Veja também as páginas a seguir:

* [build_runner:][build_runner]
  Apresenta o build_runner e seus comandos integrados,
  e aponta para mais informações.
* [build_web_compilers:][build_web_compilers]
  Traz informações sobre como configurar builds,
  com um exemplo de uso de `dart2js_args` para especificar
  [opções do compilador](/tools/dart-compile#js).

[build_runner]: /tools/build_runner
[build_web_compilers]: {{site.pub-pkg}}/build_web_compilers
[Dart DevTools]: /tools/dart-devtools
[dev_dependencies]: /tools/pub/dependencies#dev-dependencies
[test package]: {{site.pub-pkg}}/test
[webdev]: {{site.pub-pkg}}/webdev
[disallow-legacy]: /interop/js-interop/past-js-interop#disallow-deprecated-js-interop
