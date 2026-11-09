---
ia-translate: true
---
#### Opções {:#prod-compile-options}

O comando `dart compile js` possui múltiplas opções
para personalizar a compilação de código JavaScript.

* [Opções básicas](#basic-options)
* [Opções de caminho e ambiente](#path-and-environment-options)
* [Opções de exibição](#display-options)
* [Opções de análise](#analysis-options)

###### Opções básicas {:#basic-options}

Opções comuns incluem:

`-o <file>` ou `--output=<file>`
: Gera a saída em `<file>`.
  Se não for especificado, a saída vai para um arquivo chamado `out.js`.

`--enable-asserts`
: Habilita a verificação de assertions.

`-O{0|1|2|3|4}`
: Controla otimizações para reduzir o tamanho do arquivo e
  melhorar o desempenho do código.
  Para saber mais sobre essas otimizações,
  execute `dart compile js -hv`.

  * `-O0`: Desabilita muitas otimizações.
  * `-O1`: Habilita otimizações padrão.
  * `-O2`: Habilita as otimizações de `-O1`, além de outras
    (como minificação) que respeitam a semântica da linguagem e
    são seguras para todos os programas.

    :::note
    Com `-O2`, as representações de string dos tipos deixam de ser iguais às
    da Dart VM quando compilado com o compilador JavaScript de desenvolvimento.
    :::
  * `-O3`: Habilita as otimizações de `-O2`, além de omitir verificações implícitas de tipo.

    :::warning
    Omitir verificações de tipo pode fazer sua aplicação falhar por erros de tipo.
    Antes de usar `-O3`, **teste com `-O2`** para garantir que sua aplicação
    **nunca** lance um subtipo de `Error` (como `TypeError`).
    :::
  * `-O4`: Habilita otimizações mais agressivas que `-O3`,
    mas com as mesmas premissas.

    :::warning
    As otimizações de `-O4` são suscetíveis a variações nos dados de entrada.
    Antes de depender de `-O4`, **teste casos extremos na entrada do usuário**.
    :::

`--no-source-maps`
: Não gera um arquivo source map.
  Por padrão, o `dart compile js` gera automaticamente um arquivo de source map
  `.js.map` ao lado do código JavaScript gerado.
  Use esta flag para desabilitar a geração de source maps.
  Para considerações de segurança e privacidade ao publicar source maps,
  veja [Deploy para web][manage-source-maps].

`-h` ou `--help`
: Exibe ajuda. Para obter informações sobre todas as opções, use `-hv`.


###### Opções de caminho e ambiente {:#path-and-environment-options}

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
  veja [Configurando apps com declarações de ambiente de compilação][Configuring apps with compilation environment declarations].

`--version`
: Exibe informações de versão do `dart`.

[Dart package configuration file]: {{site.repo.dart.lang}}/blob/main/accepted/2.8/language-versioning/package-config-file-v2.md
[`String.fromEnvironment`]: {{site.dart-api}}/dart-core/String/String.fromEnvironment.html
[`int.fromEnvironment`]: {{site.dart-api}}/dart-core/int/int.fromEnvironment.html
[`bool.fromEnvironment`]: {{site.dart-api}}/dart-core/bool/bool.fromEnvironment.html
[`bool.hasEnvironment`]: {{site.dart-api}}/dart-core/bool/bool.hasEnvironment.html
[Configuring apps with compilation environment declarations]: /libraries/core/environment-declarations
[manage-source-maps]: /web/deployment#manage-source-maps-and-unneeded-build-files

###### Opções de exibição {:#display-options}

As seguintes opções ajudam você a controlar a saída do compilador.

`--suppress-warnings`
: Não exibe avisos.

`--suppress-hints`
: Não exibe dicas.

`--terse`
: Emite diagnósticos,
  sem sugerir como resolver os problemas diagnosticados.

`-v` ou `--verbose`
: Exibe muitas informações.


###### Opções de análise {:#analysis-options}

As seguintes opções controlam a análise feita sobre o código Dart.

`--fatal-warnings`
: Trata avisos como erros de compilação.

`--enable-diagnostic-colors`
: Adiciona cores às mensagens de diagnóstico.

`--show-package-warnings`
: Mostra avisos e dicas gerados por pacotes.

`--csp`
: Desabilita a geração dinâmica de código na saída gerada.
  Isso é necessário para atender às restrições de CSP
  (veja [W3C Content Security Policy.](https://www.w3.org/TR/CSP/))

`--dump-info`
: Gera um arquivo (com o sufixo `.info.json`)
  que contém informações sobre o código gerado.
  Você pode inspecionar o arquivo gerado com as ferramentas do
  [dart2js_info](/go/dart2js-info).

`--[no-]deprecated-js-interop`
: Habilita ou desabilita o suporte à interop JS legada com `dart:*`
  e às bibliotecas web (`dart:html`, `dart:indexed_db`,
  `dart:js`, `dart:js_util`, `dart:svg`, `dart:web_audio` e
  `dart:web_gl`), além dos pacotes que as importam
  (como `package:js`).
  Habilitado por padrão (`--deprecated-js-interop`).
  Quando você passa a flag `--no-deprecated-js-interop`,
  importar qualquer uma dessas bibliotecas resulta em erro de compilação,
  que mostra os caminhos de import mais curtos até as bibliotecas depreciadas.
  Além disso, as condições de ambiente `dart.library.*` delas
  (como `dart.library.html` e `dart.library.js_util`)
  são avaliadas como `false` em imports condicionais e em [`bool.fromEnvironment`][].
  Para detalhes, consulte
  [Desabilitar bibliotecas de interop JS legadas][disallow-legacy].

[disallow-legacy]: /interop/js-interop/past-js-interop#disallow-deprecated-js-interop
