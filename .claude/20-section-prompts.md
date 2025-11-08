# 20 Complete Section Translation Prompts

Each prompt below is self-contained with all necessary information to translate that section.

---

## **PROMPT 1: Core Pub Documentation - All Pub Docs & Commands**

```
Translate Section 1: Complete Pub Documentation to PT-BR

AGENT LOCATION: `.claude/agents/dart-docs-translator.md`

FILES TO TRANSLATE (25 files total):

Core Pub Documentation (12 files):
1. src/content/tools/pub/index.md
2. src/content/tools/pub/packages.md
3. src/content/tools/pub/dependencies.md
4. src/content/tools/pub/pubspec.md
5. src/content/tools/pub/package-layout.md
6. src/content/tools/pub/versioning.md
7. src/content/tools/pub/publishing.md
8. src/content/tools/pub/create-packages.md
9. src/content/tools/pub/writing-package-pages.md
10. src/content/tools/pub/verified-publishers.md
11. src/content/tools/pub/workspaces.md
12. src/content/tools/pub/custom-package-repositories.md

Pub Commands (10 files - skip already done):
13. src/content/tools/pub/cmd/index.md
14. src/content/tools/pub/cmd/pub-add.md
15. src/content/tools/pub/cmd/pub-get.md
16. src/content/tools/pub/cmd/pub-upgrade.md
17. src/content/tools/pub/cmd/pub-downgrade.md
18. src/content/tools/pub/cmd/pub-deps.md
19. src/content/tools/pub/cmd/pub-outdated.md
20. src/content/tools/pub/cmd/pub-cache.md
21. src/content/tools/pub/cmd/pub-global.md

Pub Advanced (3 files):
22. src/content/tools/pub/environment-variables.md
23. src/content/tools/pub/automated-publishing.md

SKIP (already done): pub-bump, pub-lish, pub-remove, pub-token, pub-unpack, private-files, troubleshoot, security-advisories

TRANSLATION REQUIREMENTS:
- Add `ia-translate: true` to YAML frontmatter
- Translate `title` and `description` to PT-BR
- Translate all prose to natural Brazilian Portuguese
- Keep in English: Dart, pub, SDK, packages, pubspec, dependencies, pub.dev, Git, hosted, path, transitive, semantic versioning, environment variables, CI/CD, tokens, credentials, cache
- Preserve: code blocks, YAML, JSON, commands, file paths, URLs, package names

COMMIT STRATEGY:
Batch commit: "translate: Section 1 - Complete Pub Documentation (25 files) to PT-BR"

AFTER COMPLETION:
- Update TRANSLATION_PROGRESS.md (+25 files)
- Update .claude/tools-translation-plan.md (Section 1 complete)
- Push all changes

PRIORITY: CRITICAL
```

---

## **PROMPT 2: Diagnostic Errors - abi, abstract, address, always (35 files)**

```
Translate Section 2: Diagnostic Errors (abi, abstract, address, always) to PT-BR

AGENT LOCATION: `.claude/agents/dart-docs-translator.md`

FILES TO TRANSLATE (~35 files):
Find all files matching patterns:
- src/content/tools/diagnostics/abi_*.md
- src/content/tools/diagnostics/abstract_*.md
- src/content/tools/diagnostics/address_*.md
- src/content/tools/diagnostics/always_*.md

DISCOVERY COMMAND:
```bash
find src/content/tools/diagnostics -name "abi_*.md" -o -name "abstract_*.md" -o -name "address_*.md" -o -name "always_*.md" | sort | head -35
```

TRANSLATION REQUIREMENTS:
- Add `ia-translate: true` to frontmatter
- Translate `description` to PT-BR
- Keep `title` (error name) in English
- Translate error explanations to natural PT-BR
- Keep in English: all Dart keywords, error codes, class names, method names, ABI, abstract, sealed, interface, mixin
- Preserve: code blocks, error messages, file paths

COMMIT STRATEGY:
Batch commit: "translate: Section 2 - Diagnostic Errors abi/abstract/address/always (~35 files) to PT-BR"

AFTER COMPLETION:
- Update TRANSLATION_PROGRESS.md (+~35 files)
- Update .claude/tools-translation-plan.md (Section 2 complete)
- Push all changes

PRIORITY: MEDIUM
```

---

## **PROMPT 3: Diagnostic Errors - ambiguous, annotate, annotation (35 files)**

```
Translate Section 3: Diagnostic Errors (ambiguous, annotate, annotation) to PT-BR

AGENT LOCATION: `.claude/agents/dart-docs-translator.md`

FILES TO TRANSLATE (~35 files):
Find all files matching patterns:
- src/content/tools/diagnostics/ambiguous_*.md
- src/content/tools/diagnostics/annotate_*.md
- src/content/tools/diagnostics/annotation_*.md

DISCOVERY COMMAND:
```bash
find src/content/tools/diagnostics -name "ambiguous_*.md" -o -name "annotate_*.md" -o -name "annotation_*.md" | sort | head -35
```

TRANSLATION REQUIREMENTS:
- Add `ia-translate: true` to frontmatter
- Translate `description` to PT-BR
- Keep `title` (error name) in English
- Translate error explanations to natural PT-BR
- Keep in English: annotation, metadata, @override, @deprecated, ambiguous, import, export
- Preserve: code blocks, annotations, error messages

COMMIT STRATEGY:
Batch commit: "translate: Section 3 - Diagnostic Errors ambiguous/annotate/annotation (~35 files) to PT-BR"

AFTER COMPLETION:
- Update TRANSLATION_PROGRESS.md (+~35 files)
- Update .claude/tools-translation-plan.md (Section 3 complete)
- Push all changes

PRIORITY: MEDIUM
```

---

## **PROMPT 4: Diagnostic Errors - argument, assert, asset (35 files)**

```
Translate Section 4: Diagnostic Errors (argument, assert, asset) to PT-BR

AGENT LOCATION: `.claude/agents/dart-docs-translator.md`

FILES TO TRANSLATE (~35 files):
Find all files matching patterns:
- src/content/tools/diagnostics/argument_*.md
- src/content/tools/diagnostics/assert_*.md
- src/content/tools/diagnostics/asset_*.md

DISCOVERY COMMAND:
```bash
find src/content/tools/diagnostics -name "argument_*.md" -o -name "assert_*.md" -o -name "asset_*.md" | sort | head -35
```

TRANSLATION REQUIREMENTS:
- Add `ia-translate: true` to frontmatter
- Translate `description` to PT-BR
- Keep `title` (error name) in English
- Translate error explanations to natural PT-BR
- Keep in English: argument, parameter, assert, asset, pubspec, type, assignable
- Preserve: code blocks, error messages, file paths

COMMIT STRATEGY:
Batch commit: "translate: Section 4 - Diagnostic Errors argument/assert/asset (~35 files) to PT-BR"

AFTER COMPLETION:
- Update TRANSLATION_PROGRESS.md (+~35 files)
- Update .claude/tools-translation-plan.md (Section 4 complete)
- Push all changes

PRIORITY: MEDIUM
```

---

## **PROMPT 5: Diagnostic Errors - assignment, async, avoid (35 files)**

```
Translate Section 5: Diagnostic Errors (assignment, async, avoid) to PT-BR

AGENT LOCATION: `.claude/agents/dart-docs-translator.md`

FILES TO TRANSLATE (~35 files):
Find all files matching patterns:
- src/content/tools/diagnostics/assignment_*.md
- src/content/tools/diagnostics/async_*.md
- src/content/tools/diagnostics/avoid_*.md

DISCOVERY COMMAND:
```bash
find src/content/tools/diagnostics -name "assignment_*.md" -o -name "async_*.md" -o -name "avoid_*.md" | sort | head -35
```

TRANSLATION REQUIREMENTS:
- Add `ia-translate: true` to frontmatter
- Translate `description` to PT-BR
- Keep `title` (error name) in English
- Translate error explanations to natural PT-BR
- Keep in English: assignment, async, await, Future, Stream, const, final, avoid (lint rules)
- Preserve: code blocks, error messages, async/await syntax

COMMIT STRATEGY:
Batch commit: "translate: Section 5 - Diagnostic Errors assignment/async/avoid (~35 files) to PT-BR"

AFTER COMPLETION:
- Update TRANSLATION_PROGRESS.md (+~35 files)
- Update .claude/tools-translation-plan.md (Section 5 complete)
- Push all changes

PRIORITY: MEDIUM
```

---

## **PROMPT 6: Diagnostic Errors - await, body, break, built_in (35 files)**

```
Translate Section 6: Diagnostic Errors (await, body, break, built_in) to PT-BR

AGENT LOCATION: `.claude/agents/dart-docs-translator.md`

FILES TO TRANSLATE (~35 files):
Find all files matching patterns:
- src/content/tools/diagnostics/await_*.md
- src/content/tools/diagnostics/body_*.md
- src/content/tools/diagnostics/break_*.md
- src/content/tools/diagnostics/built_in_*.md

DISCOVERY COMMAND:
```bash
find src/content/tools/diagnostics -name "await_*.md" -o -name "body_*.md" -o -name "break_*.md" -o -name "built_in_*.md" | sort | head -35
```

TRANSLATION REQUIREMENTS:
- Add `ia-translate: true` to frontmatter
- Translate `description` to PT-BR
- Keep `title` (error name) in English
- Translate error explanations to natural PT-BR
- Keep in English: await, async, body, break, continue, built-in, identifier, type
- Preserve: code blocks, error messages, control flow syntax

COMMIT STRATEGY:
Batch commit: "translate: Section 6 - Diagnostic Errors await/body/break/built_in (~35 files) to PT-BR"

AFTER COMPLETION:
- Update TRANSLATION_PROGRESS.md (+~35 files)
- Update .claude/tools-translation-plan.md (Section 6 complete)
- Push all changes

PRIORITY: MEDIUM
```

---

## **PROMPT 7: Diagnostic Errors - camel_case, cancel, cast (35 files)**

```
Translate Section 7: Diagnostic Errors (camel_case, cancel, cast) to PT-BR

AGENT LOCATION: `.claude/agents/dart-docs-translator.md`

FILES TO TRANSLATE (~35 files):
Find all files matching patterns:
- src/content/tools/diagnostics/camel_case_*.md
- src/content/tools/diagnostics/cancel_*.md
- src/content/tools/diagnostics/cast_*.md

DISCOVERY COMMAND:
```bash
find src/content/tools/diagnostics -name "camel_case_*.md" -o -name "cancel_*.md" -o -name "cast_*.md" | sort | head -35
```

TRANSLATION REQUIREMENTS:
- Add `ia-translate: true` to frontmatter
- Translate `description` to PT-BR
- Keep `title` (error name) in English
- Translate error explanations to natural PT-BR
- Keep in English: camelCase, PascalCase, snake_case, cast, type, Sink, Stream
- Preserve: code blocks, naming examples, error messages

COMMIT STRATEGY:
Batch commit: "translate: Section 7 - Diagnostic Errors camel_case/cancel/cast (~35 files) to PT-BR"

AFTER COMPLETION:
- Update TRANSLATION_PROGRESS.md (+~35 files)
- Update .claude/tools-translation-plan.md (Section 7 complete)
- Push all changes

PRIORITY: LOW-MEDIUM
```

---

## **PROMPT 8: Diagnostic Errors - class, close, combinators (35 files)**

```
Translate Section 8: Diagnostic Errors (class, close, combinators) to PT-BR

AGENT LOCATION: `.claude/agents/dart-docs-translator.md`

FILES TO TRANSLATE (~35 files):
Find all files matching patterns:
- src/content/tools/diagnostics/class_*.md
- src/content/tools/diagnostics/close_*.md
- src/content/tools/diagnostics/combinators_*.md

DISCOVERY COMMAND:
```bash
find src/content/tools/diagnostics -name "class_*.md" -o -name "close_*.md" -o -name "combinators_*.md" | sort | head -35
```

TRANSLATION REQUIREMENTS:
- Add `ia-translate: true` to frontmatter
- Translate `description` to PT-BR
- Keep `title` (error name) in English
- Translate error explanations to natural PT-BR
- Keep in English: class, interface, mixin, close, Sink, import combinators, show, hide
- Preserve: code blocks, class definitions, error messages

COMMIT STRATEGY:
Batch commit: "translate: Section 8 - Diagnostic Errors class/close/combinators (~35 files) to PT-BR"

AFTER COMPLETION:
- Update TRANSLATION_PROGRESS.md (+~35 files)
- Update .claude/tools-translation-plan.md (Section 8 complete)
- Push all changes

PRIORITY: LOW-MEDIUM
```

---

## **PROMPT 9: Diagnostic Errors - const, constructor, continue (35 files)**

```
Translate Section 9: Diagnostic Errors (const, constructor, continue) to PT-BR

AGENT LOCATION: `.claude/agents/dart-docs-translator.md`

FILES TO TRANSLATE (~35 files):
Find all files matching patterns:
- src/content/tools/diagnostics/const_*.md
- src/content/tools/diagnostics/constructor_*.md
- src/content/tools/diagnostics/continue_*.md

DISCOVERY COMMAND:
```bash
find src/content/tools/diagnostics -name "const_*.md" -o -name "constructor_*.md" -o -name "continue_*.md" | sort | head -35
```

TRANSLATION REQUIREMENTS:
- Add `ia-translate: true` to frontmatter
- Translate `description` to PT-BR
- Keep `title` (error name) in English
- Translate error explanations to natural PT-BR
- Keep in English: const, constructor, factory, redirecting, generative, continue, break
- Preserve: code blocks, constructor syntax, error messages

COMMIT STRATEGY:
Batch commit: "translate: Section 9 - Diagnostic Errors const/constructor/continue (~35 files) to PT-BR"

AFTER COMPLETION:
- Update TRANSLATION_PROGRESS.md (+~35 files)
- Update .claude/tools-translation-plan.md (Section 9 complete)
- Push all changes

PRIORITY: LOW-MEDIUM
```

---

## **PROMPT 10: Diagnostic Errors - dead, default, deprecated, duplicate (35 files)**

```
Translate Section 10: Diagnostic Errors (dead, default, deprecated, duplicate) to PT-BR

AGENT LOCATION: `.claude/agents/dart-docs-translator.md`

FILES TO TRANSLATE (~35 files):
Find all files matching patterns:
- src/content/tools/diagnostics/dead_*.md
- src/content/tools/diagnostics/default_*.md
- src/content/tools/diagnostics/deprecated_*.md
- src/content/tools/diagnostics/duplicate_*.md

DISCOVERY COMMAND:
```bash
find src/content/tools/diagnostics -name "dead_*.md" -o -name "default_*.md" -o -name "deprecated_*.md" -o -name "duplicate_*.md" | sort | head -35
```

TRANSLATION REQUIREMENTS:
- Add `ia-translate: true` to frontmatter
- Translate `description` to PT-BR
- Keep `title` (error name) in English
- Translate error explanations to natural PT-BR
- Keep in English: dead code, default, deprecated, @deprecated, duplicate, identifier
- Preserve: code blocks, deprecation annotations, error messages

COMMIT STRATEGY:
Batch commit: "translate: Section 10 - Diagnostic Errors dead/default/deprecated/duplicate (~35 files) to PT-BR"

AFTER COMPLETION:
- Update TRANSLATION_PROGRESS.md (+~35 files)
- Update .claude/tools-translation-plan.md (Section 10 complete)
- Push all changes

PRIORITY: LOW-MEDIUM
```

---

## **PROMPT 11: Diagnostic Errors - empty, equal, expression, export (35 files)**

```
Translate Section 11: Diagnostic Errors (empty, equal, expression, export) to PT-BR

AGENT LOCATION: `.claude/agents/dart-docs-translator.md`

FILES TO TRANSLATE (~35 files):
Find all files matching patterns:
- src/content/tools/diagnostics/empty_*.md
- src/content/tools/diagnostics/equal_*.md
- src/content/tools/diagnostics/expression_*.md
- src/content/tools/diagnostics/export_*.md

DISCOVERY COMMAND:
```bash
find src/content/tools/diagnostics -name "empty_*.md" -o -name "equal_*.md" -o -name "expression_*.md" -o -name "export_*.md" | sort | head -35
```

TRANSLATION REQUIREMENTS:
- Add `ia-translate: true` to frontmatter
- Translate `description` to PT-BR
- Keep `title` (error name) in English
- Translate error explanations to natural PT-BR
- Keep in English: empty, catch, statements, equal, ==, expression, export, library
- Preserve: code blocks, operators, error messages

COMMIT STRATEGY:
Batch commit: "translate: Section 11 - Diagnostic Errors empty/equal/expression/export (~35 files) to PT-BR"

AFTER COMPLETION:
- Update TRANSLATION_PROGRESS.md (+~35 files)
- Update .claude/tools-translation-plan.md (Section 11 complete)
- Push all changes

PRIORITY: LOW-MEDIUM
```

---

## **PROMPT 12: Diagnostic Errors - extends, extension, final, for, function (35 files)**

```
Translate Section 12: Diagnostic Errors (extends, extension, final, for, function) to PT-BR

AGENT LOCATION: `.claude/agents/dart-docs-translator.md`

FILES TO TRANSLATE (~35 files):
Find all files matching patterns:
- src/content/tools/diagnostics/extends_*.md
- src/content/tools/diagnostics/extension_*.md
- src/content/tools/diagnostics/final_*.md
- src/content/tools/diagnostics/for_*.md
- src/content/tools/diagnostics/function_*.md

DISCOVERY COMMAND:
```bash
find src/content/tools/diagnostics -name "extends_*.md" -o -name "extension_*.md" -o -name "final_*.md" -o -name "for_*.md" -o -name "function_*.md" | sort | head -35
```

TRANSLATION REQUIREMENTS:
- Add `ia-translate: true` to frontmatter
- Translate `description` to PT-BR
- Keep `title` (error name) in English
- Translate error explanations to natural PT-BR
- Keep in English: extends, extension, final, const, for, for-in, function, typedef
- Preserve: code blocks, inheritance syntax, error messages

COMMIT STRATEGY:
Batch commit: "translate: Section 12 - Diagnostic Errors extends/extension/final/for/function (~35 files) to PT-BR"

AFTER COMPLETION:
- Update TRANSLATION_PROGRESS.md (+~35 files)
- Update .claude/tools-translation-plan.md (Section 12 complete)
- Push all changes

PRIORITY: LOW-MEDIUM
```

---

## **PROMPT 13: Diagnostic Errors - generic, getter, hash, if, illegal (35 files)**

```
Translate Section 13: Diagnostic Errors (generic, getter, hash, if, illegal) to PT-BR

AGENT LOCATION: `.claude/agents/dart-docs-translator.md`

FILES TO TRANSLATE (~35 files):
Find all files matching patterns:
- src/content/tools/diagnostics/generic_*.md
- src/content/tools/diagnostics/getter_*.md
- src/content/tools/diagnostics/hash_*.md
- src/content/tools/diagnostics/if_*.md
- src/content/tools/diagnostics/illegal_*.md

DISCOVERY COMMAND:
```bash
find src/content/tools/diagnostics -name "generic_*.md" -o -name "getter_*.md" -o -name "hash_*.md" -o -name "if_*.md" -o -name "illegal_*.md" | sort | head -35
```

TRANSLATION REQUIREMENTS:
- Add `ia-translate: true` to frontmatter
- Translate `description` to PT-BR
- Keep `title` (error name) in English
- Translate error explanations to natural PT-BR
- Keep in English: generic, type parameter, getter, setter, hashCode, if, else, illegal
- Preserve: code blocks, generic syntax, error messages

COMMIT STRATEGY:
Batch commit: "translate: Section 13 - Diagnostic Errors generic/getter/hash/if/illegal (~35 files) to PT-BR"

AFTER COMPLETION:
- Update TRANSLATION_PROGRESS.md (+~35 files)
- Update .claude/tools-translation-plan.md (Section 13 complete)
- Push all changes

PRIORITY: LOW-MEDIUM
```

---

## **PROMPT 14: Diagnostic Errors - implements, import, invalid (35 files)**

```
Translate Section 14: Diagnostic Errors (implements, import, invalid) to PT-BR

AGENT LOCATION: `.claude/agents/dart-docs-translator.md`

FILES TO TRANSLATE (~35 files):
Find all files matching patterns:
- src/content/tools/diagnostics/implements_*.md
- src/content/tools/diagnostics/import_*.md
- src/content/tools/diagnostics/invalid_*.md

DISCOVERY COMMAND:
```bash
find src/content/tools/diagnostics -name "implements_*.md" -o -name "import_*.md" -o -name "invalid_*.md" | sort | head -35
```

TRANSLATION REQUIREMENTS:
- Add `ia-translate: true` to frontmatter
- Translate `description` to PT-BR
- Keep `title` (error name) in English
- Translate error explanations to natural PT-BR
- Keep in English: implements, interface, import, library, package, invalid, override
- Preserve: code blocks, import statements, error messages

COMMIT STRATEGY:
Batch commit: "translate: Section 14 - Diagnostic Errors implements/import/invalid (~35 files) to PT-BR"

AFTER COMPLETION:
- Update TRANSLATION_PROGRESS.md (+~35 files)
- Update .claude/tools-translation-plan.md (Section 14 complete)
- Push all changes

PRIORITY: LOW-MEDIUM
```

---

## **PROMPT 15: Diagnostic Errors - late, library, list, literal (35 files)**

```
Translate Section 15: Diagnostic Errors (late, library, list, literal) to PT-BR

AGENT LOCATION: `.claude/agents/dart-docs-translator.md`

FILES TO TRANSLATE (~35 files):
Find all files matching patterns:
- src/content/tools/diagnostics/late_*.md
- src/content/tools/diagnostics/library_*.md
- src/content/tools/diagnostics/list_*.md
- src/content/tools/diagnostics/literal_*.md

DISCOVERY COMMAND:
```bash
find src/content/tools/diagnostics -name "late_*.md" -o -name "library_*.md" -o -name "list_*.md" -o -name "literal_*.md" | sort | head -35
```

TRANSLATION REQUIREMENTS:
- Add `ia-translate: true` to frontmatter
- Translate `description` to PT-BR
- Keep `title` (error name) in English
- Translate error explanations to natural PT-BR
- Keep in English: late, library, part, list, literal, collection, Set, Map
- Preserve: code blocks, late syntax, error messages

COMMIT STRATEGY:
Batch commit: "translate: Section 15 - Diagnostic Errors late/library/list/literal (~35 files) to PT-BR"

AFTER COMPLETION:
- Update TRANSLATION_PROGRESS.md (+~35 files)
- Update .claude/tools-translation-plan.md (Section 15 complete)
- Push all changes

PRIORITY: LOW
```

---

## **PROMPT 16: Diagnostic Errors - main, map, member, method, mixin, missing (35 files)**

```
Translate Section 16: Diagnostic Errors (main, map, member, method, mixin, missing) to PT-BR

AGENT LOCATION: `.claude/agents/dart-docs-translator.md`

FILES TO TRANSLATE (~35 files):
Find all files matching patterns:
- src/content/tools/diagnostics/main_*.md
- src/content/tools/diagnostics/map_*.md
- src/content/tools/diagnostics/member_*.md
- src/content/tools/diagnostics/method_*.md
- src/content/tools/diagnostics/mixin_*.md
- src/content/tools/diagnostics/missing_*.md

DISCOVERY COMMAND:
```bash
find src/content/tools/diagnostics -name "main_*.md" -o -name "map_*.md" -o -name "member_*.md" -o -name "method_*.md" -o -name "mixin_*.md" -o -name "missing_*.md" | sort | head -35
```

TRANSLATION REQUIREMENTS:
- Add `ia-translate: true` to frontmatter
- Translate `description` to PT-BR
- Keep `title` (error name) in English
- Translate error explanations to natural PT-BR
- Keep in English: main, Map, member, method, mixin, with, on, missing, required
- Preserve: code blocks, mixin syntax, error messages

COMMIT STRATEGY:
Batch commit: "translate: Section 16 - Diagnostic Errors main/map/member/method/mixin/missing (~35 files) to PT-BR"

AFTER COMPLETION:
- Update TRANSLATION_PROGRESS.md (+~35 files)
- Update .claude/tools-translation-plan.md (Section 16 complete)
- Push all changes

PRIORITY: LOW
```

---

## **PROMPT 17: Diagnostic Errors - native, new, no, non, not, null (35 files)**

```
Translate Section 17: Diagnostic Errors (native, new, no, non, not, null) to PT-BR

AGENT LOCATION: `.claude/agents/dart-docs-translator.md`

FILES TO TRANSLATE (~35 files):
Find all files matching patterns:
- src/content/tools/diagnostics/native_*.md
- src/content/tools/diagnostics/new_*.md
- src/content/tools/diagnostics/no_*.md
- src/content/tools/diagnostics/non_*.md
- src/content/tools/diagnostics/not_*.md
- src/content/tools/diagnostics/null_*.md

DISCOVERY COMMAND:
```bash
find src/content/tools/diagnostics -name "native_*.md" -o -name "new_*.md" -o -name "no_*.md" -o -name "non_*.md" -o -name "not_*.md" -o -name "null_*.md" | sort | head -35
```

TRANSLATION REQUIREMENTS:
- Add `ia-translate: true` to frontmatter
- Translate `description` to PT-BR
- Keep `title` (error name) in English
- Translate error explanations to natural PT-BR
- Keep in English: native, new, null, nullable, non-nullable, null safety, ?, !, late
- Preserve: code blocks, null safety syntax, error messages

COMMIT STRATEGY:
Batch commit: "translate: Section 17 - Diagnostic Errors native/new/no/non/not/null (~35 files) to PT-BR"

AFTER COMPLETION:
- Update TRANSLATION_PROGRESS.md (+~35 files)
- Update .claude/tools-translation-plan.md (Section 17 complete)
- Push all changes

PRIORITY: LOW
```

---

## **PROMPT 18: Diagnostic Errors - override, package, parameter, part, pattern (35 files)**

```
Translate Section 18: Diagnostic Errors (override, package, parameter, part, pattern) to PT-BR

AGENT LOCATION: `.claude/agents/dart-docs-translator.md`

FILES TO TRANSLATE (~35 files):
Find all files matching patterns:
- src/content/tools/diagnostics/override_*.md
- src/content/tools/diagnostics/package_*.md
- src/content/tools/diagnostics/parameter_*.md
- src/content/tools/diagnostics/part_*.md
- src/content/tools/diagnostics/pattern_*.md

DISCOVERY COMMAND:
```bash
find src/content/tools/diagnostics -name "override_*.md" -o -name "package_*.md" -o -name "parameter_*.md" -o -name "part_*.md" -o -name "pattern_*.md" | sort | head -35
```

TRANSLATION REQUIREMENTS:
- Add `ia-translate: true` to frontmatter
- Translate `description` to PT-BR
- Keep `title` (error name) in English
- Translate error explanations to natural PT-BR
- Keep in English: @override, package, parameter, positional, named, required, optional, part, part of, pattern matching
- Preserve: code blocks, parameter syntax, error messages

COMMIT STRATEGY:
Batch commit: "translate: Section 18 - Diagnostic Errors override/package/parameter/part/pattern (~35 files) to PT-BR"

AFTER COMPLETION:
- Update TRANSLATION_PROGRESS.md (+~35 files)
- Update .claude/tools-translation-plan.md (Section 18 complete)
- Push all changes

PRIORITY: LOW
```

---

## **PROMPT 19: Diagnostic Errors - prefer, private, record, recursive, return (35 files)**

```
Translate Section 19: Diagnostic Errors (prefer, private, record, recursive, return) to PT-BR

AGENT LOCATION: `.claude/agents/dart-docs-translator.md`

FILES TO TRANSLATE (~35 files):
Find all files matching patterns:
- src/content/tools/diagnostics/prefer_*.md
- src/content/tools/diagnostics/private_*.md
- src/content/tools/diagnostics/record_*.md
- src/content/tools/diagnostics/recursive_*.md
- src/content/tools/diagnostics/return_*.md

DISCOVERY COMMAND:
```bash
find src/content/tools/diagnostics -name "prefer_*.md" -o -name "private_*.md" -o -name "record_*.md" -o -name "recursive_*.md" -o -name "return_*.md" | sort | head -35
```

TRANSLATION REQUIREMENTS:
- Add `ia-translate: true` to frontmatter
- Translate `description` to PT-BR
- Keep `title` (error name) in English
- Translate error explanations to natural PT-BR
- Keep in English: prefer (lint rules), private, _, record, recursive, return, void
- Preserve: code blocks, record syntax, error messages

COMMIT STRATEGY:
Batch commit: "translate: Section 19 - Diagnostic Errors prefer/private/record/recursive/return (~35 files) to PT-BR"

AFTER COMPLETION:
- Update TRANSLATION_PROGRESS.md (+~35 files)
- Update .claude/tools-translation-plan.md (Section 19 complete)
- Push all changes

PRIORITY: LOW
```

---

## **PROMPT 20: Diagnostic Errors - sealed, static, super, switch, type, unused, variable, void, yield (35 files)**

```
Translate Section 20: Diagnostic Errors (sealed through yield - Final Section) to PT-BR

AGENT LOCATION: `.claude/agents/dart-docs-translator.md`

FILES TO TRANSLATE (~35 files):
Find all files matching patterns:
- src/content/tools/diagnostics/sealed_*.md
- src/content/tools/diagnostics/setter_*.md
- src/content/tools/diagnostics/static_*.md
- src/content/tools/diagnostics/super_*.md
- src/content/tools/diagnostics/switch_*.md
- src/content/tools/diagnostics/throw_*.md
- src/content/tools/diagnostics/type_*.md
- src/content/tools/diagnostics/unchecked_*.md
- src/content/tools/diagnostics/undefined_*.md
- src/content/tools/diagnostics/unused_*.md
- src/content/tools/diagnostics/uri_*.md
- src/content/tools/diagnostics/use_*.md
- src/content/tools/diagnostics/variable_*.md
- src/content/tools/diagnostics/void_*.md
- src/content/tools/diagnostics/wrong_*.md
- src/content/tools/diagnostics/yield_*.md

DISCOVERY COMMAND:
```bash
find src/content/tools/diagnostics \( -name "sealed_*.md" -o -name "setter_*.md" -o -name "static_*.md" -o -name "super_*.md" -o -name "switch_*.md" -o -name "throw_*.md" -o -name "type_*.md" -o -name "unchecked_*.md" -o -name "undefined_*.md" -o -name "unused_*.md" -o -name "uri_*.md" -o -name "use_*.md" -o -name "variable_*.md" -o -name "void_*.md" -o -name "wrong_*.md" -o -name "yield_*.md" \) | sort | head -35
```

TRANSLATION REQUIREMENTS:
- Add `ia-translate: true` to frontmatter
- Translate `description` to PT-BR
- Keep `title` (error name) in English
- Translate error explanations to natural PT-BR
- Keep in English: sealed, static, super, switch, case, type, unused, variable, void, yield, async*, sync*
- Preserve: code blocks, all Dart syntax, error messages

COMMIT STRATEGY:
Batch commit: "translate: Section 20 - Diagnostic Errors sealed through yield (FINAL ~35 files) to PT-BR"

AFTER COMPLETION:
- Update TRANSLATION_PROGRESS.md (+~35 files, TOTAL ~792 files!)
- Update .claude/tools-translation-plan.md (Section 20 COMPLETE - ALL TOOLS DONE!)
- Push all changes
- CELEBRATE! 🎉 All Tools documentation is now 100% translated!

PRIORITY: LOW (Final section!)
```

---

## Quick Reference

| Section | Topic | Files | Priority |
|---------|-------|-------|----------|
| 1 | Complete Pub Docs | 25 | CRITICAL |
| 2 | abi, abstract, address, always | 35 | MEDIUM |
| 3 | ambiguous, annotate, annotation | 35 | MEDIUM |
| 4 | argument, assert, asset | 35 | MEDIUM |
| 5 | assignment, async, avoid | 35 | MEDIUM |
| 6 | await, body, break, built_in | 35 | MEDIUM |
| 7 | camel_case, cancel, cast | 35 | LOW-MED |
| 8 | class, close, combinators | 35 | LOW-MED |
| 9 | const, constructor, continue | 35 | LOW-MED |
| 10 | dead, default, deprecated, duplicate | 35 | LOW-MED |
| 11 | empty, equal, expression, export | 35 | LOW-MED |
| 12 | extends, extension, final, for, function | 35 | LOW-MED |
| 13 | generic, getter, hash, if, illegal | 35 | LOW-MED |
| 14 | implements, import, invalid | 35 | LOW-MED |
| 15 | late, library, list, literal | 35 | LOW |
| 16 | main, map, member, method, mixin, missing | 35 | LOW |
| 17 | native, new, no, non, not, null | 35 | LOW |
| 18 | override, package, parameter, part, pattern | 35 | LOW |
| 19 | prefer, private, record, recursive, return | 35 | LOW |
| 20 | sealed→yield (final) | 35 | LOW |
| **TOTAL** | **All Tools** | **~700** | **Mixed** |
