{ name = "aggressivepixels"
, dependencies =
    [ "bucketchain-static"
    , "console"
    , "datetime"
    , "effect"
    , "formatters"
    , "markdown"
    , "markdown-smolder"
    , "node-fs"
    , "node-http"
    , "parsing"
    , "psci-support"
    , "smolder"
    ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs", "test/**/*.purs" ]
}
