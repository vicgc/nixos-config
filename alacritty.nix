{ environment, ... }:

let
  hostName = "${builtins.readFile ./.hostname}";

in {
#  let
#    makeConfig { name, fg, bg }
#  in map makeConfig
#    [ { name = "example.org"; root = "/sites/example.org"; }

  environment.etc."alacritty.yml".text = ''
    env:
      TERM: xterm-256color

    dpi:
      x: 96.0
      y: 96.0

    tabspaces: 8

    draw_bold_text_with_bright_colors: true

    font:
      # The normal (roman) font face to use.
      normal:
        family: Source Code Pro
        style: Regular

      bold:
        family: Source Code Pro
        style: Bold

      italic:
        family: Source Code Pro
        style: Italic

      size: 10.5

      offset:
        x: 0.0
        y: 0.0

      glyph_offset:
        x: 0.0
        y: 0.0

    render_timer: false

    custom_cursor_colors: true

    padding:
      x: 10
      y: 10

    colors:
      primary:
        #background: '0x000000'
        #foreground: '0xeaeaea'
        background: '0x1a172b'
        foreground: '0xcbe3e7'

      cursor:
        text: '0x000000'
        cursor: '0xffffff'

      normal:
        black:   '0x1e1c31'
        white:   '0xcbe3e7'
        blue:    '0x65b2ff'
        cyan:    '0x63f2f1'
        green:   '0x62d196'
        grey:    '0xa6b3cc'
        magenta: '0x906cff'
        red:     '0xff5458'
        yellow:  '0xffb378'

      bright:
        black:   '0x333333'
        red:     '0xff3334'
        green:   '0x9ec400'
        yellow:  '0xe7c547'
        blue:    '0x7aa6da'
        magenta: '0xb77ee0'
        cyan:    '0x54ced6'
        white:   '0xffffff'

      dim:
    ￼   black:   '0x333333'
    ￼   red:     '0xf2777a'
    ￼   green:   '0x99cc99'
    ￼   yellow:  '0xffcc66'
    ￼   blue:    '0x6699cc'
    ￼   magenta: '0xcc99cc'
    ￼   cyan:    '0x66cccc'
    ￼   white:   '0xdddddd'

    visual_bell:
      duration: 0

    key_bindings:
      - { key: V,        mods: Control|Shift,    action: Paste               }
      - { key: C,        mods: Control|Shift,    action: Copy                }
      - { key: Q,        mods: Command, action: Quit                         }
      - { key: W,        mods: Command, action: Quit                         }
      - { key: Insert,   mods: Shift,   action: PasteSelection               }
      - { key: Home,                    chars: "\x1bOH",   mode: AppCursor   }
      - { key: Home,                    chars: "\x1b[1~",  mode: ~AppCursor  }
      - { key: End,                     chars: "\x1bOF",   mode: AppCursor   }
      - { key: End,                     chars: "\x1b[4~",  mode: ~AppCursor  }
      - { key: PageUp,   mods: Shift,   chars: "\x1b[5;2~"                   }
      - { key: PageUp,   mods: Control, chars: "\x1b[5;5~"                   }
      - { key: PageUp,                  chars: "\x1b[5~"                     }
      - { key: PageDown, mods: Shift,   chars: "\x1b[6;2~"                   }
      - { key: PageDown, mods: Control, chars: "\x1b[6;5~"                   }
      - { key: PageDown,                chars: "\x1b[6~"                     }
      - { key: Left,     mods: Shift,   chars: "\x1b[1;2D"                   }
      - { key: Left,     mods: Control, chars: "\x1b[1;5D"                   }
      - { key: Left,     mods: Alt,     chars: "\x1b[1;3D"                   }
      - { key: Left,                    chars: "\x1b[D",   mode: ~AppCursor  }
      - { key: Left,                    chars: "\x1bOD",   mode: AppCursor   }
      - { key: Right,    mods: Shift,   chars: "\x1b[1;2C"                   }
      - { key: Right,    mods: Control, chars: "\x1b[1;5C"                   }
      - { key: Right,    mods: Alt,     chars: "\x1b[1;3C"                   }
      - { key: Right,                   chars: "\x1b[C",   mode: ~AppCursor  }
      - { key: Right,                   chars: "\x1bOC",   mode: AppCursor   }
      - { key: Up,       mods: Shift,   chars: "\x1b[1;2A"                   }
      - { key: Up,       mods: Control, chars: "\x1b[1;5A"                   }
      - { key: Up,       mods: Alt,     chars: "\x1b[1;3A"                   }
      - { key: Up,                      chars: "\x1b[A",   mode: ~AppCursor  }
      - { key: Up,                      chars: "\x1bOA",   mode: AppCursor   }
      - { key: Down,     mods: Shift,   chars: "\x1b[1;2B"                   }
      - { key: Down,     mods: Control, chars: "\x1b[1;5B"                   }
      - { key: Down,     mods: Alt,     chars: "\x1b[1;3B"                   }
      - { key: Down,                    chars: "\x1b[B",   mode: ~AppCursor  }
      - { key: Down,                    chars: "\x1bOB",   mode: AppCursor   }
      - { key: Tab,      mods: Shift,   chars: "\x1b[Z"                      }
      - { key: F1,                      chars: "\x1bOP"                      }
      - { key: F2,                      chars: "\x1bOQ"                      }
      - { key: F3,                      chars: "\x1bOR"                      }
      - { key: F4,                      chars: "\x1bOS"                      }
      - { key: F5,                      chars: "\x1b[15~"                    }
      - { key: F6,                      chars: "\x1b[17~"                    }
      - { key: F7,                      chars: "\x1b[18~"                    }
      - { key: F8,                      chars: "\x1b[19~"                    }
      - { key: F9,                      chars: "\x1b[20~"                    }
      - { key: F10,                     chars: "\x1b[21~"                    }
      - { key: F11,                     chars: "\x1b[23~"                    }
      - { key: F12,                     chars: "\x1b[24~"                    }
      - { key: Back,                    chars: "\x7f"                        }
      - { key: Back,     mods: Alt,     chars: "\x1b\x7f"                    }
      - { key: Insert,                  chars: "\x1b[2~"                     }
      - { key: Delete,                  chars: "\x1b[3~"                     }

    mouse_bindings:
      - { mouse: Middle, action: PasteSelection }

    mouse:
      double_click: { threshold: 300 }
      triple_click: { threshold: 300 }

    selection:
      semantic_escape_chars: ",│`|:\"' ()[]{}<>"

    hide_cursor_when_typing: false
  '';
}
