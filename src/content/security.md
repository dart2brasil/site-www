---
ia-translate: true
title: Segurança
description: >-
  Uma visão geral da filosofia e dos processos da equipe Dart para segurança.
skipFreshness: true
---

A equipe Dart leva a segurança do Dart e dos aplicativos
criados com ele a sério.
Esta página descreve como reportar quaisquer vulnerabilidades que você encontrar,
e lista as melhores práticas para minimizar o risco de introduzir uma vulnerabilidade.

## Filosofia de segurança {:#security-philosophy}

A estratégia de segurança do Dart é baseada em cinco pilares principais:

- **Identificar**: Rastrear e priorizar os principais riscos de segurança, identificando os ativos principais,
  ameaças e vulnerabilidades chave.
- **Detectar**: Detectar e identificar vulnerabilidades usando técnicas e ferramentas como
  verificação de vulnerabilidades,
  teste de segurança de aplicativos estático e *fuzzing* (teste de software com dados inválidos).
- **Proteger**: Eliminar riscos, mitigando vulnerabilidades conhecidas e protegendo
  ativos críticos contra ameaças de origem.
- **Responder**: Definir processos para reportar, classificar e responder a vulnerabilidades
  ou ataques.
- **Recuperar**: Construir capacidades para conter e se recuperar de um incidente com
  impacto mínimo.

## Reportando vulnerabilidades {:#reporting-vulnerabilities}

Para reportar um problema de segurança, use [https://g.co/vulnz][https://g.co/vulnz].
A coordenação e divulgação acontecem nos [repositórios do dart-lang no GitHub][repos]
(incluindo [avisos de segurança do GitHub][avisos de segurança do GitHub]).
Por favor, inclua uma descrição detalhada do problema,
os passos que você deu para criar o problema, as versões afetadas e quaisquer
mitigações para o problema.
A Equipe de Segurança do Google responderá em até 5 dias úteis após
seu relatório em g.co/vulnz.

Para mais informações sobre como o Google lida com questões de segurança, veja
[Filosofia de segurança do Google][Filosofia de segurança do Google].

## Sinalizando problemas existentes como relacionados à segurança {:#flagging-existing-issues-as-security-related}

Se você acredita que um problema existente está relacionado à segurança,
pedimos que você o reporte via [https://g.co/vulnz][https://g.co/vulnz] e inclua
o ID do problema em seu relatório.

## Versões suportadas {:#supported-versions}

Nós nos comprometemos a publicar atualizações de segurança para a versão do Dart atualmente
para a versão mais recente [estável][stable] do Dart.

[stable]: https://dartbrasil.dev/get-dart#release-channels

## Expectativas {:#expectations}

Tratamos problemas de segurança equivalentes a um nível de prioridade P0
e lançamos uma correção beta ou *patch*
para quaisquer grandes problemas de segurança encontrados
na versão estável mais recente do Dart SDK.
Qualquer vulnerabilidade reportada para sites Dart como dartbrasil.dev não
requer um lançamento e será corrigida no próprio site.

Dart não tem um programa de recompensas por bugs.

## Recebendo atualizações de segurança {:#receiving-security-updates}

Dependendo do problema e da versão de correção,
um anúncio será feito para
a lista de discussão [dart-announce](https://groups.google.com/a/dartlang.org/g/announce).

## Melhores práticas {:#best-practices}

* **Mantenha-se atualizado com as últimas versões do Dart SDK.**
  Nós atualizamos o Dart regularmente, e estas atualizações podem corrigir segurança
  defeitos descobertos em versões anteriores.
  Verifique o [changelog do Dart][changelog do Dart]
  para atualizações relacionadas à segurança.

* **Mantenha as dependências do seu aplicativo atualizadas.**
  Certifique-se de [atualizar as dependências do seu pacote][atualizar as dependências do seu pacote]
  para manter as dependências atualizadas.
  Evite fixar em versões específicas
  para suas dependências e, se o fizer, certifique-se de verificar
  periodicamente para ver se suas dependências tiveram atualizações de segurança,
  e atualize a fixação da versão de acordo.

[changelog do Dart]: {{site.repo.dart.sdk}}/blob/main/CHANGELOG.md
[avisos de segurança do GitHub]: https://docs.github.com/en/code-security/security-advisories
[Filosofia de segurança do Google]: https://www.google.com/about/appsecurity/
[https://g.co/vulnz]: https://g.co/vulnz
[repos]: {{site.repo.dart.org}}/
[atualizar as dependências do seu pacote]: /tools/pub/packages#upgrading-a-dependency
