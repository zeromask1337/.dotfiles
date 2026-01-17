---
name: skill-creator
description: Help create an agent skill based on the official specification
---

# Agent skill creator guide

## Overview

Create an Agent Skill Markdown file from user input. Your goal is to read the source material and format it according to the specification in the `@references` folder.

# Process

## Phase 1: Understand the source material and how to format it

**Is it a technical article?**  
Understand the main ideas, identify common patterns, and extract best practices.

**Is it a framework or library documentation?**  
Scan the full documentation and identify the patterns the authors recommend. Treat embedded code snippets and examples as best practices unless the docs explicitly say they are incorrect or discouraged.

**Is it internal corporate rules?**  
Treat them as authoritative. Do not omit or soften requirements, because other people will rely on this skill. Violations may have serious consequences.

**Is there more information than can fit in a skill?**  
Create additional info files that the agent can lazy-load from the skill-local `@references` folder. Each self-contained subject should have its own file. Make sure to tag links to those files using the `@path` opencode syntax.
For example if documentation is more then 1024 lines, split it like this `@references/how-to-import-components.md` or `@references/how-to-use-plugins`.
SKILL.md file should only contain main information for accomplishing task, everything else goes to @references.

**How do I set up a harness for the skill?**  
The source material may include some kind of harness. If not, ask the user clarifying questions (if any are needed). If the harness is a large piece of code, put it in a file in the skill-local `@scripts` folder and link to it from `SKILL.md` using `@path`.

## Phase 2: Use the agent skill spec to format the information

The `@references` folder contains the full agent skill specification that explains how to create high-level skills. Follow all rules. They are not recommendations, they are requirements.

## Phase 3: Create and test the skill with CLI commands

`path_to_skill_file="$HOME/.dotfiles/opencode/skill/<skill-name>/SKILL.md"`

> NOTE!
> If same or similar skill already exists in @opencode/skill folder, ask user whether he wants to create a new skill, update the existing one or do nothing.

**If user wants to create skill**
1. Create a branch from `master` with the same name as the skill.

**If user wants to update skill**
1. Check for existing branches related to this skill. If exists, create new branch from it and give it updated version number. For example `<bun-expert> -> <bun-expert-v2` or `<effect-explorer-v2> -> <effect-explorer-v3>`. If no related branches found, create new one from master.

**Then**
2. Create `SKILL.md` at `<path_to_skill_file>`.
3. Validate it: `skills-ref validate <path_to_skill_file>`.
4. Create a pull request to source branch using the `gh` utility.
