module Draw

using SimpleDirectMediaLayer.LibSDL2
using ..Types
using ..Engine

export Line, LineWidth, Rect, RectFill, Circle, Triangle, TriangleFill, Polygon, PolygonFill

function Line(p1::Vector2, p2::Vector2, color::Color)
    @assert !isnothing(Engine._WINDOW[]) "Initialize a window before attempting to modify it."

    r = Engine._WINDOW[].renderer
    SDL_SetRenderDrawColor(r, color.r, color.g, color.b, color.a)
    SDL_RenderDrawLine(r, p1.x, p1.y, p2.x, p2.y)
end

function LineWidth(p1::Vector2, p2::Vector2, width::Number, color::Color)
    @assert !isnothing(Engine._WINDOW[]) "Initialize a window before attempting to modify it."

    length = sqrt((p2.x - p1.x)^2 + (p2.y - p1.y)^2)
    nx = (p1.y - p2.y)/length * width/2
    ny = (p2.x - p1.x)/length * width/2

    TriangleFill(Vector2(p1.x + nx, p1.y + ny), Vector2(p1.x - nx, p1.y - ny), Vector2(p2.x - nx, p2.y - ny), color)
    TriangleFill(Vector2(p1.x + nx, p1.y + ny), Vector2(p2.x + nx, p2.y + ny), Vector2(p2.x - nx, p2.y - ny), color)
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

function TriangleFill(p1::Vector2, p2::Vector2, p3::Vector2, color::Color)
    @assert !isnothing(Engine._WINDOW[]) "Initialize a window before attempting to modify it."

    r = Engine._WINDOW[].renderer
    SDL_SetRenderDrawColor(r, color.r, color.g, color.b, color.a)

    points = [p1, p2, p3]
    sort!(points, by = p -> p.y)

    function flatBottom(v1::Vector2, v2::Vector2, v3::Vector2)
        invSlope1 = (v2.x - v1.x) / (v2.y - v1.y)
        invSlope2 = (v3.x - v1.x) / (v3.y - v1.y)

        xStart = v1.x
        xEnd = v1.x

        for y in Int(round(v1.y)):Int(round(v3.y))
            SDL_RenderDrawLine(r, Int(round(xStart)), y, Int(round(xEnd)), y)

            xStart += invSlope1
            xEnd += invSlope2
        end
    end

    function flatTop(v1::Vector2, v2::Vector2, v3::Vector2)
        invSlope1 = (v3.x - v1.x) / (v3.y - v1.y)
        invSlope2 = (v3.x - v2.x) / (v3.y - v2.y)

        xStart = v3.x
        xEnd = v3.x

        for y in Int(round(v3.y)):-1:Int(round(v2.y)) 
            SDL_RenderDrawLine(r, Int(round(xStart)), y, Int(round(xEnd)), y)

            xStart -= invSlope1
            xEnd -= invSlope2
        end
    end

    if points[2].y == points[3].y
        flatBottom(points[1], points[2], points[3])
    elseif points[1].y == points[2].y
        flatTop(points[1], points[2], points[3])
    else
        mp = Vector2((points[3].x - points[1].x) * (points[2].y - points[1].y) / (points[3].y - points[1].y) + points[1].x, points[2].y)

        flatBottom(points[1], points[2], mp)
        flatTop(points[2], mp, points[3])
    end
end

function Polygon(points::Vector{Vector2}, color::Color)
    @assert !isnothing(Engine._WINDOW[]) "Initialize a window before attempting to modify it."

    r = Engine._WINDOW[].renderer
    _points = Vector{SDL_Point}()

    for p in points
        append!(_points, [SDL_Point(p.x, p.y)])
    end
    append!(_points, [SDL_Point(points[1].x, points[1].y)])

    SDL_SetRenderDrawColor(r, color.r, color.g, color.b, color.a)
    SDL_RenderDrawLines(r, _points, Cint(length(_points)))
end

function isConvex(points::Vector{Vector2})
    n = length(points)

    last = 0
    for i in 1:n
        p1 = points[i]
        p2 = points[mod1(i+1, n)]
        p3 = points[mod1(i+2, n)]

        cross = (p2.x - p1.x)*(p3.y - p2.y) - (p2.y - p1.y)*(p3.x - p2.x)
        if cross != 0
            if last == 0
                last = cross
            elseif last * cross < 0
                return false
            end
        end
    end

    return true
end

function PolygonFill(points::Vector{Vector2}, color::Color)
    @assert !isnothing(Engine._WINDOW[]) "Initialize a window before attempting to modify it."

    if isConvex(points)   
        for i in 2:length(points)-1
            TriangleFill(points[1], points[i], points[i+1], color)
        end
    else
        print("WARNING: Concave Geometry Rendering is not supported")
    end
end


end