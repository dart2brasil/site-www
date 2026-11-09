---
ia-translate: true
title: "Preparando-se para o Dart 2 e deixando seus pacotes com boa aparência no site do Pub!"
description: "Temos uma nova versão do Pub, o repositório de pacotes do Dart! Desta vez, focamos em preparar o lançamento estável do Dart 2."
publishDate: 2018-07-20
author: mit-mit
image: images/0Fq4FHYc9N5aHmYBK.webp
category: other
layout: blog
---


<DashImage src="images/1zpVgP0W04QFmqqaJO9fzhg.webp" alt="O logo do Dart ao lado de 'Dart Packages'." />


## Migrando seus pacotes para o Dart 2 {:#migrating-your-packages-to-dart-2}

Esperamos que a versão Dart 2 se torne estável em breve! Por isso, é fundamental que você [migre seu código](https://www.dartlang.org/dart-2#migration) — especialmente os pacotes que você publicou — para ser compatível com o Dart 2. Há três aspectos principais nisso:

* Garanta que seu código passe na análise do Dart 2 ([detalhes](https://www.dartlang.org/dart-2#general-process)). Recomendamos também que você preste atenção às dicas, por exemplo, para se preparar para depreciações.

* Execute os testes para garantir que seu código passe nas verificações de tempo de execução do Dart 2 ([detalhes](https://www.dartlang.org/guides/language/sound-problems#runtime-errors)).

* Atualize o limite superior da restrição de SDK dos seus pacotes para `&lt;3.0.0` ([detalhes](https://www.dartlang.org/dart-2#upper-constraints-on-the-sdk-version)).

Recomendamos fortemente que todos os autores de pacotes façam esse trabalho, e nós mesmos vamos nos empenhar bastante nos pacotes que mantemos nos próximos dias.

## Interface de análise aprimorada no site do Pub {:#improved-analysis-ui-on-the-pub-site}

Para ajudar nessa migração, atualizamos a aba de análise do site do Pub para tornar os resultados da análise de código mais fáceis de ler. Primeiro, no topo da página de análise, adicionamos barras de progresso que permitem ver rapidamente o status do pacote:

<DashImage src="images/0LatYAFujtrM2yebc.webp" alt="Pontuações do pacote no site do Pub representadas por barras de progresso." caption="Pontuações do pacote exibidas no site do Pub" />


Abaixo das barras de progresso estão os resultados detalhados da análise, agrupados por gravidade: erros (ícone vermelho), avisos (ícone amarelo) e problemas sugeridos (ícone azul), como mostra a captura de tela a seguir:

<DashImage src="images/0Fq4FHYc9N5aHmYBK.webp" alt="Problemas de análise no site do Pub agrupados por gravidade." caption="Problemas de análise exibidos no site do Pub" />


## Pontuações de análise atualizadas {:#updated-analysis-scores}

Também fizemos alguns ajustes na pontuação de análise. Agora reduzimos a pontuação de um pacote se qualquer uma das condições a seguir for verdadeira:

* O pacote não passa na análise do Dart 2.

* O limite superior da restrição de SDK não é pelo menos `&lt;3.0.0`.

* A geração da referência da API ([dartdoc](https://www.dartlang.org/guides/language/effective-dart/documentation)) falha.

Para a próxima versão do site do Pub, esperamos trabalhar em um refinamento adicional das pontuações e acrescentar documentação sobre como elas são calculadas.

## Pesquisando na superfície da API de um pacote {:#searching-the-api-surface-of-a-package}

A busca é — não é surpresa — o recurso mais popular do site do Pub. Fizemos diversas melhorias nessa área nos últimos trimestres, com foco em adicionar filtros por plataforma e um ranqueamento melhor. A nova versão estende a busca com suporte a pesquisa na superfície da API de um pacote. Além da indexação atual do conteúdo da descrição e do `README.md` do pacote, a busca agora abrange todos os membros públicos da API do pacote, além da documentação da API desses membros! Isso é ótimo quando você quer localizar algo que não é mencionado nas descrições e nos arquivos `README.md`.

Por exemplo, suponha que você esteja procurando um pacote que possa formatar strings no formato de moeda [ISO 4217](https://en.wikipedia.org/wiki/ISO_4217). Uma busca na descrição e nos arquivos README.md retorna [um único resultado](https://pub.dartlang.org/packages?q=4217&api=0), mas uma busca que inclui a documentação da API retorna [vários resultados](https://pub.dartlang.org/packages?q=4217):

```
10 results for 4217

intl

Contains code to deal with internationalized/localized messages, date and number formatting and parsing, bi-directional text, and other internationalization issues.

v 0.15.2 • Updated: Oct 19, 2017 FLUTTER WEB OTHER

API results:

intl/NumberFormat-class.html

flutter_billing

A flutter plugin to communicate with billing on iOS and Android.

v 0.1.2 • Updated: Feb 10, 2018 FLUTTER

API results:

flutter_billing/BillingProduct-class.html
```


## Resumindo… {:#in-summary}

O lançamento do canal estável do Dart 2 está acontecendo muito em breve, e fizemos diversas melhorias no site do Pub relacionadas ao Dart 2, ao ranqueamento e à busca.

Se você publicou pacotes, *agora* é a hora de atualizá-los para o Dart 2:

1. Garanta que seus pacotes passem na análise do Dart 2.

1. Atualize o limite superior da restrição de SDK para `<3.0.0` no seu `pubspec.yaml`.

1. Publique novamente seus pacotes atualizados.

Depois, acesse a página de análise do seu pacote em [pub.dartlang.org](https://pub.dartlang.org/) e veja o que mais você pode fazer para melhorar seu ranqueamento!
