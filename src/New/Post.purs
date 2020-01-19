module New.Post (Post(..), viewEntry, viewContent, parser) where

import Prelude
import Control.Alt ((<|>))
import Data.Array as Array
import Data.Array ((:), many)
import Data.Char.Unicode as Unicode
import Data.DateTime (DateTime)
import Data.Formatter.DateTime (Formatter, FormatterCommand(..))
import Data.Formatter.DateTime as DateTimeFormatter
import Data.List as List
import Data.Maybe (Maybe(..))
import Data.String.CodeUnits (fromCharArray, toCharArray)
import Data.String.Common (joinWith, replaceAll, toLower, trim)
import Data.String.Pattern (Pattern(..), Replacement(..))
import Data.Tuple (Tuple(..))
import Text.Parsing.Parser (ParserT)
import Text.Parsing.Parser.Combinators ((<?>), skipMany, try)
import Text.Parsing.Parser.String (anyChar, char, noneOf, oneOf, string)
import Text.Smolder.HTML (a, article, h1, h2, li, p, time)
import Text.Smolder.HTML.Attributes (className, datetime, href)
import Text.Smolder.Markup (Markup, (!), text)

newtype Post
  = Post
  { title :: String
  , description :: String
  , slug :: String
  , dateTime :: DateTime
  }

derive instance eqPost :: Eq Post

instance ordPost :: Ord Post where
  compare (Post a) (Post b) = compare a.dateTime b.dateTime

viewEntry :: forall e. Post -> Markup e
viewEntry (Post post) =
  li do
    viewDateTime post.dateTime
    h2 $ a ! href url $ text post.title
    p ! className "subtitle" $ text post.description
    a ! href url $ text "Read more &rarr;"
  where
  url = postURL post.slug

viewContent :: forall e. Post -> Markup e -> Markup e
viewContent (Post post) content =
  article do
    viewDateTime post.dateTime
    h1 $ a ! href (postURL post.slug) $ text post.title
    content

viewDateTime :: forall e. DateTime -> Markup e
viewDateTime dateTime = time ! datetime machineDate $ text displayDate
  where
  displayDate = DateTimeFormatter.format displayDateFormatter dateTime

  machineDate = DateTimeFormatter.format machineDateFormatter dateTime

postURL :: String -> String
postURL slug = "posts" <> "/" <> slug <> ".html"

displayDateFormatter :: Formatter
displayDateFormatter =
  List.fromFoldable
    [ MonthFull
    , Placeholder " "
    , DayOfMonthTwoDigits
    , Placeholder ", "
    , YearFull
    ]

machineDateFormatter :: Formatter
machineDateFormatter =
  List.fromFoldable
    [ YearFull
    , Placeholder "-"
    , MonthTwoDigits
    , Placeholder "-"
    , DayOfMonthTwoDigits
    ]

-- The logic for creating the slug was taken from here:
-- https://robertwpearce.com/hakyll-pt-5-generating-custom-post-filenames-from-a-title-slug.html
toSlug :: String -> String
toSlug =
  replaceAll (Pattern "&") (Replacement "and")
    >>> replaceAll (Pattern "'") (Replacement "")
    >>> toCharArray
    >>> map keepAlphaNum
    >>> fromCharArray
    >>> toLower
    >>> words
    >>> joinWith "-"
  where
  keepAlphaNum c
    | Unicode.isAlphaNum c = c
    | otherwise = ' '

-- Taken from here: 
-- https://github.com/cdepillabout/purescript-words-lines
words :: String -> Array String
words = map fromCharArray <<< go <<< toCharArray
  where
  go s = case Array.uncons $ Array.dropWhile Unicode.isSpace s of
    Nothing -> []
    Just { head, tail } ->
      let
        { init, rest } = Array.span (not Unicode.isSpace) (head : tail)
      in
        init : go rest

parser :: forall m. Monad m => ParserT String m (Tuple Post String)
parser = Tuple <$> metadata <*> content
  where
  metadata = do
    separator
    -- TODO: Allow to write these fields in any order.
    -- TODO: Add tags field.
    title <- section "title" stringContent
    description <- section "description" stringContent
    dateTime <- section "date" dateContent
    separator
    pure
      $ Post
          { title: title
          , description: description
          , dateTime: dateTime
          , slug: toSlug title
          }

  content =
    many anyChar
      <#> fromCharArray
      <#> trim

  section :: forall a. String -> ParserT String m a -> ParserT String m a
  section title sectionParser = do
    skipMany whitespace
    void $ string title
    skipMany whitespace
    void $ char ':'
    result <- sectionParser
    void eol
    pure result

  stringContent =
    many (noneOf [ '\n', '\r' ])
      <#> fromCharArray
      <#> trim

  dateContent = do
    skipMany whitespace
    date <- DateTimeFormatter.unformatParser machineDateFormatter
    skipMany whitespace
    pure date

  separator = do
    skipMany whitespace
    void $ string "---"
    skipMany whitespace
    void eol

  whitespace = oneOf [ ' ', '\t' ]

  eol =
    try (string "\n\r")
      <|> try (string "\r\n")
      <|> string "\n"
      <|> string "\r"
      <?> "end of line"
