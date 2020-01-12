module Test.Main where

import Prelude
import Effect (Effect)
import Effect.Console as Console

main :: Effect Unit
main = Console.log "I ought to write some tests."
