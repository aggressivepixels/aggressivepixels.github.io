module Skeleton
  ( view
  ) where

import Prelude hiding (div)

import CSS.Color as Color
import Data.Maybe (Maybe(..), maybe)
import Styles as Styles
import Text.Smolder.HTML
  ( a
  , body
  , div
  , footer
  , head
  , html
  , link
  , main
  , meta
  , nav
  , p
  , title
  )
import Text.Smolder.HTML.Attributes
  ( charset
  , className
  , content
  , href
  , lang
  , name
  , rel
  )
import Text.Smolder.Markup (Markup, (!), doctype, text)

view ::
  forall e.
  { title :: Maybe String
  , description :: Maybe String
  , content :: Markup e
  } -> Markup e
view page = do
  doctype "html"
  html ! lang "en" $ do
    head do
      meta ! charset "utf-8"
      meta ! name "viewport" ! content "width=device-width,initial-scale=1"
      meta ! name "theme-color" ! content (Color.toHexString Styles.accentColor)
      link ! rel "stylesheet" ! href "/css/styles.css"
      title $ text actualPageTitle
      meta ! name "author" ! content "Jonathan Hernández"
      case page.description of
        Just description -> meta ! name "description" ! content description
        Nothing -> text ""
    body do
      nav do
        div ! className Styles.navContentClass $ do
          a ! className Styles.logoClass ! href "/" $ text blogTitle
      main page.content
      footer do
        p $ text "Copyright &copy; 2020, Jonathan Hernández."
        p do
          text "Made with love, coffee and "
          a ! href "http://www.purescript.org/" $ text "PureScript"
          text "."
        p $ text "Proudly free of JavaScript."
  where
    blogTitle = "Aggressive Pixels"
    actualPageTitle =
      maybe blogTitle (_ <> " " <> "&mdash;" <> " " <> blogTitle) page.title
