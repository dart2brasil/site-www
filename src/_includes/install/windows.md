---
ia-translate: true
---

### Instalar usando o Chocolatey {:.no_toc}

Para instalar o Dart SDK, use o [Chocolatey][Chocolatey].
O Chocolatey requer [permissões elevadas][elevated permissions].

1. Instale o Chocolatey.

1. Inicie o [PowerShell][] com permissões elevadas.

   ```ps
   PS C:\> choco install dart-sdk
   ```

### Alterar o caminho de instalação padrão {:.no_toc}

Por padrão, o Chocolatey instala o SDK em `C:\tools\dart-sdk`.
Para alterar esse local, defina a variável de ambiente [`ChocolateyToolsLocation`][]
para o diretório de instalação desejado.

### Verificar se o seu PATH inclui o Dart {:.no_toc}

Verifique se você pode executar o Dart.

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
6. Em cada janela que você acabou de abrir,
   clique em **Aplicar** ou **OK** para fechá-la e aplicar a alteração no caminho.

### Atualizar usando o Chocolatey {:.no_toc}

Para atualizar o Dart SDK, use o seguinte comando.

```ps
PS C:\> choco upgrade dart-sdk
```

### Desinstalar usando o Chocolatey {:.no_toc}

Para desinstalar o Dart SDK, execute os seguintes passos.

1. Inicie o [PowerShell][] com permissões elevadas.

1. Use o seguinte comando.

   ```ps
   PS C:\> choco uninstall dart-sdk
   ```

1. Remova os arquivos de configuração do Dart do seu diretório home.

   ```ps
   PS C:\> Remove-Item -Recurse -Force ^
        -Path $env:LOCALAPPDATA\.dartServer,$env:APPDATA\.dart,$env:APPDATA\.dart-tool
   ```

[elevated permissions]: https://www.thewindowsclub.com/elevated-privileges-windows
[PowerShell]: https://www.thewindowsclub.com/how-to-open-an-elevated-powershell-prompt-in-windows-10
[Chocolatey]: https://chocolatey.org
[`ChocolateyToolsLocation`]: https://stackoverflow.com/questions/19752533/how-do-i-set-chocolatey-to-install-applications-onto-another-drive/68314437#68314437
