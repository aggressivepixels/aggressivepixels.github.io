module Skeleton (wrap) where

import Prelude
import Data.Maybe (Maybe, maybe)
import Text.Smolder.HTML
  ( a
  , body
  , br
  , footer
  , html
  , head
  , title
  , meta
  , link
  , nav
  , ul
  , li
  , main
  )
import Text.Smolder.HTML.Attributes
  ( lang
  , charset
  , name
  , content
  , rel
  , href
  , className
  )
import Text.Smolder.Markup (Markup, (!), text)

wrap :: forall e. Maybe String -> Markup e -> Markup e
wrap pageTitle pageContent = html ! lang "en" $ do
  head $ do
    meta ! charset "utf-8"
    meta ! name "viewport" ! content "width=device-width,initial-scale=1"
    -- TODO: This color should be kept in sync with the CSS.
    meta ! name "theme-color" ! content "#00bfa5"
    -- TODO: This could also be defined in PureScript code using
    --       purescript-css, which could also help with the previous TODO.
    link ! rel "stylesheet" ! href "css/styles.css"
    title $ text actualPageTitle
  body $ do
    nav $ do
      ul $ do
        li $ a ! className "logo" ! href "/" $ text blogTitle
    main $ pageContent
    footer $ do
      -- TODO: This lines should probably be paragraphs instead.
      text "Copyright &copy; 2020, Jonathan Hernández."
      br
      text "Made with love, coffee and "
      a ! href "http://www.purescript.org/" $ text "PureScript"
      br
      text "Proudly free of JavaScript."
  where
  blogTitle = "Aggressive Pixels"
  actualPageTitle = 
    maybe blogTitle (_ <> " " <> "&mdash;" <> " " <> blogTitle) pageTitle
