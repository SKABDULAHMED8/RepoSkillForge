# ManimGL version compatibility

Upstream: https://github.com/3b1b/manim

When exact behavior matters, inspect the installed source rather than assuming all releases behave identically.

```bash
manimgl --version
python -c "import manimlib; print(manimlib.__file__)"
```

For a source checkout:

```bash
git rev-parse HEAD
git status --short
```

Use local source and `manimgl --help` to resolve version-specific uncertainty.
