---
ia-translate: true
---
#### Opções {:#prod-compile-options}

O comando `dart compile js` possui múltiplas opções
para personalizar a compilação de código JavaScript.

* [Opções básicas](#opções-básicas)
* [Opções de caminho e ambiente](#opções-de-caminho-e-ambiente)
* [Opções de exibição](#opções-de-exibição)
* [Opções de análise](#opções-de-análise)

###### Opções básicas

Opções comuns incluem:

`-o <file>` ou `--output=<file>`
: Gera a saída em `<file>`.
  Se não especificado, a saída vai para um arquivo chamado `out.js`.

`--enable-asserts`
: Habilita a verificação de assertions.

`-O{0|1|2|3|4}`
: Controla otimizações para reduzir o tamanho do arquivo e
  melhorar o desempenho do código.
  Para saber mais sobre essas otimizações,
  execute `dart compile js -hv`.

  * `-O0`: Desabilita muitas otimizações.
  * `-O1`: Habilita otimizações padrão.
  * `-O2`: Habilita otimizações `-O1`, além de outras adicionais
    (como minificação) que respeitam a semântica da linguagem e
    são seguras para todos os programas.

    :::note
    Com `-O2`, representações de string de tipos não são mais as mesmas que
    as da Dart VM quando compiladas com o compilador JavaScript de desenvolvimento.
    :::
  * `-O3`: Habilita otimizações `-O2`, além de omitir verificações implícitas de tipo.

    :::warning
    Omitir verificações de tipo pode causar falha na sua aplicação devido a erros de tipo.
    Antes de usar `-O3`, **teste usando `-O2`** para garantir que sua aplicação
    **nunca** lance um subtipo de `Error` (como `TypeError`).
    :::
  * `-O4`: Habilita otimizações mais agressivas que `-O3`,
    mas com as mesmas suposições.

    :::warning
    As otimizações `-O4` são suscetíveis a variações nos dados de entrada.
    Antes de confiar em `-O4`, **teste casos extremos na entrada do usuário**.
    :::

`--no-source-maps`
: Não gera um arquivo source map.

`-h` ou `--help`
: Exibe ajuda. Para obter informações sobre todas as opções, use `-hv`.


###### Opções de caminho e ambiente

Algumas outras opções úteis incluem:

`--packages=<path>`
: Especifica o caminho para o arquivo de configuração de resolução de pacotes.
  Para mais informações, confira a
  especificação do [arquivo de configuração de pacotes do Dart][Dart package configuration file].

`-D<flag>=<value>`
: Define um par de declaração de ambiente e valor
  que pode ser acessado com
  [`String.fromEnvironment`][], [`int.fromEnvironment`][],
  [`bool.fromEnvironment`][] ou [`bool.hasEnvironment`][].
  Para saber mais sobre declarações de ambiente,
  veja [Configurando aplicações com declarações de ambiente de compilação][Configuring apps with compilation environment declarations].

`--version`
: Exibe informações de versão do `dart`.

[Dart package configuration file]: {{site.repo.dart.lang}}/blob/main/accepted/2.8/language-versioning/package-config-file-v2.md
[`String.fromEnvironment`]: {{site.dart-api}}/dart-core/String/String.fromEnvironment.html
[`int.fromEnvironment`]: {{site.dart-api}}/dart-core/int/int.fromEnvironment.html
[`bool.fromEnvironment`]: {{site.dart-api}}/dart-core/bool/bool.fromEnvironment.html
[`bool.hasEnvironment`]: {{site.dart-api}}/dart-core/bool/bool.hasEnvironment.html
[Configuring apps with compilation environment declarations]: /libraries/core/environment-declarations

###### Opções de exibição

As seguintes opções ajudam você a controlar a saída do compilador.

`--suppress-warnings`
: Não exibe avisos.

`--suppress-hints`
: Não exibe dicas.

`--terse`
: Emite diagnósticos,
  sem sugerir como se livrar dos problemas diagnosticados.

`-v` ou `--verbose`
: Exibe muitas informações.


###### Opções de análise

As seguintes opções controlam a análise realizada no código Dart.

`--fatal-warnings`
: Trata avisos como erros de compilação.

`--enable-diagnostic-colors`
: Adiciona cores às mensagens de diagnóstico.

`--show-package-warnings`
: Mostra avisos e dicas gerados de pacotes.

`--csp`
: Desabilita a geração dinâmica de código na saída gerada.
  Isso é necessário para satisfazer restrições CSP
  (veja [W3C Content Security Policy.](https://www.w3.org/TR/CSP/))

`--dump-info`
: Gera um arquivo (com o sufixo `.info.json`)
  que contém informações sobre o código gerado.
  Você pode inspecionar o arquivo gerado com ferramentas em
  [dart2js_info](/go/dart2js-info).
