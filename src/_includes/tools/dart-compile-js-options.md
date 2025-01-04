<!-- ia-translate: true -->
#### Opções {:#prod-compile-options}

O comando `dart compile js` possui múltiplas opções
para personalizar a compilação de código JavaScript.

* [Opções básicas](#basic-options)
* [Opções de caminho e ambiente](#path-and-environment-options)
* [Opções de exibição](#display-options)
* [Opções de análise](#analysis-options)

###### Opções básicas {:#basic-options}

As opções comuns incluem:

`-o <arquivo>` ou `--output=<arquivo>`
: Gera a saída em `<arquivo>`.
  Se não for especificado, a saída vai para um arquivo chamado `out.js`.

`--enable-asserts`
: Habilita a verificação de asserts (afirmações).

`-O{0|1|2|3|4}`
: Controla as otimizações para reduzir o tamanho do arquivo e
  melhorar o desempenho do código.
  Para saber mais sobre essas otimizações,
  execute `dart compile js -hv`.

  * `-O0`: Desabilita muitas otimizações.
  * `-O1`: Habilita as otimizações padrão.
  * `-O2`: Habilita as otimizações `-O1`, mais algumas adicionais
    (como minificação) que respeitam a semântica da linguagem e
    são seguras para todos os programas.

    :::note
    Com `-O2`, as representações de string dos tipos não são mais as mesmas que
    aquelas na Dart VM quando compiladas com o compilador JavaScript de desenvolvimento.
    :::
  * `-O3`: Habilita as otimizações `-O2`, mais omite verificações de tipo implícitas.

    :::warning
    Omitir verificações de tipo pode causar a falha do seu aplicativo devido a erros de tipo.
    Antes de usar `-O3`, **teste usando `-O2`** para garantir que seu aplicativo
    **nunca** lance um subtipo de `Error` (como `TypeError`).
    :::
  * `-O4`: Habilita otimizações mais agressivas que `-O3`,
    mas com as mesmas premissas.

    :::warning
    As otimizações `-O4` são suscetíveis a variações nos dados de entrada.
    Antes de confiar em `-O4`, **teste casos extremos em entradas de usuário**.
    :::

`--no-source-maps`
: Não gera um arquivo source map.

`-h` ou `--help`
: Exibe a ajuda. Para obter informações sobre todas as opções, use `-hv`.

###### Opções de caminho e ambiente {:#path-and-environment-options}

Outras opções úteis incluem:

`--packages=<caminho>`
: Especifica o caminho para o arquivo de configuração de resolução de pacotes.
  Para mais informações, consulte a especificação de
  [Arquivo de configuração de pacotes Dart][] (Dart package configuration file).

`-D<flag>=<valor>`
: Define uma declaração de ambiente e um par de valor
  que podem ser acessados com
  [`String.fromEnvironment`][], [`int.fromEnvironment`][],
  [`bool.fromEnvironment`][], ou [`bool.hasEnvironment`][].
  Para saber mais sobre declarações de ambiente,
  consulte [Configurando aplicativos com declarações de ambiente de compilação][].

`--version`
: Exibe informações da versão para `dart`.

[Arquivo de configuração de pacotes Dart]: {{site.repo.dart.lang}}/blob/main/accepted/2.8/language-versioning/package-config-file-v2.md
[`String.fromEnvironment`]: {{site.dart-api}}/dart-core/String/String.fromEnvironment.html
[`int.fromEnvironment`]: {{site.dart-api}}/dart-core/int/int.fromEnvironment.html
[`bool.fromEnvironment`]: {{site.dart-api}}/dart-core/bool/bool.fromEnvironment.html
[`bool.hasEnvironment`]: {{site.dart-api}}/dart-core/bool/bool.hasEnvironment.html
[Configurando aplicativos com declarações de ambiente de compilação]: /guides/environment-declarations

###### Opções de exibição {:#display-options}

As opções a seguir ajudam a controlar a saída do compilador.

`--suppress-warnings`
: Não exibe avisos.

`--suppress-hints`
: Não exibe dicas.

`--terse`
: Emite diagnósticos,
  sem sugerir como se livrar dos problemas diagnosticados.

`-v` ou `--verbose`
: Exibe muitas informações.


###### Opções de análise {:#analysis-options}

As opções a seguir controlam a análise realizada no código Dart.

`--fatal-warnings`
: Trata avisos como erros de compilação.

`--enable-diagnostic-colors`
: Adiciona cores às mensagens de diagnóstico.

`--show-package-warnings`
: Mostra avisos e dicas geradas a partir de packages.

`--csp`
: Desabilita a geração dinâmica de código na saída gerada.
  Isso é necessário para satisfazer as restrições CSP
  (consulte [Política de Segurança de Conteúdo W3C](https://www.w3.org/TR/CSP/)).

`--dump-info`
: Gera um arquivo (com o sufixo `.info.json`)
  que contém informações sobre o código gerado.
  Você pode inspecionar o arquivo gerado com ferramentas em
  [dart2js_info](/go/dart2js-info).
