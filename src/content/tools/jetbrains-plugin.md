---
title: IntelliJ & Android Studio
description: Use Dart with a variety of IDEs and editors from JetBrains.
ia-translate: true
---

O [plugin Dart][Dart plugin] adiciona suporte a Dart
para IDEs baseadas na plataforma IntelliJ desenvolvidas pela JetBrains.
Essas IDEs fornecem recursos únicos para tecnologias de desenvolvimento específicas.
As IDEs recomendadas para desenvolvimento Dart e Flutter incluem:

- [IntelliJ IDEA][] que se especializa em desenvolvimento de linguagens baseadas em JVM.
- [WebStorm][] que se especializa em desenvolvimento de aplicativos web.
- [Android Studio][] que se especializa em desenvolvimento Android e Flutter.

Qualquer que seja a IDE JetBrains que você escolher para desenvolvimento Dart,
esta página tem recursos para ajudá-lo a começar rapidamente
e encontrar mais informações quando precisar.

[IntelliJ IDEA]: https://www.jetbrains.com/idea/
[WebStorm]: https://www.jetbrains.com/webstorm/
[Android Studio]: {{site.android-dev}}/studio

## Começando

Se você ainda não tem a IDE e o Dart SDK, obtenha-os.
Em seguida, instale o plugin Dart e informe onde encontrar o Dart SDK.


### Baixando a IDE

Instale uma IDE JetBrains se você ainda não tiver uma. Escolha uma:

* [IntelliJ IDEA][IDEA-Install]{:target="_blank" rel="noopener"}
* [IntelliJ IDEA EAP][IDEA-EAP-Install]{:target="_blank" rel="noopener"}
  (para acesso antecipado aos recursos mais recentes da linguagem Dart e funcionalidade IntelliJ)
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
Por exemplo, ela não oferece suporte direto para depuração de aplicativos web.
Ela também tem muito pouco suporte para JavaScript, HTML, CSS e YAML.
:::


### Baixando o Dart SDK

Se você ainda não tem o Dart SDK,
instale-o.
Você pode obtê-lo sozinho ou baixando o Flutter SDK,
que inclui o Dart SDK completo.

Escolha um:

* [Baixar o Dart SDK](/get-dart)
* [Baixar o Flutter SDK]({{site.flutter-docs}}/get-started/install)


### Configurando o suporte a Dart

Aqui está uma maneira de configurar o suporte a Dart:

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
    <li>Na tela de boas-vindas, clique em <b>New Project</b>.</li>
    <li>No próximo diálogo, clique em <b>Dart</b>.</li>
  </ol>
</li>
<br>

<li>
  <p>
    Se você não ver um valor para o caminho do <b>Dart SDK</b>,
    insira ou selecione-o.
  </p>

  <p>
    Por exemplo, o caminho do SDK pode ser
    <code><em>&lt;diretório de instalação do dart></em>/dart/dart-sdk</code>.
  </p>

  :::note
  O **Dart SDK** especifica o diretório que
  contém os diretórios `bin` e `lib` do SDK;
  o diretório `bin` contém ferramentas como `dart` e `dartaotruntime`.
  A IDE garante que o caminho seja válido.
  :::
</li>

<li>
  <p>
    Escolha um template inicial.
  </p>

  <ol type="a">
    <li>Para habilitar templates iniciais, clique em <b>Generate sample content</b>.</li>
    <li>Escolha o template desejado.</li>
  </ol>

  :::note
  Os templates fornecidos são criados
  por [`dart create`](/tools/dart-create).
  :::
</li>

<li>
  <p>Clique em <b>Next</b> e continue a configuração do projeto.</p>
</li>
</ol>

Uma alternativa ao Passo 2 é abrir um projeto Dart existente,
e então abrir seu arquivo `pubspec.yaml` ou qualquer um de seus arquivos Dart.


## Reportando problemas

Por favor, reporte problemas e feedback através do
[rastreador de problemas JetBrains oficial para Dart.][JetBrains issue tracker for Dart.]

Inclua detalhes do comportamento esperado, do comportamento real
e capturas de tela, se apropriado.

[JetBrains issue tracker for Dart.]: https://youtrack.jetbrains.com/issues?q=Subsystem:%20%7BLang.%20Dart%7D%20

## Mais informações

Consulte o site da JetBrains para obter mais informações.

* [IntelliJ IDEA](https://www.jetbrains.com/idea/)
  * [Ajuda do Dart WebStorm](https://www.jetbrains.com/help/webstorm/dart.html)
  * [Recursos](https://www.jetbrains.com/idea/features/)
  * [Início rápido](https://www.jetbrains.com/help/idea/getting-started.html)
* [Plugin Dart por JetBrains][Dart plugin]

[Dart plugin]: https://plugins.jetbrains.com/plugin/6351-dart/
