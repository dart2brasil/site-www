---
ia-translate: true
title: "AngularDart, Flutter e a web: atualização de primavera"
description: "Ajustando nosso investimento nos frameworks web open source do Dart"
publishDate: 2021-05-12
author: timsneath
image: images/1TnLjhbuMnphc4ZlsuSdtog.webp
category: other
layout: blog
---


Dois meses atrás, entregamos nossa [primeira versão estável do suporte à web]({{site.flutter-blog}}/flutter-web-support-hits-the-stable-milestone) no Flutter. Foi um marco importante para o desenvolvimento client como um todo, combinando o framework de UI consolidado do Flutter, o toolchain JavaScript robusto, de nível industrial, do Dart e o poder da plataforma web para oferecer consistência entre dispositivos móveis e navegadores.

Desde esse lançamento, temos ficado empolgados ao ver desenvolvedores começando a usar o Flutter na web. Mesmo nessa fase inicial, mais de 10% dos comandos `flutter build` têm a web como alvo, o que mostra que apps web já estão sendo publicados com Flutter. Dentro do Google, vários times estão começando a depender do suporte à web do Flutter. E nós mesmos o usamos bastante no desenvolvimento do Flutter, tanto no [DartPad](https://dartpad.dev/e0a2e942e85fde2cd39b2741ff0c49e5?null_safety=true) quanto no [DevTools](https://flutter.dev/docs/development/tools/devtools/overview), nossa suíte de ferramentas de performance e depuração.

Quando começamos a adicionar suporte à web no Flutter, há alguns anos, tínhamos esperança de que daria bons resultados, mas ainda parecia uma aposta ousada. Embora ainda haja muito trabalho pela frente, estamos confiantes de que o suporte à web do Flutter tem potencial para ocupar um nicho importante com uma solução de alta qualidade. Por isso, estamos ajustando nossos investimentos nas ferramentas web open source do Dart para focar no Flutter.

Com essa mudança de foco, também estamos reduzindo nosso trabalho externo no AngularDart, um framework web separado que evoluiu a partir do projeto Angular original. Seis meses atrás, [anunciamos um roadmap para o AngularDart](https://groups.google.com/a/dartlang.org/g/announce/c/Kz84KNBcf3U) que incluía publicar uma atualização estável de longo prazo ([AngularDart 6](https://pub.dev/packages/angular/changelog)) e oferecer suporte a null safety, mas que priorizava o trabalho de engenharia do AngularDart para grandes clientes internos, incluindo o [Google Ads](https://ads.google.com/) e o [Google Play Console](https://play.google.com/console). Embora o framework AngularDart em si seja relativamente fácil de abrir como open source, os sistemas de build e release do Google são [extremamente especializados](https://sre.google/sre-book/release-engineering/#continuous-build-and-deployment-Yms8u8), o que gera uma divergência significativa e torna nada trivial sincronizar as versões internas e externas.

Focar na maioria dos usuários do AngularDart nos ajuda a aproveitar ao máximo nossos talentosos recursos de engenharia, e esperamos que todos saiam ganhando com isso. Para projetos como o Ads e o Play Console, conseguimos atender às necessidades deles de forma mais direta, sem nos preocupar com implicações externas; para os usuários externos, podemos colocar toda a nossa energia em entregar um produto Flutter de alta qualidade que funcione em cenários web, desktop, mobile e embarcados.
> # Podemos colocar toda a nossa energia em entregar um produto Flutter de alta qualidade que funcione em cenários web, desktop, mobile e embarcados.

Nos últimos meses, temos conversado com os maiores usuários externos do AngularDart para ajudá-los com seus próprios roadmaps. Para alguns, o suporte à web do Flutter é a escolha perfeita; outros estão satisfeitos com a estabilidade e a maturidade do AngularDart como ele está; e outros ainda estão aproveitando a oportunidade para migrar para o [Angular](https://angular.io/), o popular framework web do Google baseado em TypeScript.

O próprio Angular continua crescendo rapidamente. No último ano, [os downloads semanais cresceram mais de 60%](https://www.npmjs.com/package/@angular/core) e quase [dois milhões de repositórios públicos no GitHub dependem dele](https://github.com/angular/angular/network/dependents?package_id=UGFja2FnZS00NTE2NDYyMzQ%3D). A sintaxe dele vai ser familiar para quem usa o AngularDart hoje, e ele é uma escolha lógica para desenvolvedores em busca de um framework web moderno.

Para desenvolvedores que querem usar Dart, achamos que o suporte à web do Flutter será uma escolha empolgante. Como exemplo inicial, a [PropOps](https://propops.com/en/), uma startup de tecnologia do setor imobiliário, teve grande sucesso ao construir um app corporativo com Flutter, como mostram as capturas de tela abaixo:

<DashImage src="images/1TnLjhbuMnphc4ZlsuSdtog.webp" alt="Capturas de tela da PropOps, uma ferramenta de gestão de imóveis na nuvem construída com o suporte à web do Flutter." caption="PropOps: uma ferramenta de gestão de imóveis na nuvem, construída com o suporte à web do Flutter." />


Nas próximas semanas, vamos entregar uma versão externa estável do AngularDart com null safety; a partir daí, ele entra em modo de manutenção. Se um consórcio comprometido ou um grupo da comunidade quiser assumir a liderança do projeto e continuar evoluindo-o, temos interesse em conversar.

Estamos avançando a todo vapor no suporte à web do Flutter e no próprio Angular: fique de olho para mais novidades sobre isso no [Google I/O](https://events.google.com/io/) da semana que vem!
