<!-- ia-translate: true -->
Sem suporte para compilação cruzada ([issue 28617][issue 28617])
: O compilador pode criar código de máquina apenas para
  o sistema operacional em que você está compilando.
  Para criar executáveis para macOS, Windows e Linux, você precisa
  executar o compilador três vezes.
  Você também pode usar um provedor de integração contínua (CI)
  que oferece suporte aos três sistemas operacionais.

Sem suporte para `dart:mirrors` e `dart:developer`
: Para obter uma lista completa das bibliotecas principais que você pode usar,
  consulte as tabelas de bibliotecas [Multi-plataforma][Multi-platform] e [Plataforma nativa][Native platform].

[Multi-platform]: /libraries#multi-platform-libraries
[Native platform]: /libraries#native-platform-libraries
[issue 28617]: {{site.repo.dart.sdk}}/issues/28617

:::tip
Se um desses problemas for importante para você,
informe a equipe do Dart adicionando um "joinha" ao problema.
:::
