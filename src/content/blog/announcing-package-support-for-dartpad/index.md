---
ia-translate: true
title: "Anunciando o suporte a pacotes no DartPad"
description: "Crie trechos de código robustos com pacotes populares no DartPad"
publishDate: 2021-11-15
author: zoeyfan
image: images/05iMRgkKlQGK6fJx3.webp
category: announcements
layout: blog
---


Hoje estamos animados em anunciar que o suporte a pacotes já está disponível no [DartPad](https://github.com/dart-lang/dart-pad)! O DartPad é o playground web de código aberto que executa apps Dart e Flutter diretamente no seu navegador. Ele permite executar rapidamente código Dart para testar uma ideia ou programar um conceito técnico sem precisar instalar o SDK do Flutter nem qualquer ferramenta no seu sistema local.

Desde o lançamento do DartPad, um dos [pedidos mais populares](https://github.com/dart-lang/dart-pad/issues/901) tem sido adicionar suporte à importação de pacotes, como [Google Fonts](https://pub.dev/packages/google_fonts) ou [Firebase Authentication](https://pub.dev/packages/firebase_auth), diretamente no editor do DartPad. Nesta primeira fase de lançamento, você pode importar de um conjunto de pacotes populares.

Para ajudar você a começar, criamos vários novos exemplos que podem ser encontrados no menu **Samples** do DartPad.

## Exemplo com Google Fonts {:#google-fonts-example}

Comece a usar um pacote adicionando uma instrução de import para ele no topo do editor de código. Por exemplo, para usar o pacote Google Fonts, adicione isto:

`import 'package:google_fonts/google_fonts.dart';`

O DartPad cuida dos detalhes do pubspec para você, então tudo o que você precisa é da instrução de import. Você pode usar as sugestões de autocompletar para trocar de fonte e depois executar o app novamente, assim como faria em uma IDE.

<DashImage src="images/05iMRgkKlQGK6fJx3.webp" alt="Exemplo no DartPad usando o pacote google_fonts." />


## Como funciona o suporte a pacotes {:#how-package-support-works}

Aqui está uma visão geral rápida de como o suporte a pacotes funciona no DartPad. O servidor do DartPad pega o conjunto de pacotes suportados e usa `**flutter pub get**` para buscar a versão compatível mais recente de cada pacote. Depois, o servidor usa essas versões dos pacotes durante a análise e a compilação do seu script do DartPad.

Esta versão também oferece suporte aos pacotes Firebase mais populares, para que você possa acessar um conjunto de serviços de backend sem sair do DartPad. Todos os SDKs JavaScript necessários do Firebase são carregados no painel de saída antes de executar o app compilado.

Aqui está um [app de chat simples](https://dartpad.dev/?id=d57c6c898dabb8c6fb41018588b8cf73&null_safety=true) que usa Firebase:

<DashImage src="images/05QSzuPZeeo3tb0R1.webp" alt="App de chat básico feito com Firebase no DartPad." />


Este app de chat multiusuário é implementado apenas com código Dart do lado do cliente, executado (e escrito) no navegador, e usa o banco de dados Firestore para compartilhar mensagens entre os usuários. Embora pareça perigoso abrir o seu banco de dados diretamente para os usuários, na prática ele é protegido, pois só permite mensagens de chat que usem um conjunto muito específico de palavras. Leia os comentários [no código](https://gist.github.com/flutterdevrelgists/d57c6c898dabb8c6fb41018588b8cf73) para saber mais sobre como ele funciona.

Para expandir o app de chat, você poderia implementar login para identificar quem disse o quê, adicionando o Firebase Authentication. Planejamos adicionar muitos outros recursos do Firebase para ampliar o que você pode fazer com o Firebase no DartPad.

## Pacotes suportados {:#supported-packages}

Esta primeira fase do lançamento oferece suporte a um conjunto definido de pacotes populares. Para ver quais pacotes estão disponíveis (e em qual versão), clique no ícone de informações no canto inferior direito da tela.

<DashImage src="images/0GiZCsPVISutlBMSG.webp" alt="Captura de tela mostrando o ícone de informações no DartPad que lista os pacotes disponíveis." />


## Experimente! {:#give-it-a-try}

Experimente o suporte a pacotes do DartPad hoje mesmo em [dartpad.dev](https://dartpad.dev) e compartilhe qualquer [feedback](https://github.com/dart-lang/dart-pad/issues) com a nossa equipe. Vamos continuar expandindo a lista de pacotes suportados ao longo do tempo. Se você tiver alguma preferência sobre quais pacotes gostaria de ver adicionados, [pesquise a issue](https://github.com/dart-lang/dart-pad/issues) que contém o nome do pacote desejado e dê a ela uma reação de "joinha" 👍. Se não houver uma issue para o pacote que você quer, por favor [crie uma issue](https://github.com/dart-lang/dart-pad/issues/new?template=everything-else.md) e coloque o nome do pacote no título.

Esperamos que o suporte a pacotes no DartPad ajude você a criar e apresentar seus designs, ideias, pequenos experimentos e muito mais em Flutter. Mal podemos esperar para ver o que você vai construir a seguir!
