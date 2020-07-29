import Head from 'next/head'
import { ReactElement } from 'react'
import { name as appName } from 'app.json'
import Layout from 'components/layout'
import Title from 'components/title'
import Link from 'next/link'

export default function Contact(): ReactElement {
  return (
    <Layout>
      <Head>
        <title>Not found &mdash; {appName}</title>
      </Head>
      <Title>
        <h1>Not found</h1>
      </Title>
      <p className="my-4">
        The page you are looking for doesn&rsquo;t seem to exist.
      </p>
      <Link href="/">
        <a className="text-orange-500">Go home</a>
      </Link>
    </Layout>
  )
}
