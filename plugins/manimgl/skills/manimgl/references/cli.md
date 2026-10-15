# ManimGL CLI quick reference

Always prefer `manimgl --help` from the user's installed environment when an exact flag matters.

Typical invocation:

```bash
manimgl FILE.py SceneName [FLAGS]
```

Common workflow:

```bash
manimgl scene.py Demo
manimgl scene.py Demo -w
manimgl scene.py Demo -w -l
manimgl scene.py Demo -s -w -l
```

Important flags commonly present in ManimGL:

| Flag | Purpose |
|---|---|
| `-w` | write rendered output |
| `-o` | write and open |
| `-s` | skip animations and show final frame |
| `-so` | save/show final frame |
| `-n` | render/seek by animation number |
| `-a` | render all scenes |
| `-f` | fullscreen preview |
| `-l` | low-quality preset |
| `-m` | medium-quality preset |
| `--hd` | HD preset |
| `--uhd` | UHD/4K preset |
| `-r` | explicit resolution |
| `--fps` | explicit frame rate |
| `-i` | GIF output |
| `-t` | transparent output where supported |
| `--file_name` | output filename |
| `--video_dir` | output directory |
| `--clear-cache` | clear cached TeX/text data |
| `--config_file` | choose configuration file |

Do not assume the exact semantics of a flag across releases. Verify with `manimgl --help` if the command is failing.
