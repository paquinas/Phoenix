module Types

export Color, Vector2, Magnitude, Normalize, Cross, Dot

#-------#
# COLOR #
#-------#
struct Color
    r::UInt8
    g::UInt8
    b::UInt8
    a::UInt8
end

Color(r::Number, g::Number, b::Number) = Color(
    UInt8(clamp(0, round(r), 255)),
    UInt8(clamp(0, round(g), 255)),
    UInt8(clamp(0, round(b), 255)),
    255
)

function Color(h::String)
    if startswith(h, "#")
        h = h[2:end]
    end

    return Color(
        parse(UInt8, h[1:2], base=16),
        parse(UInt8, h[3:4], base=16),
        parse(UInt8, h[5:6], base=16),
        length(h) >= 8 ? parse(UInt8, h[7:8], base=16) : 255
    )
end

#---------#
# VECTOR2 #
#---------#
struct Vector2
    x::Float64
    y::Float64
end

function Base.:+(a::Vector2, b::Vector2)
    return Vector2(a.x + b.x, a.y + b.y)
end

function Base.:(-)(a::Vector2, b::Vector2)
    return Vector2(a.x - b.x, a.y - b.y)
end

function Base.:-(v::Vector2)
    return Vector2(-v.x, -v.y)
end

function Base.:*(v::Vector2, s::Number)
    return Vector2(v.x * s, v.y * s)
end

function Base.:*(s::Number, v::Vector2)
    return Vector2(v.x * s, v.y * s)
end

function Base.:/(v::Vector2, s::Number)
    @assert s != 0 "Cannot divide Vector2 by 0"
    return Vector2(v.x / s, v.y / s)
end

function Base.:÷(v::Vector2, s::Number)
    @assert s != 0 "Cannot divide Vector2 by 0"
    return Vector2(v.x ÷ s, v.y ÷ s)
end

function Magnitude(v::Vector2)
    return sqrt(v.x^2 + v.y^2)
end

function Normalize(v::Vector2)
   m = Magnitude(v)
   @assert m != 0 "Cannot normalize a Vector2 with a magnitude of 0"
   return Vector2(v.x/m, v.y/m) 
end

function Dot(a::Vector2, b::Vector2)
    return a.x * b.x + a.y * b.y
end

function Cross(a::Vector2, b::Vector2)
    return a.x * b.y - b.x * a.y
end

end