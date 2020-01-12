module Main where

import Prelude
import Control.Monad (whenM)
import Data.Foldable (for_)
import Data.Traversable (for)
import Data.Maybe (Maybe(..), maybe, fromMaybe)
import Data.Either (Either(..), either)
import Data.String
import Data.String.CodeUnits
import Effect (Effect)
import Effect.Exception
import Effect.Class (liftEffect)
import Effect.Console as Console
import Node.Path
import Node.Encoding (Encoding(UTF8))
import Node.FS.Sync as FS
import Node.FS.Stats (isDirectory)
import Text.Markdown.SlamDown
import Text.Markdown.SlamDown.Smolder
import Text.Markdown.SlamDown.Parser
import Text.Smolder.Markup (Markup, text)
import Text.Smolder.Renderer.String.Extended (renderWithDoctype)
import Text.Parsing.Parser (runParserT)
import Skeleton as Skeleton
import Post (Post)
import Post as Post
import Index as Index

-- TODO: This code is gross and mostly imperative. Let's refactor this and
--       take advantage of PureScript's type system.
main :: Effect Unit
main = do
  cleanDistDir
  postsFiles <- FS.readdir "posts"
  -- TODO: for_ is not stack-safe.
  posts <-
    for postsFiles \filename -> do
      content <- FS.readTextFile UTF8 $ "posts" <> "/" <> filename
      newFilename <- pure $ mkFilename filename
      rawPost <- runParserT content Post.parser
      pure $ rawPost
        <#> \p ->
            { title: p.title
            , description: p.description
            , url: "posts/" <> fromMaybe "" newFilename
            , machineDate: p.date
            , displayDate: ""
            , rawContent: p.content
            }
  FS.mkdir $ "dist" <> "/" <> "posts"
  for_ posts \ep -> do
    case ep of
      Left pe -> throw $ show pe
      Right p -> do
        content <- pure $ parseContent p.rawContent
        case content of
          Left e -> throw $ p.url <> "'s content could not be parsed: " <> e
          Right markup -> FS.writeTextFile UTF8 ("dist/" <> p.url) page
            where
            page =
              Post.viewContent pagePost markup
                # Skeleton.wrap (Just pagePost.title)
                # renderWithDoctype

            pagePost =
              { title: p.title
              , description: p.description
              , url: p.url
              , machineDate: ""
              , displayDate: ""
              }

parseContent :: forall e. String -> Either String (Markup e)
parseContent input = toMarkup <$> result
  where
  result :: Either String SlamDown
  result = parseMd input

cleanDistDir :: Effect Unit
cleanDistDir = do
  clean dist
  FS.mkdir dist
  where
  dist = "dist"

clean :: String -> Effect Unit
clean path = do
  whenM (FS.exists path) do
    stats <- FS.stat path
    if isDirectory stats then do
      files <- FS.readdir path
      for_ files \f ->
        clean $ path <> "/" <> f
      FS.rmdir path
    else
      FS.unlink path

mkFilename :: FilePath -> Maybe FilePath
mkFilename filename = stripSuffix (Pattern ".md") filename <> pure ".html"
