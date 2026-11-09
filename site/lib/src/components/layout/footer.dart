// Copyright (c) 2025, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

/// The site-wide footer.
final class DashFooter extends StatelessComponent {
  const DashFooter({super.key});

  @override
  Component build(BuildContext context) {
    return const footer(
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
              href: 'https://github.com/dart-lang',
              target: Target.blank,
              attributes: {
                'rel': 'noopener',
                'title': 'Organização do Dart no GitHub',
              },
              [
                svg([
                  Component.element(
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
                'title': 'Perfil do Dart no Bluesky',
              },
              [
                svg([
                  Component.element(
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
                'title': 'Perfil do Dart no X (Twitter)',
              },
              [
                svg([
                  Component.element(
                    tag: 'use',
                    attributes: {'href': '/assets/img/social/x.svg#x'},
                  ),
                ]),
              ],
            ),
          ]),
        ]),
        div(classes: 'footer-section footer-tray', [
          div(classes: 'footer-licenses', [
            .text(
              'Exceto quando indicado de outra forma, este site está '
              'licenciado sob uma ',
            ),
            a(href: 'https://creativecommons.org/licenses/by/4.0/', [
              .text('Licença Creative Commons Attribution 4.0 International,'),
            ]),
            .text(' e os exemplos de código estão licenciados sob a '),
            a(href: 'https://opensource.org/licenses/BSD-3-Clause', [
              .text('Licença BSD de 3 Cláusulas.'),
            ]),
            p([
              .text(
                'Este é o site em Português Brasileiro (dartbrasil.dev). '
                'O site original em inglês está em ',
              ),
              a(
                href: 'https://dart.dev',
                target: Target.blank,
                attributes: {
                  'rel': 'noopener',
                  'title': 'Site original em inglês',
                },
                [.text('dart.dev')],
              ),
              .text('.'),
            ]),
          ]),
          div(classes: 'footer-utility-links', [
            ul([
              li([
                a(
                  href: '/terms',
                  attributes: {'title': 'Termos de uso'},
                  [.text('Termos')],
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
                  [.text('Privacidade')],
                ),
              ]),
              li([
                a(
                  href: '/security',
                  attributes: {'title': 'Filosofia e práticas de segurança'},
                  [.text('Segurança')],
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
                      'Este site é construído com o '
                      'framework web Jaspr para Dart.',
                },
                [
                  span([JasprBadge.light()]),
                  span([JasprBadge.lightTwoTone()]),
                ],
              ),
            ]),
          ]),
        ]),
      ],
    );
  }
}
