---
ia-translate: true
title: IntelliJ & Android Studio
description: Use Dart com uma variedade de IDEs e editores da JetBrains.
---

O [plugin Dart][Dart plugin] adiciona suporte a Dart
para IDEs baseados na plataforma IntelliJ desenvolvidos pela JetBrains.
Essas IDEs fornecem recursos exclusivos para tecnologias de desenvolvimento
específicas. As IDEs recomendadas para desenvolvimento Dart e Flutter incluem:

- [IntelliJ IDEA][IntelliJ IDEA] que se especializa em desenvolvimento de linguagem baseado em JVM.
- [WebStorm][WebStorm] que se especializa em desenvolvimento de aplicativos web.
- [Android Studio][Android Studio] que se especializa em desenvolvimento para Android e Flutter.

Qualquer que seja a IDE da JetBrains que você escolher para o desenvolvimento
Dart, esta página tem recursos para ajudá-lo a começar rapidamente
e encontrar mais informações quando precisar.

[IntelliJ IDEA]: https://www.jetbrains.com/idea/
[WebStorm]: https://www.jetbrains.com/webstorm/
[Android Studio]: {{site.android-dev}}/studio

## Começando {:#getting-started}

Se você ainda não tem a IDE e o SDK do Dart, obtenha-os.
Em seguida, instale o plugin Dart e diga a ele onde encontrar o SDK do Dart.


### Baixando a IDE {:#downloading-the-ide}

Instale uma IDE da JetBrains se você ainda não tiver uma. Escolha uma:

* [IntelliJ IDEA][IDEA-Install]{:target="_blank" rel="noopener"}
* [IntelliJ IDEA EAP][IDEA-EAP-Install]{:target="_blank" rel="noopener"}
  (para acesso antecipado aos recursos mais recentes da linguagem Dart e à funcionalidade do IntelliJ)
* [WebStorm][WS-Install]{:target="_blank" rel="noopener"}
* [Android Studio][AS-Install]{:target="_blank" rel="noopener"}
* [Outro produto JetBrains][Other]{:target="_blank" rel="noopener"}

[IDEA-Install]: https://www.jetbrains.com/idea/download/
[IDEA-EAP-Install]: https://www.jetbrains.com/idea/nextversion/
[WS-Install]: https://www.jetbrains.com/webstorm/download/
[AS-Install]: {{site.android-dev}}/studio/install
[Other]: https://www.jetbrains.com/products.html

:::note
A Community Edition do IntelliJ IDEA tem funcionalidade limitada.
Por exemplo, ela não oferece suporte direto à depuração de aplicativos da web.
Ela também tem muito pouco suporte para JavaScript, HTML, CSS e YAML.
:::


### Baixando o SDK do Dart {:#downloading-the-dart-sdk}

Se você ainda não tem o SDK do Dart,
instale-o.
Você pode obtê-lo sozinho ou baixando o SDK do Flutter,
que inclui o SDK do Dart completo.

Escolha um:

* [Baixe o SDK do Dart](/get-dart)
* [Baixe o SDK do Flutter]({{site.flutter-docs}}/get-started/install)


### Configurando o suporte a Dart {:#configuring-dart-support}

Aqui está uma maneira de configurar o suporte ao Dart:

<ol>
<li>
  <p>
    Inicie a IDE e instale o plugin <b>Dart</b>.
  </p>

  <ol type="a">
    <li>Na tela de boas-vindas, escolha <b>Plugins</b>.</li>
    <li>Pesquise por <b>Dart</b>.</li>
    <li>Depois de instalar o plugin Dart, reinicie a IDE.</li>
  </ol>
</li>
<br>

<li>
  <p>
    Crie um novo projeto Dart:
  </p>

  <ol type="a">
    <li>Na tela de boas-vindas, clique em <b>Novo Projeto</b>.</li>
    <li>Na próxima caixa de diálogo, clique em <b>Dart</b>.</li>
  </ol>
</li>
<br>

<li>
  <p>
    Se você não vir um valor para o caminho do <b>SDK do Dart</b>,
    insira ou selecione-o.
  </p>

  <p>
    Por exemplo, o caminho do SDK pode ser
    <code><em>&lt;diretório de instalação do dart></em>/dart/dart-sdk</code>.
  </p>

  :::note
  O **SDK do Dart** especifica o diretório que
  contém os diretórios `bin` e `lib` do SDK;
  o diretório `bin` contém ferramentas como `dart` e `dartaotruntime`.
  A IDE garante que o caminho seja válido.
  :::
</li>

<li>
  <p>
    Escolha um modelo inicial.
  </p>

  <ol type="a">
    <li>Para ativar os modelos iniciais, clique em <b>Gerar conteúdo de amostra</b>.</li>
    <li>Escolha o modelo desejado.</li>
  </ol>

  :::note
  Os modelos fornecidos são fornecidos e criados
  por [`dart create`](/tools/dart-create).
  :::
</li>

<li>
  <p>Clique em <b>Próximo</b> e continue a configuração do projeto.</p>
</li>
</ol>

Uma alternativa à Etapa 2 é abrir um projeto Dart existente e,
em seguida, abrir seu arquivo `pubspec.yaml` ou qualquer um de seus arquivos Dart.


## Relatando problemas {:#reporting-issues}

Por favor, relate problemas e feedback através do oficial
[rastreador de problemas da JetBrains para Dart.][Rastreador de problemas da JetBrains para Dart.]

Inclua detalhes do comportamento esperado, o comportamento real
e capturas de tela, se apropriado.

[Rastreador de problemas da JetBrains para Dart.]: https://youtrack.jetbrains.com/issues?q=Subsystem:%20%7BLang.%20Dart%7D%20

## Mais informações {:#more-information}

Consulte o site da JetBrains para obter mais informações.

* [IntelliJ IDEA](https://www.jetbrains.com/idea/)
  * [Ajuda do Dart WebStorm](https://www.jetbrains.com/help/webstorm/dart.html)
  * [Recursos](https://www.jetbrains.com/idea/features/)
  * [Início rápido](https://www.jetbrains.com/help/idea/getting-started.html)
* [Plugin Dart da JetBrains][Dart plugin]

[Dart plugin]: https://plugins.jetbrains.com/plugin/6351-dart/