module Main
  ( main
  ) where

import Prelude
import CSS.Render (renderedSheet)
import Control.Monad.Trampoline (runTrampoline)
import Data.Array as Array
import Data.Either (Either(..))
import Data.Foldable (for_)
import Data.Maybe (Maybe(..))
import Data.Traversable (for)
import Data.Tuple (Tuple(..))
import Data.Tuple as Tuple
import Effect (Effect)
import Effect.Exception (throw)
import Index as Index
import Node.Encoding (Encoding(..))
import Node.FS.Stats as Stats
import Node.FS.Sync as FS
import Node.Path (FilePath)
import Node.Path as Path
import NotFound as NotFound
import Post as Post
import Skeleton as Skeleton
import Styles as Styles
import Text.Markdown.SlamDown.Parser (parseMd)
import Text.Markdown.SlamDown.Smolder (toMarkup)
import Text.Markdown.SlamDown.Syntax (SlamDown)
import Text.Parsing.Parser (runParserT)
import Text.Smolder.Renderer.String as StringRenderer

main :: Effect Unit
main = do
  wipe "dist"
  -- Copy the static files.
  copy (Source "static") (Dest "dist")
  -- Write the CSS.
  FS.mkdir $ Path.concat [ "dist", "css" ]
  css <- case renderedSheet Styles.sheet of
    Just renderedCSS -> pure renderedCSS
    Nothing -> throw "invalid stylesheet"
  FS.writeTextFile UTF8 (Path.concat [ "dist", "css", "styles.css" ]) css
  Skeleton.view
    { title: Just "Not found"
    , description: Just "Not found"
    , content: NotFound.view
    }
    # StringRenderer.render
    # FS.writeTextFile UTF8 (Path.concat [ "dist", "404.html" ])
  -- Read the posts.
  postsFiles <- FS.readdir "posts"
  posts <-
    Array.sort
      <$> for postsFiles \postFile -> do
          rawContent <- FS.readTextFile UTF8 $ Path.concat [ "posts", postFile ]
          case runTrampoline <<< runParserT rawContent $ Post.parser of
            Left err -> throw $ "when parsing " <> postFile <> ": " <> show err
            Right postAndContent -> pure postAndContent
  -- Write the index.
  Skeleton.view
    { title: Nothing
    , description: Just "Jonathan Hernández' personal blog"
    , content: Index.view $ Tuple.fst <$> posts
    }
    # StringRenderer.render
    # FS.writeTextFile UTF8 (Path.concat [ "dist", "index.html" ])
  -- Write the posts.
  FS.mkdir (Path.concat [ "dist", "posts" ])
  for_ posts \(Tuple post rawMarkdown) -> case parseMd rawMarkdown of
    Left err ->
      throw $ "when parsing the content of \""
        <> Post.getTitle post
        <> "\": "
        <> err
    Right (markdown :: SlamDown) -> do
      FS.mkdir (Path.concat [ "dist", Post.getPath post ])
      Skeleton.view
        { title: Just $ Post.getTitle post
        , description: Just $ Post.getDescription post
        , content: Post.viewContent post (toMarkup markdown)
        }
        # StringRenderer.render
        # FS.writeTextFile UTF8
            (Path.concat [ "dist", Post.getPath post, "index.html" ])

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
