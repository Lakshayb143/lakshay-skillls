# Working in this repo

This repo holds reusable agent skills in the open Agent Skills format
(https://agentskills.io/specification). The same files work in Claude Code,
Codex and the other agents that read `SKILL.md`.

## Rules for every skill

- **Keep it general.** A skill must work for anyone, in any project.
  - No project, product, company or client names.
  - No people's names, accounts, email addresses or home folder paths.
  - No colours, fonts or wording that identify one brand.
  - Taste and ways of working are welcome, written as general rules.
  - Rules that belong to one project go in that project's own files, and the
    skill tells the agent to read the project's rules first.
- **Agent-neutral.** Don't name one agent's tools (a specific question box,
  plugin or slash command) as the only way to do something. Say what to do,
  and let each agent use its own tool for it.
- **Layout.** Each skill lives at `skills/<name>/`:
  - `SKILL.md` holds the instructions;
  - long detail goes in `references/`;
  - scripts go in `scripts/`;
  - templates and files go in `assets/`.

  Keep `SKILL.md` under about 500 lines, and point from it to each reference.
- **Frontmatter.**
  - `name` matches the folder: lowercase, single hyphens, at most 64
    characters.
  - `description` is one line, at most 1024 characters. It says what the
    skill does and when to use it.
  - `license: MIT`.
- **Plugin list.** Add every new skill to the `plugins` list in
  `.claude-plugin/marketplace.json`, following the existing entry.
- **No secrets.** No keys, tokens or passwords, ever.

## Before committing

Run `scripts/check.sh`. It checks the frontmatter and the plugin list, and it
looks for anything personal, including the words in the untracked
`.private-words` file. The pre-commit hook runs it once
`git config core.hooksPath .githooks` is set in the clone.

Write commit messages as one or two short lines. Don't push unless asked.
