// Copyright (c) 2025, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:jaspr/jaspr.dart';
import 'package:universal_web/web.dart' as web;

/// The site-wide footer.
final class DashFooter extends StatelessComponent {
  const DashFooter({super.key});

  @override
  Component build(BuildContext context) {
    return footer(
      id: 'page-footer',
      attributes: {'data-nosnippet': 'true'},
      [
        div(classes: 'footer-section footer-main', [
          a(
            href: '/',
            classes: 'brand',
            attributes: {'title': 'Dart'},
            [
              img(
                src: '/assets/img/logo/logo-white-text.svg',
                alt: 'Dart',
                width: 164,
              ),
            ],
          ),
          div(classes: 'footer-social-links', [
            a(
              href: 'https://blog.dart.dev',
              target: Target.blank,
              attributes: {
                'rel': 'noopener',
                'title': 'Dart\'s Medium publication',
              },
              [
                svg([
                  const Component.element(
                    tag: 'use',
                    attributes: {
                      'href': '/assets/img/social/medium.svg#medium',
                    },
                  ),
                ]),
              ],
            ),
            a(
              href: 'https://github.com/dart-lang',
              target: Target.blank,
              attributes: {
                'rel': 'noopener',
                'title': 'Dart\'s GitHub organization',
              },
              [
                svg([
                  const Component.element(
                    tag: 'use',
                    attributes: {
                      'href': '/assets/img/social/github.svg#github',
                    },
                  ),
                ]),
              ],
            ),
            a(
              href: 'https://bsky.app/profile/dart.dev',
              target: Target.blank,
              attributes: {
                'rel': 'noopener',
                'title': 'Dart\'s Bluesky (Twitter) profile',
              },
              [
                svg([
                  const Component.element(
                    tag: 'use',
                    attributes: {
                      'href': '/assets/img/social/bluesky.svg#bluesky',
                    },
                  ),
                ]),
              ],
            ),
            a(
              href: 'https://twitter.com/dart_lang',
              target: Target.blank,
              attributes: {
                'rel': 'noopener',
                'title': 'Dart\'s X (Twitter) profile',
              },
              [
                svg([
                  const Component.element(
                    tag: 'use',
                    attributes: {'href': '/assets/img/social/x.svg#x'},
                  ),
                ]),
              ],
            ),
          ]),
        ]),
        div(classes: 'footer-section footer-translation-feedback', [
          p([
            text(
              'Encontrou essa página sem tradução ou que precisa de correção? ',
            ),
            a(
              id: 'translation-issue-link',
              href: '#',
              target: Target.blank,
              attributes: {'rel': 'noopener', 'title': 'Abrir issue no GitHub'},
              events: {
                'click': (event) {
                  event.preventDefault();
                  // Get current page URL
                  final currentUrl = web.window.location.href;

                  // Create issue title and body
                  final title = Uri.encodeComponent('Problema de tradução');
                  final body = Uri.encodeComponent(
                    '**URL da página:** $currentUrl\n\n'
                    '**Problema encontrado:**\n'
                    '<!-- Descreva o problema de tradução que você encontrou -->\n\n'
                    '- [ ] Página não traduzida\n'
                    '- [ ] Tradução incorreta ou incompleta\n'
                    '- [ ] Erro de português\n'
                    '- [ ] Outro (descrever abaixo)\n\n'
                    '**Descrição:**\n'
                    '<!-- Explique em detalhes o problema encontrado -->\n',
                  );

                  // Open GitHub issue with pre-filled content
                  final issueUrl =
                      'https://github.com/dart2brasil/site-www/issues/new?title=$title&body=$body';
                  web.window.open(issueUrl, '_blank');
                },
              },
              [text('Abra uma issue')],
            ),
            text(
              ' e nos ajude a manter esse site em PT-BR para ajudar pessoas como você.',
            ),
          ]),
        ]),
        div(classes: 'footer-section footer-tray', [
          div(classes: 'footer-licenses', [
            text(
              'Exceto quando indicado de outra forma, este site está licenciado sob uma ',
            ),
            a(href: 'https://creativecommons.org/licenses/by/4.0/', [
              text('Licença Creative Commons Attribution 4.0 International,'),
            ]),
            text(' e os exemplos de código estão licenciados sob a '),
            a(href: 'https://opensource.org/licenses/BSD-3-Clause', [
              text('Licença BSD de 3 Cláusulas.'),
            ]),
          ]),
          div(classes: 'footer-site-info', [
            p([
              text(
                'Este é o site em Português Brasileiro (dartbrasil.dev). O site original em inglês está em ',
              ),
              a(
                href: 'https://dart.dev',
                target: Target.blank,
                attributes: {
                  'rel': 'noopener',
                  'title': 'Site original em inglês',
                },
                [text('dart.dev')],
              ),
              text('.'),
            ]),
          ]),
          div(classes: 'footer-utility-links', [
            ul([
              li([
                a(
                  href: '/terms',
                  attributes: {'title': 'Termos de uso'},
                  [text('Termos')],
                ),
              ]),
              li([
                a(
                  href: 'https://policies.google.com/privacy',
                  target: Target.blank,
                  attributes: {
                    'rel': 'noopener',
                    'title': 'Política de privacidade',
                  },
                  [text('Privacidade')],
                ),
              ]),
              li([
                a(
                  href: '/security',
                  attributes: {'title': 'Filosofia e práticas de segurança'},
                  [text('Segurança')],
                ),
              ]),
            ]),
            div(classes: 'footer-technology', [
              a(
                classes: 'jaspr-badge-link',
                href: 'https://jaspr.site',
                target: Target.blank,
                attributes: {
                  'rel': 'noopener',
                  'title':
                      'This site is built with the '
                      'Jaspr web framework for Dart.',
                },
                [
                  span([const JasprBadge.light()]),
                  span([const JasprBadge.lightTwoTone()]),
                ],
              ),
            ]),
          ]),
        ]),
      ],
    );
  }
}
