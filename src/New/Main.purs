module New.Main where

import Prelude
import Data.Foldable (for_)
import Effect (Effect)
import Node.Path (FilePath)
import Node.Path as Path
import Node.FS.Sync as FS
import Node.FS.Stats as Stats

wipe :: FilePath -> Effect Unit
wipe file = do
  exists <- FS.exists file
  if exists then
    doWipe file
  else
    pure unit
  where
  doWipe existingFile = do
    stats <- FS.stat existingFile
    if Stats.isDirectory stats then
      doWipeDir existingFile
    else
      FS.unlink existingFile

  doWipeDir dir = do
    files <- FS.readdir dir
    for_ files \f -> doWipe $ Path.concat [ dir, f ]
    FS.rmdir dir
