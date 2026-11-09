---
ia-translate: true
title: "Preparando o ecossistema Dart e Flutter para o null safety"
description: "O null safety agora é estável na API. Publique seus pacotes estáveis agora!"
publishDate: 2021-02-16
author: kevmoo
image: images/1VTEwPWrLp7D0teLcI-HALw.webp
category: announcements
layout: blog
---


<DashImage src="images/1VTEwPWrLp7D0teLcI-HALw.webp" alt="Pub.dev args package card with a Null safety badge and text telling Dart package authors to migrate to null safety." />


Hoje anunciamos uma nova versão beta do Dart. Esse beta representa um novo nível de estabilidade e confiança no novo sistema de tipos [sound null safety](/blog/why-nullable-types), no qual trabalhamos por mais de um ano. O beta atualizado do Dart (2.12.0–259.9.beta) está disponível em [dart.dev](https://dart.dev/get-dart) e também está incluído no [canal beta do Flutter](https://flutter.dev/docs/get-started/install). Não esperamos mais mudanças incompatíveis até o lançamento estável desse recurso.

Se você é um desenvolvedor de pacotes, convidamos você a começar a publicar versões estáveis e null-safe dos seus pacotes, para oferecer a melhor experiência aos usuários quando lançarmos a versão estável do Dart com null safety. Nós mesmos começamos esse processo, publicando versões estáveis de pacotes null-safe como [args](https://pub.dev/packages/args/versions/2.0.0), [yaml](https://pub.dev/packages/yaml/versions/3.0.0) e [grpc](https://pub.dev/packages/grpc/versions/3.0.0). Se todas as suas dependências forem null-safe e publicadas em versões estáveis (por exemplo, 1.0.0 em vez de 1.0.0-nullsafety.123), agora é a hora de fazer o mesmo!

Também adicionamos ao pub.dev um recurso que marca versões de pacotes como [versões de pré-lançamento](https://dart.dev/tools/pub/publishing#publishing-previews) quando o SDK do Dart do qual elas dependem ainda não foi lançado como estável. Essas versões serão promovidas automaticamente a versões estáveis regulares assim que um novo SDK estável do Dart for lançado.

<DashImage src="images/0GcE_GbN_IrB_dLtq.webp" alt="Pub.dev args package page with a 1.6.0 stable version and a 2.0.0 preview version." caption="*pub.dev showing the args package with a 1.6.0 stable version and a 2.0.0 preview version*" />


O [guia de migração para null safety](https://dart.dev/null-safety/migration-guide) traz as informações mais recentes sobre como migrar seus pacotes. Preste muita atenção à restrição de versão do SDK do Dart e às versões das suas dependências no pubspec, bem como à versão do SDK que você usa nos testes de integração contínua (CI).

A versão estável e null-safe do Dart está chegando em breve! Obrigado por nos ajudar a torná-la realidade.
