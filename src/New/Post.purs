module New.Post (Post(..), viewEntry, viewContent) where

import Prelude
import Data.Char.Unicode (isAlphaNum)
import Data.DateTime (DateTime)
import Data.Enum (fromEnum)
import Data.Formatter.DateTime (Formatter, FormatterCommand(..))
import Data.Formatter.DateTime as DateTimeFormatter
import Data.List as List
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

viewEntry :: Post -> Markup Void
viewEntry (Post post) =
  li do
    viewDateTime post.dateTime
    h2 $ a ! href url $ text post.title
    p ! className "subtitle" $ text post.description
    a ! href url $ text "Read more &rarr;"
  where
  url = postURL post.slug

viewContent :: Post -> Markup Void -> Markup Void
viewContent (Post post) content =
  article do
    viewDateTime post.dateTime
    h1 $ a ! href (postURL post.slug) $ text post.title
    content

viewDateTime :: DateTime -> Markup Void
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
