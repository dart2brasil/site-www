---
ia-translate: true
title: "Parceria com o GitHub para segurança da cadeia de suprimentos de pacotes Dart"
description: "A partir de hoje, o GitHub oferece suporte ao Dart no seu Advisory Database, no grafo de dependências e no Dependabot. Isso significa que o GitHub agora oferece suporte completo à segurança da cadeia de suprimentos para apps Dart e Flutter…"
publishDate: 2022-10-06
author: mit-mit
image: images/1MdOSko9W_PJA0KwuQ_mu6w.webp
category: announcements
layout: blog
---


A partir de hoje, o GitHub oferece suporte ao Dart no seu [Advisory Database](https://github.com/advisories), no [grafo de dependências](https://docs.github.com/en/code-security/supply-chain-security/understanding-your-software-supply-chain/about-the-dependency-graph) e no [Dependabot](https://docs.github.com/en/code-security/dependabot/dependabot-alerts/about-dependabot-alerts). Isso significa que o GitHub agora oferece suporte completo à segurança da cadeia de suprimentos para apps Dart e Flutter.

Para conhecer essas novas capacidades, confira o [post do blog do GitHub](https://github.blog/2022-10-06-githubs-supply-chain-security-features-now-support-dart). Para entender o que isso significa para você como desenvolvedor Dart, continue lendo.
> “Com o Dart agora em nosso ecossistema de segurança da cadeia de suprimentos, o GitHub amplia seu suporte a um segmento que cresce rapidamente na comunidade open source”, *disse Courtney Claessens, Senior Product Manager do GitHub.* “E, ao antecipar a segurança, ajudamos não só os desenvolvedores, mas também os milhões de usuários que dependem de apps desenvolvidos em Dart.”

## Entendendo problemas de segurança em pacotes {:#learning-about-package-security-issues}

Imagine que você está construindo um novo e fantástico app Flutter. Você usa muitos pacotes muito bons no seu `pubspec` (como [este exemplo](https://github.com/gskinnerTeam/flutter-wonderous-app/blob/master/pubspec.yaml)) e publica seu app em várias lojas. O que aconteceria se um desses pacotes tivesse uma atualização importante para corrigir uma vulnerabilidade de segurança? Como você ficaria sabendo disso? Não ficaria, a menos que verificasse manualmente o `CHANGELOG` de cada um dos dezenas de pacotes regularmente. Esse é um desafio real.

É aqui que entra o Dependabot. Se você gerencia o código-fonte em um repositório do GitHub, o grafo de dependências e o Dependabot monitoram as dependências do seu pubspec e avisam se você está sem uma atualização. O Dependabot envia um pull request para atualizar o `pubspec.yaml` para a versão mais recente do pacote em seu nome. Tudo isso acontece graças a melhorias específicas para Dart no GitHub.

<DashImage src="images/1MdOSko9W_PJA0KwuQ_mu6w.webp" alt="Dependabot pull request to update a Dart package dependency." caption="Dependabot sending a PR to bump (update) a package dependency to a more recent version." />


<DashImage src="images/1AVm9C0qX5t-FhYp8lJzU4Q.webp" alt="GitHub dependency graph listing dependencies for a Dart package." caption="Dependency Graph showing the set of dependencies for a Dart package." />


## Um banco de advisories para pacotes Dart {:#an-advisory-database-for-dart-packages}

Esse cenário depende de um banco de dados aberto e de alta qualidade com advisories de segurança que listam vulnerabilidades conhecidas em pacotes Dart. Para esse recurso, fizemos parceria com o GitHub para adicionar suporte ao Dart no popular [GitHub Advisory Database](https://github.com/advisories). Esse banco já contém milhares de advisories para outros ecossistemas, como npm, NuGet e Maven.

A partir de hoje, você pode selecionar o ecossistema **Pub** ao criar advisories para pacotes Dart publicados.

<DashImage src="images/1oPBNmrTaMOB_etyNOp9JJA.webp" alt="GitHub draft security advisory form with the ecosystem dropdown open and Pub selected." caption="Creating a new security advisory for a Dart package published on pub.dev" />


Se você publica pacotes no [pub.dev](https://pub.dev/), recomendamos duas novas boas práticas.

1. Use o recurso de [security advisory](https://docs.github.com/en/code-security/repository-security-advisories/creating-a-repository-security-advisory) do GitHub para criar novos advisories no seu repositório. O GitHub incorpora esses advisories ao banco central do GitHub Advisory Database.

1. Configure sua [política de segurança](https://docs.github.com/en/code-security/getting-started/adding-a-security-policy-to-your-repository), incluindo como os usuários podem reportar vulnerabilidades.

## Proteja seus repositórios Dart hoje {:#secure-your-dart-repositories-today}

Os novos recursos de segurança já estão disponíveis. Se o seu código-fonte estiver em um repositório público, o Dependabot já começou a monitorar problemas de segurança. Se o seu código estiver em um repositório privado do GitHub, você precisa de um pouco mais de [configuração](https://github.blog/2022-10-06-githubs-supply-chain-security-features-now-support-dart) para ativar esse recurso.
