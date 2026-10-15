# Basic scene

```python
from manimlib import *

class BasicScene(Scene):
    def construct(self):
        circle = Circle()
        self.play(ShowCreation(circle))
        self.wait()
```

Render:

```bash
manimgl scene.py BasicScene -w -l
```
