# lijianrun/tap

Homebrew formulae.

## repolens

Evidence-backed interactive diagrams for understanding code repositories (CLI + Claude Code skill).

```bash
brew install lijianrun/tap/repolens
repolens-install-skill        # installs the Claude Code skill into ~/.claude/skills/repolens
```

Then ask Claude: "用 repolens 梳理 <仓库路径>" / "use repolens to map <repo>".

The source repository is private: installing needs read access to `lijianrun/repolens`
with an SSH key registered on GitHub (`ssh -T git@github.com` should greet you).
