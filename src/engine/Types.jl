module Types

export Color, Vector2, Dot

#--COLOR--#
struct Color
    r::UInt8
    g::UInt8
    b::UInt8
    a::UInt8
end

Color(r::Number, g::Number, b::Number) = Color(UInt8(clamp(0, round(r), 255)), UInt8(clamp(0, round(g), 255)), UInt8(clamp(0, round(b), 255)), 255)

function Color(hex::String)
    start = 0
    if length(hex) == 6
        start = 1
    elseif (length(hex) == 7) && (hex[1] == '#')
        start = 2
    else
        error("ERROR: Hex string invalidly formatted.")
    end

    return Color(
        parse(UInt8, hex[start:start+1], base=16),
        parse(UInt8, hex[start+2:start+3], base=16),
        parse(UInt8, hex[start+4:start+5], base=16),
        255
    )
end

#--VECTOR2--#
struct Vector2
    x::Float64
    y::Float64
end

Base.:*(vector::Vector2, scalar::Number) = Vector2(vector.x * scalar, vector.y * scalar)
Base.:*(scalar::Number, vector::Vector2) = Vector2(vector.x * scalar, vector.y * scalar)
Base.:÷(vector::Vector2, scalar::Number) = Vector2(vector.x ÷ scalar, vector.y ÷ scalar)
Base.:+(vector1::Vector2, vector2::Vector2) = Vector2(vector1.x + vector2.x, vector1.y + vector2.y)

function Dot(vector1::Vector2, vector2::Vector2)
    return (vector1.x * vector2.x) + (vector1.y * vector2.y)
end

end 