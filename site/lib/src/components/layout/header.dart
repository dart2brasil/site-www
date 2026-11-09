// Copyright (c) 2025, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_content/jaspr_content.dart';

import '../../util.dart';
import '../../utils/active_nav.dart';
import '../common/material_icon.dart';
import 'menu_toggle.dart';
import 'site_switcher.dart';
import 'theme_switcher.dart';

/// The site-wide top navigation bar.
class DashHeader extends StatelessComponent {
  const DashHeader({super.key});

  @override
  Component build(BuildContext context) {
    final pageUrlPath = context.page.url;
    final layout = context.page.data.page['layout'];
    final activeEntry = activeNavEntry(pageUrlPath);

    final isBlog = activeEntry == ActiveNavEntry.blog;
    final classes = [
      if (!isBlog) 'always-dark-mode',
      if (isBlog) 'variant-gray',
    ].toClasses;

    return header(id: 'site-header', classes: classes, [
      nav(classes: 'navbar', [
        span(id: 'site-primary-logo', classes: 'site-wordmark', [
          const a(
            href: '/',
            attributes: {
              'aria-label': 'Ir para a página inicial do Dart',
              'title': 'Ir para a página inicial do Dart',
            },
            [
              img(
                src: '/assets/img/logo/dart-192.svg',
                alt: 'Dart logo',
                attributes: {'width': '192'},
              ),
              span(
                classes: 'name',
                attributes: {'translate': 'no'},
                [.text('Dart')],
              ),
            ],
          ),
          ?switch (activeEntry) {
            ActiveNavEntry.docs => const a(
              href: '/docs',
              classes: 'subtype',
              attributes: {'translate': 'no'},
              [.text('Documentação')],
            ),
            ActiveNavEntry.blog => const a(
              href: '/blog',
              classes: 'subtype',
              attributes: {'translate': 'no'},
              [.text('Blog')],
            ),
            ActiveNavEntry.learn => const a(
              href: '/learn',
              classes: 'subtype',
              attributes: {'translate': 'no'},
              [.text('Aprenda')],
            ),
            _ => null,
          },
        ]),
        ul(classes: 'nav-items', [
          li([
            a(
              href: '/overview',
              classes: [
                'nav-link',
                if (activeEntry == ActiveNavEntry.overview) 'active',
              ].toClasses,
              [const .text('Visão Geral')],
            ),
          ]),
          li([
            a(
              href: '/docs',
              classes: [
                'nav-link',
                if (activeEntry == ActiveNavEntry.docs) 'active',
              ].toClasses,
              [
                const span([.text('Documentação')]),
              ],
            ),
          ]),
          li([
            a(
              href: '/blog',
              classes: [
                'nav-link',
                if (activeEntry == ActiveNavEntry.blog) 'active',
              ].toClasses,
              [
                const span([.text('Blog')]),
              ],
            ),
          ]),
          li([
            a(
              href: '/community',
              classes: [
                'nav-link',
                if (activeEntry == ActiveNavEntry.community) 'active',
              ].toClasses,
              [const .text('Comunidade')],
            ),
          ]),
          li([
            a(
              href: '/learn',
              classes: [
                'nav-link',
                if (activeEntry == ActiveNavEntry.learn) 'active',
              ].toClasses,
              [const .text('Aprenda')],
            ),
          ]),
          const li([
            a(
              href: '/#try-dart',
              classes: 'nav-link',
              [
                .text('Experimente Dart'),
              ],
            ),
          ]),
          li([
            a(
              href: '/get-dart',
              classes: [
                'nav-link',
                if (activeEntry == ActiveNavEntry.getDart) 'active',
              ].toClasses,
              [const .text('Obter Dart')],
            ),
          ]),
        ]),

        div(
          classes: 'navbar-contents',
          [
            const form(
              action: '/search/',
              id: 'header-search',
              [
                input(
                  classes: 'search-field',
                  type: InputType.search,
                  name: 'q',
                  id: 'q',
                  attributes: {
                    'autocomplete': 'off',
                    'placeholder': 'Pesquisar',
                    'aria-label': 'Pesquisar',
                  },
                ),
              ],
            ),
            const a(
              id: 'fallback-search-button',
              classes: 'icon-button',
              href: '/search',
              attributes: {
                'aria-label': 'Ir para a página de pesquisa do site.',
                'title': 'Ir para a página de pesquisa do site.',
              },
              [
                MaterialIcon('search'),
              ],
            ),

            if (layout != 'homepage') const ThemeSwitcher(),
            const SiteSwitcher(),
            const MenuToggle(),
          ],
        ),
      ]),
    ]);
  }
}
