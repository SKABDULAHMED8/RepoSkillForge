# Equation animation

```python
from manimlib import *

class Equation(Scene):
    def construct(self):
        a = Tex(R"x^2 - 5x + 6 = 0").scale(1.4)
        b = Tex(R"(x-2)(x-3)=0").scale(1.4)
        self.play(Write(a))
        self.play(TransformMatchingShapes(a, b))
        self.wait()
```
