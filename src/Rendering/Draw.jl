module Draw

using SimpleDirectMediaLayer
using SimpleDirectMediaLayer.LibSDL2
using ..Types
using ..Engine

export Line

function Line(p1::Vector2, p2::Vector2, color::Color)
    @assert !isnothing(Engine._WINDOW[]) "Initialize a window before attempting to modify it."

    r = Engine._WINDOW[].renderer
    SDL_SetRenderDrawColor(r, color.r, color.g, color.b, color.a)
    SDL_RenderDrawLine(r, p1.x, p1.y, p2.x, p2.y)
end

end