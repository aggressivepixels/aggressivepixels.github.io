let upstream =
      https://github.com/purescript/package-sets/releases/download/psc-0.13.6-20200309/packages.dhall sha256:9221987b4e7ea99ccd0efbe056f7bebc872cd92e0058efe5baa181d73359e7b3

let overrides =
      { css =
          { dependencies =
            [ "generics-rep"
            , "nonempty"
            , "profunctor"
            , "strings"
            , "these"
            , "transformers"
            , "colors"
            , "console"
            ]
          , repo = "https://github.com/vyorkin-forks/purescript-css.git"
          , version = "master"
          }
      }

let additions =
      { markdown =
          { dependencies =
            [ "const"
            , "datetime"
            , "functors"
            , "lists"
            , "ordered-collections"
            , "parsing"
            , "partial"
            , "precise"
            , "prelude"
            , "strings"
            , "unicode"
            , "validation"
            ]
          , repo = "https://github.com/aggressivepixels/purescript-markdown.git"
          , version = "fix-indentation"
          }
      , markdown-smolder =
          { dependencies =
            [ "markdown"
            , "smolder"
            , "ordered-collections"
            , "typelevel-prelude"
            ]
          , repo = "https://github.com/hgiasac/purescript-markdown-smolder.git"
          , version = "v2.0.1"
          }
      , precise =
          { dependencies =
            [ "arrays"
            , "globals"
            , "integers"
            , "generics-rep"
            , "strings"
            , "gen"
            , "lists"
            , "exceptions"
            ]
          , repo =
              "https://github.com/purescript-contrib/purescript-precise.git"
          , version = "v4.0.0"
          }
      }

in  upstream // overrides // additions
