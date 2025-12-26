module Draw

using SimpleDirectMediaLayer
using SimpleDirectMediaLayer.LibSDL2
using ..Types, ..Window

function Triangle(frame::Frame, p1::Vector2, p2::Vector2, p3::Vector2, color::Color)
    points = SDL_Point[
        SDL_Point(Int32(p1.x), Int32(p1.y)),
        SDL_Point(Int32(p2.x), Int32(p2.y)),
        SDL_Point(Int32(p3.x), Int32(p3.y)),
        SDL_Point(Int32(p1.x), Int32(p1.y))
    ]

    SDL_SetRenderDrawColor(frame.renderer, color.r, color.g, color.b, color.a)
    SDL_RenderDrawLines(frame.renderer, points, Cint(4))
    SDL_RenderPresent(frame.renderer)
    ResetColor(frame)
end

function TriangleFill(frame::Frame, p1::Vector2, p2::Vector2, p3::Vector2, color::Color)
    SDL_SetRenderDrawColor(frame.renderer, color.r, color.g, color.b, color.a)

    points = [p1, p2, p3]
    sort!(points, by = p -> p.y)

    function flatBottom(v1::Vector2, v2::Vector2, v3::Vector2)
        invSlope1 = (v2.x - v1.x) / (v2.y - v1.y)
        invSlope2 = (v3.x - v1.x) / (v3.y - v1.y)

        xStart = v1.x
        xEnd = v1.x

        for y in Int(round(v1.y)):Int(round(v3.y))
            SDL_RenderDrawLine(frame.renderer, Int(round(xStart)), y, Int(round(xEnd)), y)

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
            SDL_RenderDrawLine(frame.renderer, Int(round(xStart)), y, Int(round(xEnd)), y)

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

    SDL_RenderPresent(frame.renderer)
    ResetColor(frame)
end

function Circle(frame::Frame, center::Vector2, radius::Number, color::Color)
    SDL_SetRenderDrawColor(frame.renderer, color.r, color.g, color.b, color.a)

    for i in range(0, 2*pi, Int(round(2*pi*radius)))
        SDL_RenderDrawPoint(frame.renderer, center.x + round(cos(i) * radius), center.y + round(sin(i) * radius))
    end

    SDL_RenderPresent(frame.renderer)
    ResetColor(frame)
end

function CircleFill(frame::Frame, center::Vector2, radius::Number, color::Color)
    SDL_SetRenderDrawColor(frame.renderer, color.r, color.g, color.b, color.a)

    for i in range(0, pi, Int(round(pi*radius)))
        p1 = Vector2(center.x + round(cos(i) * radius), center.y + round(sin(i) * radius))
        p2 = Vector2(center.x + round(cos(-i) * radius), center.y + round(sin(-i) * radius))
        SDL_RenderDrawLine(frame.renderer, p1.x, p1.y, p2.x, p2.y)
    end

    SDL_RenderPresent(frame.renderer)
    ResetColor(frame)
end

function Rectangle(frame::Frame, position::Vector2, size::Vector2, color::Color)
    SDL_SetRenderDrawColor(frame.renderer, color.r, color.g, color.b, color.a)

    rect = SDL_Rect(position.x, position.y, size.x, size.y)
    SDL_RenderDrawRect(frame.renderer, Ref(rect))
    SDL_RenderPresent(frame.renderer)
    ResetColor(frame)
end

function RectangleFill(frame::Frame, position::Vector2, size::Vector2, color::Color)
    SDL_SetRenderDrawColor(frame.renderer, color.r, color.g, color.b, color.a)

    rect = SDL_Rect(position.x, position.y, size.x, size.y)
    SDL_RenderFillRect(frame.renderer, Ref(rect))
    SDL_RenderPresent(frame.renderer)
    ResetColor(frame)
end


export Triangle, TriangleFill, Circle, CircleFill, Rectangle, RectangleFill

end