module NotFound
  ( view
  ) where

import Prelude hiding (div)

import Styles as Styles
import Text.Smolder.HTML (a, div, h1, p)
import Text.Smolder.HTML.Attributes (className, href)
import Text.Smolder.Markup (Markup, text, (!))

view :: forall e. Markup e
view =
  div ! className Styles.notFoundClass $ do
    h1 ! className Styles.notFoundTitleClass $ text "404"
    p $ text "The page you are looking for doesn't seem to exist..."
    a ! href "/" $ text "Go to home page instead?"
