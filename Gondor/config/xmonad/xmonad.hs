import XMonad

main    = xmonad def
        { terminal  = "alacritty"
        , modMas    = mod4Mask
        }
