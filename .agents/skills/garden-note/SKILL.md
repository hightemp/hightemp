---
name: garden-note
description: Use when adding, organizing, rewriting, or linking notes in the repository's garden/ Zettelkasten. Covers choosing the right garden folder, creating atomic permanent notes, literature/source notes, MOC pages, project notes, and stable note filenames.
---

# Garden Note

Use this skill when the user asks to add a note, save an idea, process a source, create a Zettelkasten note, update a MOC, or organize content inside `garden/`.

## Repository Contract

The garden root is `garden/`. Read `garden/README.md` first if the folder structure or naming convention is unclear.

Current folders:

- `00-inbox/` - quick capture before sorting.
- `10-fleeting/` - rough thoughts and temporary observations.
- `20-literature/` - notes from books, articles, papers, talks, podcasts, videos.
- `30-permanent/` - atomic evergreen notes in the user's own words.
- `40-moc/` - maps of content, indexes, topic hubs, navigation notes.
- `50-sources/` - source cards, bibliographic notes, links, citations.
- `60-projects/` - project-oriented notes that use permanent notes.
- `90-templates/` - reusable note templates.
- `assets/` - images, PDFs, diagrams, attachments.

## File Naming

For atomic notes, use:

```text
YYYYMMDDHHMM-short-title.md
```

Use the current local time when creating the ID. Make the slug short, lowercase, ASCII, and hyphen-separated.

Examples:

```text
202604191530-feedback-loops-in-learning.md
202604191545-rust-release-profile-tradeoffs.md
```

For MOC files, use stable topic names:

```text
garden/40-moc/rust-performance.md
garden/40-moc/ai-agents.md
```

## Placement Rules

- Raw capture from the user, not yet processed: `00-inbox/`.
- Half-formed thought, question, or observation: `10-fleeting/`.
- Notes tied closely to one source: `20-literature/`.
- Source metadata, citation, abstract, and link: `50-sources/`.
- One durable idea written in the user's own words: `30-permanent/`.
- Topic index or navigation page: `40-moc/`.
- Notes serving a concrete project or deliverable: `60-projects/`.

When unsure, prefer `00-inbox/` for capture or ask one concise question if placement materially changes the output.

## Permanent Note Shape

Permanent notes should be atomic: one note, one idea. Prefer concise prose and explicit links.

Use this structure when creating a permanent note:

```markdown
# Title

Коротко: one-sentence summary.

## Смысл

Explain the idea in the user's own words.

## Связи

- [[related-note-id-or-title]]

## Источники

- Source title URL
```

Do not dump long source excerpts into permanent notes. Convert source content into your own words and link to literature/source notes when useful.

## Literature Note Shape

Use literature notes for source-specific extraction:

```markdown
# Source title

Источник: URL or bibliographic reference

## Ключевые идеи

- ...

## Что забрать в permanent notes

- ...

## Цитаты

- Short quote or pointer only.
```

Respect copyright: keep quotations short and prefer paraphrase.

## MOC Shape

MOC is not a tag. It is a hand-curated map or index for a topic.

```markdown
# Topic

## Основное

- [[note-id-title]]

## Подтемы

- [[note-id-title]]

## Вопросы

- ...
```

When adding a permanent note, update an existing relevant MOC if it already exists and the link clearly belongs there. Do not create a new MOC for every note.

## Workflow

1. Identify the note type and destination folder.
2. Check for existing related notes with `rg` to avoid duplicates.
3. Create or update the Markdown file with the smallest useful change.
4. Add links to related notes when obvious.
5. Update a relevant MOC only when it improves navigation.
6. Run `git diff --check -- garden .agents` after edits when practical.
