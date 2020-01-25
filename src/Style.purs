module Style (sheet, accentColor) where

import Prelude

import CSS
import CSS.Common
import CSS.ListStyle.Type
import CSS.Overflow
import CSS.Size
import CSS.Text.Whitespace
import CSS.TextAlign as TA
import CSS.Text.Transform
import Data.NonEmpty (singleton)

primaryTextColor = rgba 0 0 0 0.87
secondaryTextColor = rgba 0 0 0 0.6
accentColor = rgb 50 115 220
separatorColor = rgb 219 219 219
darkerBackgroundColor = rgb 245 245 245

sheet :: Rendered
sheet = render do
  body ? do
    color secondaryTextColor
    fontFamily [ "Rubik" ] (singleton sansSerif)

  a & anyLink ?
    color accentColor

  (h1 <> h2 <> h3 <> h4 <> h5 <> h6) ? do
    color primaryTextColor
    fontFamily [ "Rajdhani" ] (singleton sansSerif)

  footer ? do
    backgroundColor darkerBackgroundColor
    borderTop solid (px 1.0) separatorColor
    padding (em 1.0) (em 1.0) (em 1.0) (em 1.0)
    TA.textAlign TA.center

  footer |* p ? do
    marginTop (em 0.5)
    marginBottom (em 0.5)

  pre ? do
    color primaryTextColor
    overflow overflowAuto
    wordWrap "normal"
    textWhitespace whitespacePre
    backgroundColor darkerBackgroundColor
    borderRadius (em 1.0) (em 1.0) (em 1.0) (em 1.0)
    padding (em 1.0) (em 1.0) (em 1.0) (em 1.0)
    marginTop (em 0.5)
    marginBottom (em 0.5)

  code ?
    fontFamily [ "Fira Mono" ] (singleton monospace)

  nav ? do
    backgroundColor darkerBackgroundColor
    borderBottom solid (px 1.0) separatorColor

  nav |* ul ? do
    listStyleType none
    margin nil nil nil nil
    paddingLeft (em 1.0)
    paddingRight (em 1.0)
    paddingTop (em 1.0)

  nav |* (ul |* li) ?
    paddingBottom (em 0.8)

  nav |* (ul |* (li |* (a & anyLink))) ? do
    color secondaryTextColor
    textDecoration noneTextDecoration

  nav |* (ul |* (li |* (a & byClass "logo"))) ? do
    color accentColor
    fontFamily [ "Rajdhani" ] (singleton sansSerif)
    fontSize (em 1.5)
    textTransform uppercase
    fontWeight bold

  article ? do
    paddingTop (em 1.5)
    paddingBottom (em 1.5)
    paddingLeft (em 1.0)
    paddingRight (em 1.0)

  article |* (time |+ h1) ?
    marginTop nil

  ul & byClass "posts" ? do
    listStyleType none
    margin nil nil nil nil
    paddingLeft (em 1.0)
    paddingRight (em 1.0)
    paddingTop (em 1.5)

  (ul & byClass "posts") |* li ?
    paddingBottom (em 2.0)

  (ul & byClass "posts") |* (li |* (time |+ h2)) ? do
    marginTop (em 0.25)
    marginBottom (em 0.25)

  (ul & byClass "posts") |* (li |* (p & byClass "subtitle")) ? do
    margin nil nil nil nil
    marginBottom (em 0.25)
    color primaryTextColor

  (html <> body) ?
    height (pct 100.0)

  body ? do
    display flex
    flexDirection column

  main ? do
    flexGrow 1
    lineHeight (unitless 1.5)

wordWrap :: String -> CSS
wordWrap = key $ fromString "word-wrap"

monospace :: GenericFontFamily
monospace = GenericFontFamily $ fromString "monospace"

time :: Selector
time = fromString "time"
