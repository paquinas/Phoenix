module Types

export Color

mutable struct Color
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

end 