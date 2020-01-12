module New.Post where

import Prelude
import Data.Char.Unicode (isAlphaNum)
import Data.Date (Date)
import Data.Date as Date
import Data.Enum (fromEnum)
import Text.Smolder.Markup (Markup, (!), text)
import Text.Smolder.HTML (a, article, h1, h2, li, p, time)
import Text.Smolder.HTML.Attributes (className, datetime, href)

newtype Post
  = Post
  { title :: String
  , description :: String
  , slug :: String
  , date :: Date
  }

derive instance eqPost :: Eq Post

instance ordPost :: Ord Post where
  compare (Post a) (Post b) = compare a.date b.date

viewEntry :: Post -> Markup Void
viewEntry (Post post) =
  li do
    h2 $ a ! href url $ text post.title
    p ! className "subtitle" $ text post.description
    a ! href url $ text "Read more &arr;"
  where
  url = postURL post.slug

viewContent :: Post -> Markup Void -> Markup Void
viewContent (Post post) content =
  article do
    h1 $ a ! href (postURL post.slug) $ text post.title
    content

postURL :: String -> String
postURL slug = "posts" <> "/" <> slug <> ".html"

displayDate :: Date -> String
displayDate date = month <> " " <> day <> ", " <> year
  where
  month = show $ Date.month date

  day = show $ fromEnum $ Date.day date

  year = show $ fromEnum $ Date.year date
