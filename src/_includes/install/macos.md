<!-- ia-translate: true -->

### Instalação usando Homebrew {:.no_toc}

Para instalar o SDK do Dart, use o [Homebrew][Homebrew].

1. Instale o Homebrew, se necessário.

2. Adicione o [tap oficial][tap].

   ```console
   $ brew tap dart-lang/dart
   ```

3. Instale o SDK do Dart.

   ```console
   $ brew install dart
   ```

### Verifique se o PATH inclui o Homebrew {:.no_toc}

Verifique se o seu `PATH` inclui o diretório `bin` do **Homebrew**.
Configurar o path correto simplifica o uso de comandos do SDK Dart
como `dart run` e `dart format`.

Para obter ajuda na configuração do seu `PATH`, consulte o [FAQ do Homebrew][Homebrew FAQ].

### Atualização usando Homebrew {:.no_toc}

Para atualizar quando uma nova versão do Dart estiver disponível:

```console
$ brew upgrade dart
```

### Alternar versões do Dart {:.no_toc}

Para alternar entre versões do Dart instaladas localmente:

1. Instale a versão para a qual deseja alternar.

   Por exemplo, para instalar o Dart 3.1:

   ```console
   $ brew install dart@3.1
   ```

2. Para alternar entre versões,
   desvincule a versão atual e vincule a versão desejada.

   ```console
   $ brew unlink dart@<antiga> \
     && brew unlink dart@<nova> \
     && brew link dart@<nova>
   ```

### Listar versões do Dart instaladas {:.no_toc}

Para ver quais versões do Dart você instalou:

```console
$ brew info dart
```

### Desinstalação usando Homebrew {:.no_toc}

Para desinstalar o SDK do Dart, use o [Homebrew][Homebrew].

1. Desinstale o SDK do Dart.

   ```console
   $ brew uninstall dart
   ```

2. Remova os arquivos de configuração do Dart do seu diretório home.

   ```dart
   rm -rf  ~/.dart*
   ```

[Homebrew]: https://brew.sh
[tap]: {{site.repo.dart.org}}/homebrew-dart
[Homebrew FAQ]: https://docs.brew.sh/FAQ#my-mac-apps-dont-find-homebrew-utilities
