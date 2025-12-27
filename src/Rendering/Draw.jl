module Draw

using SimpleDirectMediaLayer.LibSDL2
using ..Types
using ..Engine

export Line, Rect, RectFill, Circle, Triangle

function Line(p1::Vector2, p2::Vector2, color::Color)
    @assert !isnothing(Engine._WINDOW[]) "Initialize a window before attempting to modify it."

    r = Engine._WINDOW[].renderer
    SDL_SetRenderDrawColor(r, color.r, color.g, color.b, color.a)
    SDL_RenderDrawLine(r, p1.x, p1.y, p2.x, p2.y)
end

function Rect(position::Vector2, size::Vector2, color::Color)
    @assert !isnothing(Engine._WINDOW[]) "Initialize a window before attempting to modify it."

    r = Engine._WINDOW[].renderer
    rect = SDL_Rect(round(position.x), round(position.y), round(size.x), round(size.y))
    SDL_SetRenderDrawColor(r, color.r, color.g, color.b, color.a)
    SDL_RenderDrawRect(r, Ref(rect))
end

function RectFill(position::Vector2, size::Vector2, color::Color)
    @assert !isnothing(Engine._WINDOW[]) "Initialize a window before attempting to modify it."

    r = Engine._WINDOW[].renderer
    rect = SDL_Rect(round(position.x), round(position.y), round(size.x), round(size.y))
    SDL_SetRenderDrawColor(r, color.r, color.g, color.b, color.a)
    SDL_RenderFillRect(r, Ref(rect))
end

function Circle(position::Vector2, radius::Float64, color::Color)
    @assert !isnothing(Engine._WINDOW[]) "Initialize a window before attempting to modify it."
    @assert radius > 0 "Circle must have a radius greater than 0."
   
    r = Engine._WINDOW[].renderer
    points = SDL_Point[]
    for i in range(0, 2π, Int(round(2π*radius)))
        point = SDL_Point(round(position.x + (radius * cos(i))), round(position.y + (radius * sin(i))))
        push!(points, point)
    end

    SDL_SetRenderDrawColor(r, color.r, color.g, color.b, color.a)
    SDL_RenderDrawPoints(r, points, length(points))
end

function CircleFill(position::Vector2, radius::Float64, color::Color)
    @assert !isnothing(Engine._WINDOW[]) "Initialize a window before attempting to modify it."
    @assert radius > 0 "Circle must have a radius greater than 0."
   
    r = Engine._WINDOW[].renderer
    SDL_SetRenderDrawColor(r, color.r, color.g, color.b, color.a)
    r2 = radius^2
    ystart = ceil(-radius)
    yend = floor(radius)

    for y in ystart:yend
        x = sqrt(r2 - y^2) 
        
        SDL_RenderDrawLine(r, round(position.x + x), round(position.y + y), round(position.x - x), round(position.y + y))
    end
end

function Triangle(p1::Vector2, p2::Vector2, p3::Vector2, color::Color)
    @assert !isnothing(Engine._WINDOW[]) "Initialize a window before attempting to modify it."

    r = Engine._WINDOW[].renderer
    points = SDL_Point[
        SDL_Point(round(p1.x), round(p1.y)),
        SDL_Point(round(p2.x), round(p2.y)),
        SDL_Point(round(p3.x), round(p3.y)),
        SDL_Point(round(p1.x), round(p1.y))
    ]

    SDL_SetRenderDrawColor(r, color.r, color.g, color.b, color.a)
    SDL_RenderDrawLines(r, points, Cint(4))
end


end