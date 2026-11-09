---
ia-translate: true
title: dart doc
description: >-
   Aprenda a gerar documentação de referência em HTML para bibliotecas Dart públicas.
---

O comando `dart doc` gera documentação de referência em HTML
para código-fonte Dart.

## Escrever documentação {:#write}

Para adicionar texto de referência e exemplos à documentação gerada,
use [comentários de documentação][documentation comments] com formatação [Markdown][].
Para orientação sobre como escrever comentários de documentação,
consulte o guia [Effective Dart: Documentation][].

[documentation comments]: /language/comments#documentation-comments
[Markdown]: {{site.pub-pkg}}/markdown
[Effective Dart: Documentation]: /effective-dart/documentation

## Gerar documentos de API {:#generate}

:::note
Para gerar a documentação,
você precisa primeiro executar [`dart pub get`](/tools/pub/cmd/pub-get),
e seu pacote precisa passar pelo [`dart analyze`](/tools/dart-analyze)
sem erros.
:::

Para gerar a documentação do seu pacote,
execute `dart doc .` a partir do diretório raiz do pacote.
Por exemplo, gerar os documentos de API de um pacote `my_package`
pode ser parecido com o seguinte:

```console
$ cd my_package
$ dart pub get
$ dart doc .
Documenting my_package...
...
Success! Docs generated into /Users/me/projects/my_package/doc/api
```

Por padrão, `dart doc` coloca a documentação gerada
e os arquivos de suporte no diretório `doc/api`.
Para alterar o diretório de saída, especifique
um caminho com a flag `--output`:

```console
$ dart doc --output=api_docs .
```

Se houver algum problema na configuração do pacote ou nos comentários de documentação,
o `dart doc` os reporta como erros ou avisos.
Se você quiser apenas testar a existência de problemas sem salvar a documentação gerada,
adicione a flag `--dry-run`:

```console
$ dart doc --dry-run .
```

### Configure a geração {:#configure}

Para configurar como o `dart doc` gera a documentação, crie um
arquivo chamado `dartdoc_options.yaml` no diretório raiz do seu pacote.

Para saber mais sobre o formato do arquivo e as opções de configuração suportadas,
consulte [dart.dev/go/dartdoc-options-file][dartdoc-options].

{% comment %}
TODO: Document the long-term supported options here.
{% endcomment -%}

[dartdoc-options]: {{site.redirect.go}}/dartdoc-options-file

## Visualizar a documentação gerada {:#view}

Você pode visualizar a documentação gerada com `dart doc` de várias maneiras.

### Visualizar a documentação local {:#view-local}

Para visualizar os documentos de API que você gerou com `dart doc` ou baixou da internet,
você precisa carregá-los com um servidor HTTP.

Para servir os arquivos, use qualquer servidor HTTP.
Considere usar o [`package:dhttpd`][] do pub.dev.

Para servir a documentação gerada, execute o `package:dhttpd` diretamente do pub.dev
e especifique o caminho da documentação gerada.
O comando a seguir serve os documentos de API localizados em `doc/api`:

```console
$ dart run dhttpd@ --path doc/api
```

Para ler a documentação gerada no navegador,
abra o link que o `dhttpd` exibe, geralmente `http://localhost:8080`.

[`package:dhttpd`]: {{site.pub-pkg}}/dhttpd

### Visualizar a documentação hospedada {:#view-hosted}

Você também pode hospedar online os documentos de API gerados,
usando qualquer serviço de hospedagem que suporte conteúdo web estático.
Duas opções comuns são o [Firebase hosting][] e o [GitHub pages][].

[Firebase hosting]: https://firebase.google.com/docs/hosting
[GitHub pages]: https://pages.github.com/

### Visualizar a documentação de pacotes {:#view-pub}

O [site pub.dev]({{site.pub}}) gera e hospeda
a documentação das bibliotecas públicas de um pacote publicado.

Para visualizar a documentação gerada de um pacote,
acesse a página dele e abra o link **API reference**
na caixa de informações do lado direito da página.
Por exemplo, você pode encontrar os documentos de API do `package:http`
em [pub.dev/documentation/http]({{site.pub-api}}/http).

### Visualizar a documentação das bibliotecas principais {:#view-sdk}

O `dart doc` também é usado para gerar a documentação de referência da API das
bibliotecas principais do Dart.

Para visualizar a documentação de referência do Dart SDK, acesse o link do api.dart.dev
correspondente ao canal de lançamento do Dart que você está usando:

| Branch   | Documentos gerados                          |
|----------|---------------------------------------------|
| `stable` | [api.dart.dev/stable]({{site.dart-api}})    |
| `beta`   | [api.dart.dev/beta]({{site.dart-api}}/beta) |
| `dev`    | [api.dart.dev/dev]({{site.dart-api}}/dev)   |
| `main`   | [api.dart.dev/main]({{site.dart-api}}/main) |

{:.table .table-striped}

## Solução de problemas {:#troubleshoot}

Para identificar e resolver problemas comuns com a documentação gerada pelo `dart doc`,
consulte a seção de referência a seguir.

### A barra de pesquisa não carregou {:#troubleshoot-search}

Se as barras de pesquisa da documentação gerada não funcionarem ou
exibirem um texto semelhante a "Failed to initialize search",
é possível que ocorra um dos seguintes cenários:

1. Você está acessando a documentação a partir do seu sistema de arquivos,
   mas ela não está sendo servida e carregada por um servidor HTTP.
   Para aprender a servir a documentação de API localmente,
   consulte [como visualizar a documentação gerada localmente](#view-local).
2. O arquivo `index.json` gerado pelo `dart doc` está ausente ou inacessível
   no diretório da documentação ou no seu servidor web de hospedagem.
   Tente gerar a documentação novamente e validar a configuração da hospedagem.

### A barra lateral não carregou {:#troubleshoot-sidebar}

Se as barras laterais da documentação gerada estiverem ausentes ou
exibirem um texto semelhante a "Failed to load sidebar",
é possível que ocorra um dos seguintes cenários:

1. Você está acessando a documentação a partir do seu sistema de arquivos,
   mas ela não está sendo servida e carregada por um servidor HTTP.
   Para aprender a servir a documentação de API localmente,
   consulte [como visualizar a documentação local](#view-local).
2. O comportamento de base-href da documentação gerada está configurado.
   Essa opção de configuração está obsoleta e não deve mais ser usada.
   Tente remover a opção e usar o comportamento padrão do `dart doc`.
   Se o comportamento padrão quebrar os links da sua documentação gerada,
   por favor, [abra uma issue][file an issue].

[file an issue]: {{site.repo.dart.org}}/dartdoc/issues

### Documentação de API ausente {:#troubleshoot-missing}

Se você não conseguir encontrar ou acessar a documentação gerada
de uma API que deveria ter documentos,
é possível que ocorra um dos seguintes cenários:

1. O pacote não expõe a API que você procura como uma API pública.
   O `dart doc` gera documentação apenas para bibliotecas e membros públicos
   que são expostos para que outros pacotes possam importá-los e usá-los.
   Para saber mais sobre a configuração das bibliotecas públicas de um pacote,
   consulte o guia de layout de pacotes sobre [bibliotecas públicas][public libraries].
2. A URL que você está tentando acessar tem letras maiúsculas e minúsculas incorretas.
   Por padrão, o `dart doc` gera nomes de arquivo que diferenciam maiúsculas de minúsculas,
   correspondem às declarações de origem e têm a extensão `.html`.
   Verifique se a URL corresponde a essas regras.

[public libraries]: /tools/pub/package-layout#public-libraries

### Texto no lugar dos ícones {:#troubleshoot-icons}

Se você vir texto em vez de ícones, como os botões de menu e de tema,
é provável que o seu navegador não tenha conseguido carregar a fonte Material Symbols.
Algumas opções para resolver isso incluem:

1. Tentar usar um proxy que permita o acesso aos servidores do Google Fonts.
2. Atualizar as páginas geradas para usar uma versão local da fonte.
