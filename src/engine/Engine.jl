module Engine

include("Types.jl")
using .Types

include("Draw.jl")
include("Window.jl")
using .Draw, .Window

export Color, Vector2, Dot, Triangle, Frame, FrameFlag



end