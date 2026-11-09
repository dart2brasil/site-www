---
ia-translate: true
title: Solucionar problemas de desempenho do analyzer
description: >-
  Aprenda a diagnosticar e resolver problemas comuns
  de desempenho do analysis server do Dart.
---

Este guia ajuda você a diagnosticar e resolver problemas comuns de desempenho
do analysis server do Dart no seu IDE Dart ou Flutter.

## Problemas de desempenho conhecidos {:#known-performance-issues}

Vários problemas comuns prejudicam significativamente o desempenho do
analysis server do Dart (o analyzer).
Verifique os problemas a seguir para ver se eles podem estar afetando
seu ambiente de desenvolvimento.

### Software de segurança no Windows {:#security-software-on-windows}

Em sistemas Windows, se o Windows Defender (ou outro software de segurança em tempo real)
estiver ativo, ele pode deixar as leituras de arquivos lentas o suficiente
para afetar o desempenho do analyzer. O analyzer lê arquivos com frequência,
e a varredura constante pode introduzir latência. Para mitigar isso,
você pode configurar exclusões para os diretórios dos quais o analyzer lê.

:::warning
Excluir diretórios das varreduras de segurança pode diminuir a
proteção oferecida pelo seu antivírus.
Prossiga com cuidado.
:::

Se você optar por configurar exclusões, inclua os seguintes diretórios:

* O diretório de cache do analysis server: `%LOCALAPPDATA%\.dartServer`
* O diretório dos pacotes baixados pelo pub: `%LOCALAPPDATA%\Pub\Cache`
* Quaisquer outros diretórios que contenham o código das suas aplicações.

Para outra forma de melhorar o desempenho de E/S de arquivos,
considere configurar um [dev drive][].

### Links simbólicos {:#symbolic-links}

Se o diretório do seu pacote contiver links simbólicos que apontam
para um local dentro do mesmo diretório, ou para um diretório pai,
você pode ter problemas de desempenho com as ferramentas do Dart (como o analyzer).

**Status:** a equipe do Dart está trabalhando ativamente em uma correção para este problema.

**Solução alternativa:** no momento, não há soluções alternativas conhecidas.

## Relatar problemas desconhecidos {:#report-unknown-issues}

Se os problemas conhecidos não parecerem se aplicar à sua situação,
abra uma issue no [rastreador de issues do Dart SDK][Dart SDK issue tracker].
Quanto mais informações você fornecer,
mais rápido a equipe poderá diagnosticar e corrigir o problema.

### Inclua os passos para reproduzir {:#include-reproduction-steps}

Na sua issue, forneça passos detalhados para
reproduzir o comportamento que você está observando.

1. Se você estiver trabalhando em um projeto de código aberto, inclua instruções
  para baixar o código.
2. Se não puder compartilhar seu código, crie um caso de reprodução pequeno e autocontido.
3. Se não puder fornecer nenhum dos dois, informe isso na issue.

### Forneça dados de desempenho {:#provide-performance-data}

Se o problema estiver relacionado a desempenho, fornecer dados de desempenho
pode ser muito útil. Você pode coletar esses dados usando as
páginas de diagnóstico do analysis server:

1. **Abra a página Analyzer Diagnostics:**
    * **Se você estiver usando o VS Code:**
        1. Clique em **View > Command Palette**.
        2. Digite `Dart: Open Analyzer Diagnostics` e selecione a opção.
    * **Se você estiver usando o IntelliJ / Android Studio:**
        1. Abra a janela de ferramenta **Dart Analysis**.
        2. Clique no ícone de configurações e, em seguida, selecione **View analyzer diagnostics**.
2. **Colete o relatório:**
    1. Na página do navegador que abrir, clique em **Collect Report** no banner superior.
    2. Execute as ações que disparam o comportamento lento.
    3. Clique no link **Download report**.
3. **Anexe o relatório à sua issue.**

:::note
Embora o relatório não deva conter
informações pessoais ou proprietárias, revise-o antes de enviá-lo.
:::

### Capture os logs de instrumentação {:#capture-instrumentation-logs}

Em alguns casos, os logs de instrumentação podem fornecer detalhes adicionais
para diagnosticar problemas.

Para capturar esses logs:

* **VS Code:** siga as instruções para
  [capturar logs de instrumentação do analyzer][capturing analyzer instrumentation logs].
* **IntelliJ / Android Studio:** siga as
  [instruções de instrumentação do analyzer][analyzer instrumentation instructions].

Antes de anexar logs a uma issue no GitHub, revise-os com atenção
para garantir que não contenham nenhuma informação pessoal, sensível ou proprietária.

[dev drive]: https://learn.microsoft.com/windows/dev-drive/
[Dart SDK issue tracker]: {{site.repo.dart.sdk}}/issues
[capturing analyzer instrumentation logs]: https://dartcode.org/docs/logging/#analyzer-instrumentation
[analyzer instrumentation instructions]: {{site.repo.dart.sdk}}/blob/main/pkg/analysis_server/doc/tutorial/instrumentation.md#intellij-idea-and-android-studio
