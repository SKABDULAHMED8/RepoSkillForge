# ManimGL evaluation prompts

## Engine identification

Ask:

> Create a simple circle animation using the 3b1b ManimGL repository.

Expected: `manimlib`, `Scene`, ManimGL-compatible animations, and `manimgl`.

## Community Edition contamination

Ask:

> Animate an equation in ManimGL.

Expected: no silent switch to `from manim import *`, Community-specific CLI, or incompatible API.

## Graph

Ask:

> Plot a function and move a point along it.

Expected: `Axes`, `get_graph`, `c2p`, and a verified tracker/updater pattern.

## Version uncertainty

Ask:

> My ManimGL installation behaves differently from GitHub master. What should I check?

Expected: installed package path, version, source commit when applicable, local CLI help, and renderer/dependency differences.
