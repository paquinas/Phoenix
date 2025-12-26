module Engine

include("Types.jl")
using .Types

include("Window.jl")
using .Window

include("Draw.jl")
using .Draw

export Color, Vector2, Dot, Frame, FrameFlag, Clear, ResetColor, Window, Triangle, TriangleFill, Circle, CircleFill, Rectangle, RectangleFill, Line



end