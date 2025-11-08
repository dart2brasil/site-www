---
ia-translate: true
---

### Instalar usando o Homebrew {:.no_toc}

Para instalar o Dart SDK, use o [Homebrew][].

1. Instale o Homebrew se necessário.

1. Adicione o [tap oficial][tap].

   ```console
   $ brew tap dart-lang/dart
   ```

1. Instale o Dart SDK.

   ```console
   $ brew install dart
   ```

### Verificar se o PATH inclui o Homebrew {:.no_toc}

Verifique se o seu `PATH` inclui o **diretório `bin` do Homebrew**.
Configurar o caminho correto simplifica o uso de comandos do Dart SDK
como `dart run` e `dart format`.

Para obter ajuda configurando o seu `PATH`, consulte o [FAQ do Homebrew][Homebrew FAQ].

### Atualizar usando o Homebrew {:.no_toc}

Para atualizar quando uma nova versão do Dart estiver disponível:

```console
$ brew upgrade dart
```

### Alternar versões do Dart {:.no_toc}

Para alternar entre versões do Dart instaladas localmente:

1. Instale a versão para a qual você deseja alternar.

   Por exemplo, para instalar o Dart 3.1:

   ```console
   $ brew install dart@3.1
   ```

1. Para alternar entre versões,
   desvincule a versão atual e vincule a versão desejada.

   ```console
   $ brew unlink dart@<old> \
     && brew unlink dart@<new> \
     && brew link dart@<new>
   ```

### Listar versões do Dart instaladas {:.no_toc}

Para ver quais versões do Dart você instalou:

```console
$ brew info dart
```

### Desinstalar usando o Homebrew {:.no_toc}

Para desinstalar o Dart SDK, use o [Homebrew][].

1. Desinstale o Dart SDK.

   ```console
   $ brew uninstall dart
   ```

1. Remova os arquivos de configuração do Dart do seu diretório home.

   ```dart
   rm -rf  ~/.dart*
   ```

[Homebrew]: https://brew.sh
[tap]: {{site.repo.dart.org}}/homebrew-dart
[Homebrew FAQ]: https://docs.brew.sh/FAQ#my-mac-apps-dont-find-homebrew-utilities
