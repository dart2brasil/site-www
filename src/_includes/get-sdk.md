<!-- ia-translate: true -->
Para desenvolver aplicativos reais,
você precisa de um SDK.
Você pode baixar o SDK do Dart diretamente
(como descrito abaixo)
ou [baixar o SDK do Flutter,][]
que inclui o SDK completo do Dart.

[baixar o SDK do Flutter,]: {{site.flutter-docs}}/get-started/install

<ul class="tabs__top-bar">
  <li class="tab-link current" data-tab="tab-sdk-install-windows">Windows</li>
  <li class="tab-link" data-tab="tab-sdk-install-linux">Linux</li>
  <li class="tab-link" data-tab="tab-sdk-install-mac">Mac</li>
</ul>

<div id="tab-sdk-install-windows" class="tabs__content current">

  Use o [Chocolatey](https://chocolatey.org) para instalar uma versão estável do
  SDK do Dart.

  :::important
  Esses comandos exigem privilégios de administrador.
  Se você precisar de ajuda para iniciar um prompt de comando de nível de administrador,
  tente uma pesquisa como
  <em><a href="https://www.google.com/search?q=cmd+admin"
  target="blank">cmd admin</a>.</em>
  :::

  Para instalar o SDK do Dart:

  ```ps
  C:\> choco install dart-sdk
  ```

</div>

<div id="tab-sdk-install-linux" class="tabs__content">

  Você pode usar o APT para instalar o SDK do Dart no Linux.

  1. Execute a seguinte configuração única:
  
     ```console
     $ sudo apt-get update
     $ sudo apt-get install apt-transport-https
     $ wget -qO- https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo gpg --dearmor -o /usr/share/keyrings/dart.gpg
     $ echo 'deb [signed-by=/usr/share/keyrings/dart.gpg arch=amd64] https://storage.googleapis.com/download.dartlang.org/linux/debian stable main' | sudo tee /etc/apt/sources.list.d/dart_stable.list
     ```

  2. Instale o SDK do Dart:
  
     ```console
     $ sudo apt-get update
     $ sudo apt-get install dart
     ```
     
</div>

<div id="tab-sdk-install-mac" class="tabs__content">

  Com o [Homebrew,](https://brew.sh/)
  instalar o Dart é fácil.

  ```console
  $ brew tap dart-lang/dart
  $ brew install dart
  ```

</div>

:::important
Para mais informações, incluindo como **ajustar o seu `PATH` (caminho)**, veja
[Obtenha o SDK do Dart](/get-dart).
:::
