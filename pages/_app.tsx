import { AppProps } from 'next/app'
import { ReactElement } from 'react'
import 'styles/global.css'

export default function App({ Component, pageProps }: AppProps): ReactElement {
  return <Component {...pageProps} />
}
