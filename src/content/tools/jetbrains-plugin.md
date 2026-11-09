---
ia-translate: true
title: IntelliJ e Android Studio
description: Use o plugin Dart com várias IDEs baseadas na IntelliJ Platform.
---

O plugin Dart adiciona suporte a Dart às IDEs baseadas na IntelliJ Platform.
Essas IDEs oferecem recursos exclusivos de tecnologias de desenvolvimento específicas.
Qualquer que seja a IDE JetBrains que você escolher para desenvolver em Dart,
esta página tem recursos para ajudá-lo a começar rapidamente
e a encontrar mais informações quando precisar.

## Começando {:#get-started}

Se você ainda não tem a IDE e o Dart SDK, obtenha-os.
Depois, instale o plugin Dart e informe onde encontrar o Dart SDK.


### Baixe a IDE {:#download-the-ide}

Instale uma IDE JetBrains se você ainda não tiver uma. Escolha uma:

* [Android Studio][AS-Install]{:target="_blank" rel="noopener"}
* [IntelliJ IDEA Ultimate][IDEA-Install]{:target="_blank" rel="noopener"}
* [GoLand][GoLand-Install]{:target="_blank" rel="noopener"}
* [WebStorm][WS-Install]{:target="_blank" rel="noopener"}

[AS-Install]: {{site.android-dev}}/studio/install
[IDEA-Install]: https://www.jetbrains.com/idea/download/
[GoLand-Install]: https://www.jetbrains.com/help/go/getting-started.html
[WS-Install]: https://www.jetbrains.com/webstorm/download/


### Baixe o Dart SDK {:#download-the-dart-sdk}

Se você ainda não tem o Dart SDK,
instale-o.
Você pode obtê-lo sozinho ou baixando o Flutter SDK,
que inclui o Dart SDK completo.

Escolha um:

* [Baixe o Dart SDK](/get-dart)
* [Baixe o Flutter SDK]({{site.flutter-docs}}/get-started/install)


### Instale o plugin Dart {:#install-the-dart-plugin}

Para configurar o suporte a Dart, comece instalando o plugin:

1. Inicie a IDE.
2. Na tela de boas-vindas, escolha **Plugins**.
3. Pesquise por **Dart**.
4. Instale o plugin e reinicie a IDE.


### Crie um novo projeto Dart {:#create-a-new-dart-project}

Para criar um novo projeto:

1. Na tela de boas-vindas, clique em **New Project**.
2. No diálogo seguinte, clique em **Dart**.
3. Se você não vir um valor para o caminho do **Dart SDK**,
   informe-o ou selecione-o.

   Por exemplo, o caminho do SDK pode ser
   `<dart installation directory>/dart/dart-sdk`.

   :::note
   O caminho do **Dart SDK** é o diretório que contém
   os diretórios `bin` e `lib`.
   O diretório `bin` contém ferramentas como `dart` e `dartaotruntime`.
   A IDE valida se o caminho selecionado está correto.
   :::

4. Escolha um template inicial.
   1. Para habilitar os templates iniciais, clique em **Generate sample content**.
   2. Escolha o template desejado.

5. Clique em **Next** e continue a configuração do projeto.


### Abra um projeto Dart existente {:#open-an-existing-dart-project}

Para trabalhar em um aplicativo Dart existente, abra o projeto na IDE e habilite o suporte a Dart.

#### Abra o projeto {:#open-the-project}

1. Na tela de boas-vindas, clique em **Open** ou **Import**.
   Como alternativa, selecione **File | Open** no menu principal.
2. Selecione a pasta que contém seu projeto Dart.

#### Habilite o suporte a Dart {:#enable-dart-support}

1. Abra **Settings** (<kbd>Cmd</kbd> + <kbd>,</kbd>) e
   escolha **Dart** em **Languages and Frameworks**.
   Isso abrirá a página do Dart.
2. Marque **Enable Dart support for the project &lt;project name&gt;**.
3. Verifique o **Dart SDK Path**.
   A IDE normalmente detecta isso automaticamente.
   Se não detectar, selecione manualmente o diretório que contém o Dart SDK.
4. Em **Enable Dart support for the following modules**,
   selecione os módulos que precisam de funcionalidades do Dart.


### Trabalhe com vários projetos Dart (pacotes) {:#work-with-multiple-dart-projects-packages}

Para trabalhar com vários projetos Dart (pacotes) em um único projeto do IntelliJ IDEA,
adicione a pasta raiz do projeto adicional como uma content root ou como um novo módulo.

1. Acesse a [página de Modules](https://www.jetbrains.com/help/idea/modules-page.html)
    (**File | Project Structure | Modules**) e adicione uma content root conforme descrito em
    [Adding a content root](https://www.jetbrains.com/help/idea/content-roots.html#adding_content_root).

2.  Selecione **File | New | Module from Existing Sources**
    e escolha o módulo relevante no diálogo que se abre.

### Configure o destaque de sintaxe {:#configure-syntax-highlighting}

Você pode personalizar o destaque de sintaxe do Dart para combinar com suas preferências.

1. Abra **Settings** (<kbd>Cmd</kbd> + <kbd>,</kbd>) e
   acesse **Editor | Color Scheme | Dart**.
2. Selecione um esquema de cores ou personalize as configurações padrão, conforme descrito em
   [Colors and fonts](https://www.jetbrains.com/help/idea/configuring-colors-and-fonts.html).

## Reporte problemas {:#report-issues}

Por favor, reporte problemas e feedback pelo
[rastreador de issues do IntelliJ][IntelliJ issue tracker]. Inclua detalhes do
comportamento esperado, do comportamento real e capturas de tela, se apropriado.

[IntelliJ issue tracker]: https://github.com/flutter/flutter-intellij/issues

## Mais informações {:#more-information}

Consulte o site da JetBrains para mais informações.

* [IntelliJ IDEA](https://www.jetbrains.com/idea/)
  * [Ajuda do Dart no WebStorm](https://www.jetbrains.com/help/webstorm/dart.html)
  * [Recursos](https://www.jetbrains.com/idea/features/)
  * [Início rápido](https://www.jetbrains.com/help/idea/getting-started.html)
* [Plugin Flutter para IntelliJ](https://github.com/flutter/flutter-intellij)
