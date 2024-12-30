---
ia-translate: true
title: Segurança
description: >-
  Uma visão geral da filosofia e processos da equipe Dart para segurança.
skipFreshness: true
---

A equipe Dart leva a sério a segurança do Dart e dos aplicativos
criados com ele.
Esta página descreve como relatar quaisquer vulnerabilidades que você encontrar,
e lista as melhores práticas para minimizar o risco de introduzir uma vulnerabilidade.

## Filosofia de segurança

A estratégia de segurança do Dart é baseada em cinco pilares principais:

- **Identificar**: Rastrear e priorizar os principais riscos de segurança,
  identificando os principais ativos,
  ameaças e vulnerabilidades principais.
- **Detectar**: Detectar e identificar vulnerabilidades usando técnicas e
  ferramentas como
  verificação de vulnerabilidades,
  teste de segurança de aplicativos estático e fuzzing.
- **Proteger**: Eliminar riscos mitigando vulnerabilidades conhecidas e proteger
  ativos críticos contra ameaças de origem.
- **Responder**: Definir processos para relatar, avaliar e responder a vulnerabilidades
  ou ataques.
- **Recuperar**: Construir capacidades para conter e se recuperar de um incidente com
  impacto mínimo.

## Relatando vulnerabilidades

Para relatar um problema de segurança, use [https://g.co/vulnz][https://g.co/vulnz].
A coordenação e a divulgação ocorrem nos [repositórios dart-lang do GitHub][repos]
(incluindo [avisos de segurança do GitHub][GitHub security advisories]).
Inclua uma descrição detalhada do problema,
as etapas que você seguiu para criar o problema, as versões afetadas e
quaisquer mitigações para o problema.
A Equipe de Segurança do Google responderá dentro de 5 dias úteis
do seu relatório em g.co/vulnz.

Para mais informações sobre como o Google lida com questões de segurança, veja
[Filosofia de segurança do Google][Google's security philosophy].

## Sinalizando problemas existentes como relacionados à segurança

Se você acredita que um problema existente está relacionado à segurança,
pedimos que o relate através de [https://g.co/vulnz][https://g.co/vulnz] e inclua
o ID do problema em seu relatório.

## Versões suportadas

Nós nos comprometemos a publicar atualizações de segurança para a versão do
Dart atualmente para
o lançamento [estável][stable] mais recente do Dart.

[stable]: https://dart.dev/get-dart#release-channels

## Expectativas

Tratamos questões de segurança como equivalente a um nível de prioridade P0
e lançamos uma correção beta ou patch
para quaisquer grandes problemas de segurança encontrados
na versão estável mais recente do SDK do Dart.
Qualquer vulnerabilidade relatada para sites do Dart, como dart.dev, não
requer uma versão e será corrigida no próprio site.

O Dart não tem um programa de recompensa por bugs.

## Recebendo atualizações de segurança

Dependendo do problema e da correção da versão, um anúncio será feito para
a lista de e-mails [dart-announce](https://groups.google.com/a/dartlang.org/g/announce).

## Melhores práticas

*   **Mantenha-se atualizado com as versões mais recentes do SDK do Dart.**
    Nós atualizamos o Dart regularmente, e essas atualizações podem corrigir
    defeitos de segurança descobertos em versões anteriores.
    Verifique o [changelog do Dart][Dart changelog]
    para atualizações relacionadas à segurança.

*   **Mantenha as dependências do seu aplicativo atualizadas.**
    Certifique-se de [atualizar as dependências do seu pacote][upgrade your package dependencies]
    para manter as dependências atualizadas.
    Evite fixar versões específicas
    para suas dependências e, se o fizer, certifique-se de verificar
    periodicamente para ver se suas dependências tiveram atualizações de segurança,
    e atualize a fixação de versão de acordo.

[Dart changelog]: {{site.repo.dart.sdk}}/blob/main/CHANGELOG.md
[GitHub security advisories]: https://docs.github.com/en/code-security/security-advisories
[Google's security philosophy]: https://www.google.com/about/appsecurity/
[https://g.co/vulnz]: https://g.co/vulnz
[repos]: {{site.repo.dart.org}}/
[upgrade your package dependencies]: /tools/pub/packages#upgrading-a-dependency
