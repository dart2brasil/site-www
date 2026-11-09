---
ia-translate: true
---

### Instalar usando um gerenciador de pacotes do Linux {:.no_toc #install-using-a-linux-package-manager}

Você tem duas opções para instalar o Dart SDK no Ubuntu ou Debian:

* Use o comando [apt-get](#install-using-the-apt-get-package-manager).
* Baixe um pacote [`.deb`](#install-as-a-debian-package)
  e execute o comando `dpkg`.

### Instalar usando o gerenciador de pacotes `apt-get` {:.no_toc #install-using-the-apt-get-package-manager}

Para instalar o Dart com `apt-get`, execute os seguintes passos.
Você precisa dos passos 1 a 3 apenas na primeira instalação.

1. Atualize os arquivos de índice de pacotes e instale os pacotes HTTP seguro e GPG.

   ```console
   $ sudo apt-get update && sudo apt-get install apt-transport-https gpg
   ```

1. Baixe e adicione a chave pública GPG do Google Linux.

   ```console
   $ wget -qO- https://dl-ssl.google.com/linux/linux_signing_key.pub \
     | sudo gpg --dearmor -o /usr/share/keyrings/dart.gpg
   ```

1. Adicione o repositório de pacotes do Dart ao seu sistema Linux.

   ```console
   $ echo 'deb [signed-by=/usr/share/keyrings/dart.gpg arch=amd64] https://storage.googleapis.com/download.dartlang.org/linux/debian stable main' \
     | sudo tee /etc/apt/sources.list.d/dart_stable.list
   ```

   Substitua `amd64` por `armhf`, `arm64` ou `riscv64`, conforme
   necessário para o seu sistema.

1. Use os seguintes comandos `sudo apt-get`.

   ```console
   $ sudo apt-get update && sudo apt-get install dart
   ```

### Instalar como um pacote Debian {:.no_toc #install-as-a-debian-package}

Para instalar o Dart SDK como um pacote Debian (`*.deb`),
execute os seguintes passos.

1. Baixe o [pacote Debian do Dart SDK](#){:.debian-link-stable}.

1. Use o comando `sudo dpkg` para instalar o pacote `*.deb`.

   ```console
   $ sudo dpkg -i dart_3.4.0-1_amd64.deb
   ```

   Substitua `dart_3.4.0-1_amd64.deb` pelo nome atual do arquivo.

## Atualizar o Dart SDK {:.no_toc #upgrade-the-dart-sdk}

Use o mesmo comando que você usou para instalar o SDK.

### Atualizar usando `apt-get` {:.no_toc #upgrade-using-apt-get}

Se você instalou o Dart SDK com `apt-get`,
use os seguintes comandos `sudo apt-get`.

```console
$ sudo apt-get update && sudo apt-get install dart
```

### Atualizar usando `dpkg` {:.no_toc #upgrade-using-dpkg}

Se você instalou o Dart SDK com `dpkg`,
use o comando `sudo dpkg`.

```console
$ sudo dpkg -i dart_3.2.6-1_amd64.deb
```

Substitua `dart_3.4.0-1_amd64.deb` pelo nome do arquivo da nova atualização.

## Desinstalar o Dart SDK {:.no_toc #uninstall-the-dart-sdk}

### Desinstalar usando `apt-get` {:.no_toc #uninstall-using-apt-get}

Se você instalou o Dart SDK com `apt-get`,
use o comando `sudo apt-get remove`.

1. Use o comando `sudo apt-get remove`.

   ```console
   $ sudo apt-get remove -y dart
   ```

1. Remova os arquivos de configuração do Dart do seu diretório home.

   ```console
   $ rm -rf  ~/.dart*
   ```

### Desinstalar usando `dpkg` {:.no_toc #uninstall-using-dpkg}

Se você instalou o Dart SDK com `dpkg`,
use o comando `sudo dpkg --purge`.

1. Use o comando `sudo dpkg --purge`.

   ```console
   $ sudo dpkg --purge dart
   ```

   Isso remove os arquivos de configuração ao mesmo tempo.

1. Verifique se o SDK foi removido.

   ```console
   $ dpkg -l | grep dart
   ```

[sudo]: https://www.sudo.ws/
