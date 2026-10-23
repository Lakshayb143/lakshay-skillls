# Skills

Agent skills I use and keep improving. Each one is a folder with a `SKILL.md`
in the open [Agent Skills](https://agentskills.io/specification) format, so the
same files work in Claude Code, Codex, Cursor, Gemini CLI, GitHub Copilot and
other agents that read skills.

| Skill | What it does |
| --- | --- |
| [video-and-animation](skills/video-and-animation/SKILL.md) | Picks the right way to make a video or an animation for the task, then makes it. The choices are HyperFrames, Remotion, an animated SVG, a looping clip for an article, or an interactive figure for a page. |

## Install

### Any agent, from a clone (recommended)

```bash
git clone https://github.com/OWNER/REPO.git ~/skills
~/skills/install.sh
```

The script links every skill into two folders:

- `~/.claude/skills`, for Claude Code;
- `~/.agents/skills`, for Codex and other agents that read that folder.

Because they're links, `git pull` in `~/skills` updates every agent at once.

Other options:

- **Some skills only**: name them, as in `./install.sh video-and-animation`.
- **Copies instead of links**: add `--copy`. This is for Windows without
  symlink rights. Run it again after each pull.
- **Undo**: `./install.sh --remove`.

### Any agent, without a clone

```bash
npx skills add OWNER/REPO -g
```

The [skills CLI](https://github.com/vercel-labs/skills) knows where each agent
keeps its skills, and asks which agents to install for. Update later with
`npx skills update`. It sends anonymous usage data unless
`DISABLE_TELEMETRY=1` is set.

### Claude Code as a plugin

```bash
claude plugin marketplace add OWNER/REPO
claude plugin install video-and-animation@skills
```

Inside a session, `/plugin` does the same. A plugin skill is named
`video-and-animation:video-and-animation`. Update it with
`claude plugin marketplace update skills`.

### Claude apps (web and desktop)

Zip a skill's folder, then upload it under Settings → Capabilities → Skills:

```bash
cd skills && zip -r ../video-and-animation.zip video-and-animation
```

## Add or change a skill

1. Make `skills/<name>/SKILL.md`. Its `name` must match the folder.
2. List it in `.claude-plugin/marketplace.json`.
3. Run `scripts/check.sh`.

`AGENTS.md` has the full rules, so an agent working in this repo follows them
too.

### Keeping personal details out

Skills here are general: no project names, people or accounts. To guard that:

- **The check**: `scripts/check.sh` flags home folder paths and email
  addresses.
- **Your own words**: it also flags any word in a `.private-words` file, one
  per line. Use it for your name, your projects and your clients. The file is
  git-ignored, so the list itself never leaves your machine.
- **Before every commit**: run this once in each clone:

  ```bash
  git config core.hooksPath .githooks
  ```

## License

[MIT](LICENSE)
