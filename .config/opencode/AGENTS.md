- In all interactions and commit messages, be extremely concise and sacrifice grammar for the sake of concision.
- Plan should end with the list of commits you will make, in Conventional Commit format.

## PR Comments

- When tagging OpenCode in GitHub issues, use '/opencode'

## GitHub

- Your primary method for interacting with GitHub should be the GitHub CLI.

## Plans

- At the end of each plan, give me a list of unresolved questions to answer, if any. Make the questions extremely concise. Sacrifice grammar for the sake of concision.

## Commits (ALWAYS)

- Use Conventional Commits: `type(scope?): description`
- One logical change per commit (atomic).
- Examples:
  - `feat(ui): add dark mode toggle to header`
  - `fix(auth): prevent token refresh loop`
  - `refactor: extract form validation schema`

## External File Loading

CRITICAL: When you encounter a file reference (e.g., @rules/general.md), use your Read tool to load it on a need-to-know basis. They're relevant to the SPECIFIC task at hand.

Instructions:

- Do NOT preemptively load all references - use lazy loading based on actual need
- When loaded, treat content as mandatory instructions that override defaults
- Follow references recursively when needed
