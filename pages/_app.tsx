import 'lib/progress'
import { AppProps } from 'next/app'
import { ReactElement } from 'react'
import 'styles/global.css'
import 'typeface-overpass'
import 'typeface-overpass-mono'

export default function App({ Component, pageProps }: AppProps): ReactElement {
  return <Component {...pageProps} />
}
