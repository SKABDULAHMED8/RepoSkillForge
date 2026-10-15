# ManimGL troubleshooting

## Wrong package

ManimGL uses:

```python
from manimlib import *
```

Do not silently replace it with Manim Community Edition.

## CLI

```bash
manimgl --help
```

Always verify exact flags against the installed version.

## LaTeX

Use raw strings:

```python
Tex(R"\frac{a}{b}")
```

Read the actual TeX compiler error before changing the scene.

## Rendering

Separate Python errors, FFmpeg errors, graphics/backend errors, missing dependencies, and scene/API errors before changing code.

## Layout

Render a still:

```bash
manimgl scene.py SceneName -s -w -l
```

Inspect clipping and overlaps.

## Updaters

If an updater conflicts with a transform:

```python
mob.clear_updaters()
```

## Cache

If supported by the installed version:

```bash
manimgl --clear-cache
```
