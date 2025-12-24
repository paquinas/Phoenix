module Draw

using SimpleDirectMediaLayer
using SimpleDirectMediaLayer.LibSDL2
using ..Types

function Triangle(color::Color)
    print(color.r)
end

export Triangle

end