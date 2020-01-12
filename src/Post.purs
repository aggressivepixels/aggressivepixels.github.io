module Post (Post, parser, viewContent, viewPreview) where

import Prelude
import Data.Array (many)
import Data.String (trim)
import Data.String.CodeUnits (fromCharArray)
import Text.Parsing.Parser (ParserT)
import Text.Parsing.Parser.String
  ( class StringLike
  , anyChar
  , char
  , noneOf
  , oneOf
  , skipSpaces
  , string
  )
import Text.Smolder.HTML
  ( a
  , article
  , h1
  , h2
  , li
  , p
  , time
  )
import Text.Smolder.HTML.Attributes (className, datetime, href)
import Text.Smolder.Markup (Markup, text, (!))

type Post =
  { title :: String
  , description :: String
  , url :: String
  , machineDate :: String
  , displayDate :: String
  }

viewContent :: forall e. Post -> Markup e -> Markup e
viewContent post content = article $ do
  time ! datetime post.machineDate $ text post.displayDate
  h1 $ a ! href ("/" <> post.url) $ text post.title
  content

viewPreview :: forall e. Post -> Markup e
viewPreview post = li $ do
  time ! datetime post.machineDate $ text post.displayDate
  h2 $ a ! href post.url $ text post.title
  p ! className "subtitle" $ text post.description
  a ! href ("/" <> post.url) $ text "Read more &arr;"

parser ::
  forall s m.
  StringLike s =>
  Monad m =>
  ParserT s m 
    { content :: String
    , date :: String
    , description :: String
    , title :: String
    }
parser = do
  -- TODO: This parser needs some work.
  --       1. It's sensitive to the order of the keys in the metadata.
  --          It expects a title in the first line, a description in the
  --          second line and so on. This is far from tragic but it also 
  --          gives a very bad UX.
  --       2. This library is probably not used like this.
  parseSeparator
  title <- parseSection "title"
  description <- parseSection "description"
  date <- parseSection "date"
  parseSeparator
  content <- parseContent
  pure { title: title, description: description, date: date, content: content }
  where
  parseSeparator = do
    skipWhiteSpace
    skipString "---"
    skipWhiteSpace
    assertNewline

  skipWhiteSpace = void $ many <<< oneOf $ [ ' ' , '\t' ]

  skipString = void <<< string

  skipChar = void <<< char

  parseSection s = do
    skipSpaces
    skipString s
    skipSpaces
    skipChar ':'
    parseSectionContent

  parseSectionContent = do
    result <- many $ noneOf [ '\n' ]
    assertNewline
    pure <<< trim <<< fromCharArray $ result

  assertNewline = void $ char '\n'

  parseContent = do
    result <- many anyChar
    pure <<< fromCharArray $ result
