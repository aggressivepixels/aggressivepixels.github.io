import Head from 'next/head'
import { ReactElement } from 'react'

export default function Home(): ReactElement {
  return (
    <div className="max-w-screen-sm mx-auto">
      <Head>
        <title>Home</title>
      </Head>
      <h1>Home</h1>
    </div>
  )
}
