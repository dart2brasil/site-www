---
ia-translate: true
---

Você tem duas opções para instalar o Dart SDK no Windows:

* Use o [winget](#install-using-winget).
* Use o [Chocolatey](#install-using-chocolatey).

### Instalar usando o winget {:.no_toc #install-using-winget}

Para instalar o Dart SDK, use o [winget][]:

```ps
PS C:\> winget install --id=Google.DartSDK -e
```

### Instalar usando o Chocolatey {:.no_toc #install-using-chocolatey}

Para instalar o Dart SDK, use o [Chocolatey][Chocolatey].
O Chocolatey requer [permissões elevadas][elevated permissions].

1. Instale o Chocolatey.

1. Inicie o [PowerShell][] com permissões elevadas.

   ```ps
   PS C:\> choco install dart-sdk
   ```

### Alterar o caminho de instalação padrão do Chocolatey {:.no_toc #change-default-chocolatey-install-path}

Por padrão, o Chocolatey instala o SDK em `C:\tools\dart-sdk`.
Para alterar esse local, defina a variável de ambiente
[`ChocolateyToolsLocation`][]
com o diretório de instalação desejado.

### Verificar se o seu PATH inclui o Dart {:.no_toc #verify-your-path-includes-dart}

Verifique se você consegue executar o Dart.

```ps
PS C:\> dart --version
Dart SDK version: 3.2.4 (stable) (Thu Dec 21 19:13:53 2023 +0000) on "win_x64"
```

Se a sua máquina de desenvolvimento não retornar uma versão do Dart,
adicione o local do SDK ao seu PATH:

1. Na caixa de pesquisa do Windows, digite `env`.
2. Clique em **Editar as variáveis de ambiente do sistema**.
3. Clique em **Variáveis de Ambiente...**.
4. Na seção de variáveis de usuário, selecione **Path** e clique em **Editar...**.
5. Clique em **Novo** e insira o caminho para o diretório `dart-sdk`.
6. Em cada janela que você abriu,
   clique em **Aplicar** ou **OK** para fechá-la e aplicar a alteração no caminho.

### Atualizar usando o winget {:.no_toc #upgrade-using-winget}

Para atualizar o Dart SDK usando o winget,
use o seguinte comando.

```ps
PS C:\> winget upgrade --id=Google.DartSDK -e
```

### Atualizar usando o Chocolatey {:.no_toc #upgrade-using-chocolatey}

Para atualizar o Dart SDK usando o Chocolatey,
use o seguinte comando.

```ps
PS C:\> choco upgrade dart-sdk
```

### Desinstalar usando o winget {:.no_toc #uninstall-using-winget}

Para desinstalar o Dart SDK usando o winget,
execute os seguintes passos.

1. Use o seguinte comando.

   ```ps
   PS C:\> winget uninstall --id=Google.DartSDK -e
   ```

1. Remova os arquivos de configuração do Dart do seu diretório home.

   ```ps
   PS C:\> Remove-Item -Recurse -Force `
        -Path $env:LOCALAPPDATA\.dartServer,$env:APPDATA\.dart,$env:APPDATA\.dart-tool
   ```

### Desinstalar usando o Chocolatey {:.no_toc #uninstall-using-chocolatey}

Para desinstalar o Dart SDK usando o Chocolatey,
execute os seguintes passos.

1. Inicie o [PowerShell][] com permissões elevadas.

1. Use o seguinte comando.

   ```ps
   PS C:\> choco uninstall dart-sdk
   ```

1. Remova os arquivos de configuração do Dart do seu diretório home.

   ```ps
   PS C:\> Remove-Item -Recurse -Force `
        -Path $env:LOCALAPPDATA\.dartServer,$env:APPDATA\.dart,$env:APPDATA\.dart-tool
   ```

[elevated permissions]: https://www.thewindowsclub.com/elevated-privileges-windows
[PowerShell]: https://www.thewindowsclub.com/how-to-open-an-elevated-powershell-prompt-in-windows-10
[Chocolatey]: https://chocolatey.org
[`ChocolateyToolsLocation`]: https://stackoverflow.com/questions/19752533/how-do-i-set-chocolatey-to-install-applications-onto-another-drive/68314437#68314437
[winget]: https://learn.microsoft.com/windows/package-manager/winget/
