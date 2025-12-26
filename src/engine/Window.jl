module Window

using SimpleDirectMediaLayer
using SimpleDirectMediaLayer.LibSDL2
using ..Types

export Frame, FrameFlag, Clear, ResetColor

mutable struct Frame
    window::Ptr{SDL_Window}
    renderer::Ptr{SDL_Renderer}
    position::Vector2
    size::Vector2
    title::String
    baseColor::Color
end

const FrameFlag = (
    Fullscreen = 0x00000001,
    OpenGL = 0x00000002,
    Shown = 0x00000004,
    Hidden = 0x00000008,
    Borderless = 0x00000010,
    Resizeable = 0x00000020,
    Minimized = 0x00000040,
    Maximized = 0x00000080,
    MouseGrabbed = 0x00000100,
    InputFocus = 0x00000200,
    MouseFocus = 0x00000400,
    Foreign = 0x00000800,
    FullscreenDesktop = 0x00001001,
    HighDPI = 0x00002000,
    MouseCaptured = 0x00004000,
    AlwaysOnTop = 0x00008000,
    SkipTaskbar = 0x00010000,
    Utility = 0x00020000,
    Tooltip = 0x00040000,
    PopupMenu = 0x00080000,
    KeyboardGrabbed = 0x00100000,
    Vulkan = 0x10000000,
    Metal = 0x20000000
)

function Frame(position::Vector2, size::Vector2, title::String="Phoenix", flags::Vector{UInt32}=[0x00000000], baseColor::Color=Color(0,0,0,0))
    f = 0x00000000

    for flag in flags
        f |= flag
    end

    w = SDL_CreateWindow(
        title,
        position.x,
        position.y,
        size.x,
        size.y,
        f
    )

    r = SDL_CreateRenderer(w, -1, 0)

    return Frame(w, r, position, size, title, baseColor)
end

function Clear(frame::Frame)
    SDL_RenderClear(frame.renderer)
end

function ResetColor(frame::Frame)
    SDL_SetRenderDrawColor(frame.renderer, frame.baseColor.r, frame.baseColor.g, frame.baseColor.b, frame.baseColor.a)
end

end