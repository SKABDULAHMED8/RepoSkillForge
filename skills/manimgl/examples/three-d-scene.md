# 3D scene

```python
from manimlib import *

class ThreeDExample(ThreeDScene):
    def construct(self):
        sphere = Sphere()
        self.add(sphere)
        self.play(self.frame.animate.reorient(20, 60), run_time=2)
        self.wait()
```
