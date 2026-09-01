---
name: awesome-entry
description: Use when adding, moving, removing, or rewriting entries inside the repository's awesome/ Markdown lists. Covers choosing the right awesome file, finding the right section, checking duplicates, matching local formatting, and placing links by topic rather than by raw source type.
---

# Awesome Entry

Use this skill when the user asks to add something to `awesome/`, move an entry between awesome lists, fix categorization, or rewrite an awesome entry description.

## Repository Contract

The awesome root is `awesome/`.

Each file in `awesome/` is a topic-specific curated list. Prefer editing an existing topic file over adding items to a generic list.

## Core Rules

- Choose the narrowest fitting `awesome/*.md` file, not the broadest one.
- Match the local formatting and nesting style of the target file.
- Check for duplicates across the whole repository before adding anything.
- Place the entry by reader value and topic, not only by raw source type.
- If the user corrects the categorization, treat that as the new rule unless it clearly conflicts with the repository structure.
- Claude Code/Cowork-specific skills, plugins, agents, slash commands, hooks, or Anthropic Claude plugin marketplaces belong in `awesome/awesome-ai-claude-code.md`, not in the general `awesome/awesome-ai-skills.md`.

## Source Classification Rule

Classify the source by what it is useful for:

- project / library / tool
- article / guide / tutorial
- collection / catalog / awesome-list
- video / course / lecture
- service / platform / app

Then classify it again by topic:

- AI, OCR, deployment, Symfony, math, OOP, infra, etc.

The topic decides the target file. The source type helps choose the section and wording.

## Section Type Rule

Treat the section's source type as a hard constraint:

- `Статьи` contains articles, blog posts, tutorials published as articles, and research papers.
- `Мануалы` contains manuals, how-to guides, and official documentation intended for task-oriented reading.
- `Справочники` contains links to standalone reference sites, portals, whole wikis, glossaries, and similar lookup resources. Individual articles or pages from those sites belong in `Статьи`.
- `Курсы`, `Лекции`, `Книги`, `Репозитории`, and similar sections contain only the corresponding source type.
- Do not place a source in a mismatched section merely because its topic is relevant. Use another existing section or topic file, or create a small correctly typed subsection when justified.

## Primary Topic Rule

- Classify a source by the primary subject of the complete page, not by an incidental mention, dependency, example, or single subsection.
- A source belongs in a narrow topic category only when that topic is central to its title, introduction, and overall coverage. Otherwise place it under its actual primary topic or omit it from the requested topic set.
- Write the description around the source's primary subject. Do not reframe a secondary fragment as if it were the purpose of the whole source.

## Placement Rule

Prefer this order when choosing where to place an entry:

1. existing specific topic file
2. existing relevant subsection inside that file
3. new small subsection inside that file if clearly justified
4. generic file only if no specific topic file fits

Do not create a new `awesome/*.md` file unless the user explicitly asks for it or the repository already implies that missing topic should exist.

## Tree Structure Rule

Keep every sibling level structurally uniform:

- Keep category names atomic: one category represents one topic. If a label combines independently useful topics with `и`, `and`, `/`, or a similar connector, create separate sibling categories instead (for example, `GPTQ` and `AWQ`, not `GPTQ и AWQ`).
- Never mix leaf entries and category branches under the same parent.
- If a parent has child categories, place all direct entries into the narrowest fitting child category.
- Use `Основное` only for foundational or introductory material about the parent topic. Never use it as a generic catch-all.
- Use `Остальное` for material that belongs to the parent topic but does not fit any specific child category.
- Treat an empty category heading as a branch, not as a leaf.

## Series and Index Rule

Some links are not standalone articles but index pages to a useful series.

- If the page is an overview page for multiple subarticles, mention that in the description when helpful.
- Place it by the practical topic of the series, not by the most academic keyword on the page.
- If the repository already stores subarticles elsewhere, do not duplicate them unless the user asks.

## Duplicate Rule

Before adding an entry:

- search by URL
- search by canonical project or article title
- search nearby sections for alternate wording

If the same item already exists:

- do not add a duplicate
- update or move the existing entry if the user intent is better served that way

## Formatting Rule

Follow the target file's existing style exactly:

- plain link only when the file already uses sparse entries
- title plus short description when the file uses annotated entries
- nested bullets when the file already groups by category

Keep descriptions short and high-signal. Avoid marketing language and filler.

## Description Rule

Write descriptions that help future retrieval:

- what it is
- why it is useful
- what distinguishes it

Prefer concrete traits:

- supports local inference
- converts PDF to Markdown
- compares `vLLM`, `SGLang`, and `KTransformers`
- explains category theory through programming abstractions

Avoid vague descriptions like "useful tool" or "interesting article".

## Browsing Rule

If the link target is unknown from local context, inspect the page first before choosing a list or writing a description.

When classifying technical content, prefer the source itself over third-party summaries.

## Editing Rule

Make the smallest correct change:

- add a single entry if the place is obvious
- move an entry when categorization is wrong
- adjust surrounding section labels only when needed for clarity

Do not reformat unrelated parts of the file.

## Validation

After editing:

1. verify the new entry appears in the intended section
2. verify the repository does not now contain a duplicate of the same item
3. verify no changed parent mixes leaf entries and category branches at the same level
4. verify `Основное` contains only foundational material and uncategorized non-foundational entries are in `Остальное`
5. inspect `git diff` for unintended changes nearby
