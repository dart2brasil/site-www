---
ia-translate: true
title: dart doc
description: >-
   Aprenda como gerar documentação de referência HTML para bibliotecas públicas do Dart.
---

O comando `dart doc` gera documentação de referência HTML
para código fonte Dart.

## Escrever documentação {:#write}

Para adicionar texto de referência e exemplos à documentação gerada,
use [comentários de documentação][documentation comments] com formatação [Markdown][].
Para orientação sobre como escrever comentários de documentação,
confira o guia [Effective Dart: Documentation][].

[documentation comments]: /language/comments#documentation-comments
[Markdown]: {{site.pub-pkg}}/markdown
[Effective Dart: Documentation]: /effective-dart/documentation

## Gerar documentos de API {:#generate}

:::note
Para gerar documentação,
você deve primeiro executar [`dart pub get`](/tools/pub/cmd/pub-get)
e seu pacote deve passar pelo [`dart analyze`](/tools/dart-analyze)
sem erros.
:::

Para gerar a documentação para seu pacote,
execute `dart doc .` no diretório raiz do pacote.
Por exemplo, gerar os documentos de API para um pacote `my_package`
pode se parecer com o seguinte:

```console
$ cd my_package
$ dart pub get
$ dart doc .
Documenting my_package...
...
Success! Docs generated into /Users/me/projects/my_package/doc/api
```

Por padrão, `dart doc` coloca a documentação gerada
e arquivos de suporte no diretório `doc/api`.
Para alterar o diretório de saída, especifique
um caminho com a flag `--output`:

```console
$ dart doc --output=api_docs .
```

Se houver algum problema com a configuração do seu pacote ou comentários de documentação,
`dart doc` os exibe como erros ou avisos.
Se você quiser apenas testar problemas sem salvar a documentação gerada,
adicione a flag `--dry-run`:

```console
$ dart doc --dry-run .
```

### Configurar geração {:#configure}

Para configurar como o `dart doc` gera documentação, crie um
arquivo chamado `dartdoc_options.yaml` no diretório raiz do seu pacote.

Para saber mais sobre o formato do arquivo e opções de configuração suportadas,
confira [dart.dev/go/dartdoc-options-file][dartdoc-options].

{% comment %}
TODO: Document the long-term supported options here.
{% endcomment -%}

[dartdoc-options]: {{site.redirect.go}}/dartdoc-options-file

## Visualizar documentos gerados {:#view}

Você pode visualizar documentos gerados com `dart doc` de várias maneiras.

### Visualizar documentos locais {:#view-local}

Para visualizar documentos de API que você gerou com `dart doc` ou baixou online,
você deve carregá-los com um servidor HTTP.

Para servir os arquivos, use qualquer servidor HTTP.
Considere usar [`package:dhttpd`][] do pub.dev.

Para usar `package:dhttpd`, ative-o globalmente, depois execute-o
e especifique o caminho dos seus documentos gerados.
Os seguintes comandos ativam o pacote,
depois o executam para servir os documentos de API localizados em `doc/api`:

```console
$ dart pub global activate dhttpd
$ dart pub global run dhttpd --path doc/api
```

Para então ler os documentos gerados no seu navegador,
abra o link que `dhttpd` exibe, geralmente `http://localhost:8080`.

[`package:dhttpd`]: {{site.pub-pkg}}/dhttpd

### Visualizar documentos hospedados {:#view-hosted}

Você também pode hospedar seus documentos de API gerados online
usando qualquer serviço de hospedagem que suporte conteúdo web estático.
Duas opções comuns são [hospedagem Firebase][Firebase hosting] e [páginas GitHub][GitHub pages].

[Firebase hosting]: https://firebase.google.com/docs/hosting
[GitHub pages]: https://pages.github.com/

### Visualizar documentos de pacote {:#view-pub}

O [site pub.dev]({{site.pub}}) gera e hospeda
documentação para as bibliotecas públicas de um pacote enviado.

Para visualizar os documentos gerados de um pacote,
navegue até sua página e abra o link **API reference**
na caixa de informações no lado direito da página.
Por exemplo, você pode encontrar os documentos de API para `package:http`
em [pub.dev/documentation/http]({{site.pub-api}}/http).

### Visualizar documentos das bibliotecas principais {:#view-sdk}

`dart doc` também é usado para gerar a documentação de referência da API para
as bibliotecas principais do Dart.

Para visualizar os documentos de referência do Dart SDK, visite o link api.dart.dev
que corresponde ao canal de lançamento do Dart com o qual você está desenvolvendo:

| Branch   | Documentos gerados                          |
|----------|---------------------------------------------|
| `stable` | [api.dart.dev/stable]({{site.dart-api}})    |
| `beta`   | [api.dart.dev/beta]({{site.dart-api}}/beta) |
| `dev`    | [api.dart.dev/dev]({{site.dart-api}}/dev)   |
| `main`   | [api.dart.dev/main]({{site.dart-api}}/main) |

{:.table .table-striped}

## Solução de problemas

Para identificar e resolver problemas comuns com documentos gerados com `dart doc`,
consulte a seguinte seção de referência.

### Barra de pesquisa falhou ao carregar {:#troubleshoot-search}

Se as barras de pesquisa da documentação gerada não estão funcionais ou
incluem texto semelhante a "Failed to initialize search",
um dos seguintes cenários é possível:

1. Você está acessando os documentos do seu próprio sistema de arquivos,
   mas eles não estão sendo servidos e carregados com um servidor HTTP.
   Para aprender como servir documentos de API locais,
   confira [como visualizar documentos gerados localmente](#view-local).
2. O arquivo `index.json` gerado por `dart doc` está ausente ou inacessível
   do diretório de documentação ou do seu servidor web hospedado.
   Tente regenerar os documentos e validar sua configuração de hospedagem.

### Barra lateral falhou ao carregar {:#troubleshoot-sidebar}

Se as barras laterais da documentação gerada estão ausentes ou
incluem texto semelhante a "Failed to load sidebar",
um dos seguintes cenários é possível:

1. Você está acessando os documentos do seu próprio sistema de arquivos,
   mas os documentos não estão sendo servidos e carregados com um servidor HTTP.
   Para aprender como servir documentos de API locais,
   confira [como visualizar documentos locais](#view-local).
2. O comportamento base-href dos documentos gerados está configurado.
   Esta opção de configuração está obsoleta e não deve mais ser usada.
   Tente remover a opção e usar o comportamento padrão do `dart doc`.
   Se o comportamento padrão quebrar links em seus documentos gerados,
   por favor [registre um problema][file an issue].

[file an issue]: {{site.repo.dart.org}}/dartdoc/issues

### Documentação de API ausente {:#troubleshoot-missing}

Se você não consegue encontrar ou acessar a documentação gerada
para uma API que você espera ter documentos,
um dos seguintes cenários é possível:

1. O pacote não expõe a API que você está procurando como uma API pública.
   `dart doc` gera documentação apenas para bibliotecas e membros públicos
   que são expostos para outros pacotes importarem e usarem.
   Para saber mais sobre configurar as bibliotecas públicas de um pacote,
   confira o guia de layout de pacote sobre [bibliotecas públicas][public libraries].
2. A URL que você está tentando acessar tem capitalização incorreta.
   Por padrão, `dart doc` gera nomes de arquivo que diferenciam maiúsculas de minúsculas,
   correspondem às suas declarações de origem correspondentes e têm uma extensão `.html`.
   Tente verificar se a URL corresponde a essas expectativas.

[public libraries]: /tools/pub/package-layout#public-libraries

### Texto onde deveriam estar ícones {:#troubleshoot-icons}

Se você vê texto em vez de ícones como os botões de menu e tema,
seu navegador provavelmente não conseguiu carregar a fonte Material Symbols.
Algumas opções para resolver isso incluem:

1. Tente usar um proxy que habilite acesso aos servidores Google Fonts.
2. Atualize as páginas geradas para usar uma versão local da fonte.
