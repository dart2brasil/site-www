---
ia-translate: true
title: dart doc
description: "Aprenda como gerar documentação de referência HTML para bibliotecas Dart públicas."
---

O comando `dart doc` gera documentação de referência HTML
para código-fonte Dart.

## Escreva a documentação {:#write}

Para adicionar texto de referência e exemplos à documentação gerada,
use [comentários de documentação][] com formatação [Markdown][].
Para obter orientação sobre como escrever comentários de documentação,
confira o guia [Effective Dart: Documentação][].

[comentários de documentação]: /language/comments#documentation-comments
[Markdown]: {{site.pub-pkg}}/markdown
[Effective Dart: Documentação]: /effective-dart/documentation

## Gerar documentação da API {:#generate}

:::note
Para gerar documentação,
você deve primeiro executar [`dart pub get`](/tools/pub/cmd/pub-get)
e seu pacote deve passar em [`dart analyze`](/tools/dart-analyze)
sem erros.
:::

Para gerar a documentação do seu pacote,
execute `dart doc .` no diretório raiz do pacote.
Por exemplo, gerar a documentação da API para um pacote `my_package`
pode ser semelhante a seguinte:

```console
$ cd my_package
$ dart pub get
$ dart doc .
Documentando my_package...
...
Sucesso! Documentos gerados em /Users/me/projects/my_package/doc/api
```

Por padrão, `dart doc` coloca a documentação gerada
e os arquivos de suporte no diretório `doc/api`.
Para alterar o diretório de saída, especifique
um caminho com a flag `--output`:

```console
$ dart doc --output=api_docs .
```

Se houver algum problema com a configuração do seu pacote ou comentários de documentação,
`dart doc` os exibirá como erros ou avisos.
Se você só quiser testar se há problemas sem salvar a documentação gerada,
adicione a flag `--dry-run`:

```console
$ dart doc --dry-run .
```

### Configurar a geração {:#configure}

Para configurar como o `dart doc` gera a documentação, crie um
arquivo chamado `dartdoc_options.yaml` no diretório raiz do seu pacote.

Para saber mais sobre o formato do arquivo e as opções de configuração suportadas,
confira [dartbrasil.dev/go/dartdoc-options-file][dartdoc-options].

{% comment %}
TODO: Documentar as opções suportadas a longo prazo aqui.
{% endcomment -%}

[dartdoc-options]: {{site.redirect.go}}/dartdoc-options-file

## Visualizar docs gerados {:#view}

Você pode visualizar os documentos gerados com `dart doc` de várias maneiras.

### Visualizar docs locais {:#view-local}

Para visualizar a documentação da API que você gerou com `dart doc` ou baixou online,
você deve carregá-los com um servidor HTTP.

Para servir os arquivos, use qualquer servidor HTTP.
Considere usar [`package:dhttpd`][] do pub.dev.

Para usar `package:dhttpd`, ative-o globalmente e execute-o
e especifique o caminho da sua documentação gerada.
Os comandos a seguir ativam o pacote,
e então o executa para servir a documentação da API localizada em `doc/api`:

```console
$ dart pub global activate dhttpd
$ dart pub global run dhttpd --path doc/api
```

Para então ler a documentação gerada no seu navegador,
abra o link que `dhttpd` exibe, geralmente `http://localhost:8080`.

[`package:dhttpd`]: {{site.pub-pkg}}/dhttpd

### Visualizar docs hospedados {:#view-hosted}

Você também pode hospedar sua documentação da API gerada online
usando qualquer serviço de hospedagem que suporte conteúdo web estático.
Duas opções comuns são [Firebase hosting][] e [GitHub pages][].

[Firebase hosting]: https://firebase.google.com/docs/hosting
[GitHub pages]: https://pages.github.com/

### Visualizar docs do pacote {:#view-pub}

O site [pub.dev]({{site.pub}}) gera e hospeda
documentação para as bibliotecas públicas de um pacote enviado.

Para visualizar a documentação gerada de um pacote,
navegue até a página dele e abra o link **API reference**
na caixa de informações no lado direito da página.
Por exemplo, você pode encontrar a documentação da API para `package:http`
em [pub.dev/documentation/http]({{site.pub-api}}/http).

### Visualizar docs da biblioteca core {:#view-sdk}

`dart doc` também é usado para gerar a documentação de referência da API para
as bibliotecas core (principais) do Dart.

Para visualizar a documentação de referência do Dart SDK, visite o link api.dartbrasil.dev
que corresponde ao canal de lançamento do Dart que você está desenvolvendo:

| Branch   | Documentos gerados                               |
|----------|-------------------------------------------------|
| `stable` | [api.dartbrasil.dev/stable]({{site.dart-api}})        |
| `beta`   | [api.dartbrasil.dev/beta]({{site.dart-api}}/beta)     |
| `dev`    | [api.dartbrasil.dev/dev]({{site.dart-api}}/dev)       |
| `main`   | [api.dartbrasil.dev/main]({{site.dart-api}}/main)     |

{:.table .table-striped}

## Solução de problemas {:#troubleshoot}

Para identificar e resolver problemas comuns com documentos gerados com `dart doc`,
consulte a seção de referência a seguir.

### Barra de pesquisa falhou ao carregar {:#troubleshoot-search}

Se as barras de pesquisa da documentação gerada não estiverem funcionando ou
incluírem texto semelhante a "Falha ao inicializar a pesquisa",
um dos seguintes cenários é possível:

1. Você está acessando os documentos do seu próprio sistema de arquivos,
   mas eles não estão sendo servidos e carregados com um servidor HTTP.
   Para aprender como servir documentos de API locais,
   confira [como visualizar documentos gerados localmente](#view-local).
2. O arquivo `index.json` gerado por `dart doc` está ausente ou inacessível
   do diretório de documentação ou do seu servidor web hospedado.
   Tente regenerar os documentos e validar sua configuração de hospedagem.

### Barra lateral falhou ao carregar {:#troubleshoot-sidebar}

Se as barras laterais da documentação gerada estiverem faltando ou
incluírem texto semelhante a "Falha ao carregar a barra lateral",
um dos seguintes cenários é possível:

1. Você está acessando os documentos do seu próprio sistema de arquivos,
   mas os documentos não estão sendo servidos e carregados com um servidor HTTP.
   Para aprender como servir documentos de API locais,
   confira [como visualizar documentos locais](#view-local).
2. O comportamento base-href dos documentos gerados está configurado.
   Essa opção de configuração está obsoleta e não deve mais ser usada.
   Tente remover a opção e usar o comportamento padrão de `dart doc`.
   Se o comportamento padrão quebrar os links em seus documentos gerados,
   por favor, [registre um problema][].

[registre um problema]: {{site.repo.dart.org}}/dartdoc/issues

### Documentação da API ausente {:#troubleshoot-missing}

Se você não conseguir encontrar ou acessar a documentação gerada
para uma API que você espera ter documentação,
um dos seguintes cenários é possível:

1. O pacote não expõe a API que você está procurando como uma API pública.
   `dart doc` só gera documentação para bibliotecas e membros públicos
   que são expostos para outros pacotes importarem e usarem.
   Para saber mais sobre como configurar as bibliotecas públicas de um pacote,
   confira o guia de layout do pacote em [bibliotecas públicas][].
2. A URL que você está tentando acessar tem capitalização incorreta.
   Por padrão, `dart doc` gera nomes de arquivos que diferenciam maiúsculas de minúsculas,
   correspondem às suas declarações de origem correspondentes e têm uma extensão `.html`.
   Tente verificar se a URL corresponde a essas expectativas.

[bibliotecas públicas]: /tools/pub/package-layout#public-libraries

### Texto onde deveriam estar os ícones {:#troubleshoot-icons}

Se você vir texto em vez de ícones, como os botões de menu e tema,
é provável que seu navegador não tenha conseguido carregar a fonte Material Symbols.
Algumas opções para resolver isso incluem:

1. Tente usar um proxy que permita o acesso aos servidores do Google Fonts.
2. Atualize as páginas geradas para usar uma versão local da fonte.
