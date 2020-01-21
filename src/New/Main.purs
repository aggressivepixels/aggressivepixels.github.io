module New.Main (main) where

import Prelude
import Data.Array as Array
import Data.Either (Either(..))
import Data.Foldable (for_)
import Data.Maybe (Maybe(..))
import Data.Traversable (for)
import Data.Tuple (Tuple(..))
import Data.Tuple as Tuple
import Effect (Effect)
import Effect.Console as Console
import Effect.Exception (throw)
import New.Index as Index
import New.Post as Post
import New.Skeleton as Skeleton
import Node.Encoding (Encoding(..))
import Node.FS.Stats as Stats
import Node.FS.Sync as FS
import Node.Path (FilePath)
import Node.Path as Path
import Text.Markdown.SlamDown.Parser (parseMd)
import Text.Markdown.SlamDown.Smolder (toMarkup)
import Text.Markdown.SlamDown.Syntax (SlamDown)
import Text.Parsing.Parser (runParser)
import Text.Smolder.Renderer.String as StringRenderer

main :: Effect Unit
main = do
  -- Clean the dist folder.
  wipe "dist"
  copy (Source "static") (Dest "dist")
  -- Read the posts.
  postsFiles <- Array.sort <$> FS.readdir "posts"
  posts <-
    for postsFiles \postFile -> do
      rawContent <- FS.readTextFile UTF8 $ Path.concat [ "posts", postFile ]
      case runParser rawContent Post.parser of
        -- TODO: We probably shouldn't throw.
        Left err -> throw $ "when parsing " <> postFile <> ": " <> show err
        Right postAndContent -> pure postAndContent
  -- Write the index.
  Tuple.fst <$> posts
    # Index.view
    # Skeleton.view Nothing
    # StringRenderer.render
    # FS.writeTextFile UTF8 (Path.concat [ "dist", "index.html" ])
  -- Write the posts.
  FS.mkdir (Path.concat [ "dist", "posts" ])
  for_ posts \(Tuple post rawMarkdown) -> case parseMd rawMarkdown of
    Left err -> throw $ "when parsing the content of \"" <> Post.getTitle post <> "\": " <> err
    Right (markdown :: SlamDown) -> do
      Post.viewContent post (toMarkup markdown)
        # Skeleton.view (Just $ Post.getTitle post)
        # StringRenderer.render
        # FS.writeTextFile UTF8 (Path.concat [ "dist", Post.getPath post ])

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

newtype Source
  = Source FilePath

newtype Dest
  = Dest FilePath

copy :: Source -> Dest -> Effect Unit
copy (Source src) (Dest dst) = do
  dstExists <- FS.exists dst
  if dstExists then
    pure unit
  else
    FS.mkdir dst
  doCopyDir src dst
  where
  doCopyDir dir existingDst = do
    files <- FS.readdir dir
    for_ files \f -> do
      let
        srcPath = Path.concat [ dir, f ]
        dstPath = Path.concat [ existingDst, f ]
      stats <- FS.stat srcPath
      if Stats.isDirectory stats then do
        FS.mkdir dstPath
        doCopyDir srcPath dstPath
      else do
        content <- FS.readFile srcPath
        FS.writeFile dstPath content
