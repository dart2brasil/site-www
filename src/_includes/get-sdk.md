<!-- ia-translate: true -->
Para desenvolver apps reais,
você precisa de um SDK.
Você pode baixar o Dart SDK diretamente
(como descrito abaixo)
ou [baixar o Flutter SDK,][download the Flutter SDK,]
que inclui o Dart SDK completo.

[download the Flutter SDK,]: {{site.flutter-docs}}/get-started/install

<ul class="tabs__top-bar">
  <li class="tab-link current" data-tab="tab-sdk-install-windows">Windows</li>
  <li class="tab-link" data-tab="tab-sdk-install-linux">Linux</li>
  <li class="tab-link" data-tab="tab-sdk-install-mac">Mac</li>
</ul>

<div id="tab-sdk-install-windows" class="tabs__content current">

  Use o [Chocolatey](https://chocolatey.org) para instalar uma versão estável
  do Dart SDK.

  :::important
  Estes comandos exigem privilégios de administrador.
  Se precisar de ajuda para iniciar um prompt de comando de nível de administrador,
  tente uma pesquisa como
  <em><a href="https://www.google.com/search?q=cmd+admin"
  target="blank">cmd admin</a>.</em>
  :::

  Para instalar o Dart SDK:

  ```ps
  C:\> choco install dart-sdk
  ```

</div>

<div id="tab-sdk-install-linux" class="tabs__content">

  Você pode usar o APT para instalar o Dart SDK no Linux.

  1. Execute a seguinte configuração única:
  
     ```console
     $ sudo apt-get update
     $ sudo apt-get install apt-transport-https
     $ wget -qO- https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo gpg --dearmor -o /usr/share/keyrings/dart.gpg
     $ echo 'deb [signed-by=/usr/share/keyrings/dart.gpg arch=amd64] https://storage.googleapis.com/download.dartlang.org/linux/debian stable main' | sudo tee /etc/apt/sources.list.d/dart_stable.list
     ```

  2. Instale o Dart SDK:
  
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
Para mais informações, incluindo como **ajustar o seu `PATH`**, veja
[Obtenha o Dart SDK](/get-dart).
:::
