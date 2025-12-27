module Engine

using SimpleDirectMediaLayer
using SimpleDirectMediaLayer.LibSDL2
using ..Types

export Init, Quit, _WINDOW

mutable struct Window
    window::Ptr{SDL_Window}
    renderer::Ptr{SDL_Renderer}
    callbacks::Vector{Function}
end

const _WINDOW = Ref{Union{Nothing, Window}}(nothing)

function Init(title::String, position::Vector2, size::Vector2, flags::UInt32=0x00000000)
    SDL_GL_SetAttribute(SDL_GL_MULTISAMPLEBUFFERS, 16)
    SDL_GL_SetAttribute(SDL_GL_MULTISAMPLESAMPLES, 16)
    SDL_Init(SDL_INIT_EVERYTHING)

    w = SDL_CreateWindow(title, position.x, position.y, size.x, size.y, flags)
    r = SDL_CreateRenderer(w, -1, SDL_RENDERER_ACCELERATED | SDL_RENDERER_PRESENTVSYNC)

    _WINDOW[] = Window(w, r, [])
end

function Quit()
    SDL_DestroyRenderer(_WINDOW[].renderer)
    SDL_DestroyWindow(_WINDOW[].window)
    SDL_Quit()
    _WINDOW[] = nothing
end

end