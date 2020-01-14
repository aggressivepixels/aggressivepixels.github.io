{ name = "aggressivepixels"
, dependencies =
    [ "console"
    , "datetime"
    , "effect"
    , "formatters"
    , "markdown"
    , "markdown-smolder"
    , "node-fs"
    , "parsing"
    , "psci-support"
    , "smolder"
    ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs", "test/**/*.purs" ]
}
