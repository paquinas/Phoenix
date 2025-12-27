module Screen
   
using SimpleDirectMediaLayer
using SimpleDirectMediaLayer.LibSDL2
using ..Types
using ..Engine

export Display, Clear

function Display()
    @assert !isnothing(Engine._WINDOW[]) "Initialize a window before attempting to modify it."

    SDL_RenderPresent(Engine._WINDOW[].renderer)
end

function Clear()
    @assert !isnothing(Engine._WINDOW[]) "Initialize a window before attempting to modify it."

    SDL_RenderClear(Engine._WINDOW[].renderer)
end

end