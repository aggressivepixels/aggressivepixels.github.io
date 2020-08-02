import Head from 'next/head'
import { ReactElement } from 'react'
import { name as appName } from 'app.json'
import Layout from 'components/layout'
import Title from 'components/title'

export default function Contact(): ReactElement {
  return (
    <Layout>
      <Head>
        <title>Contact &mdash; {appName}</title>
      </Head>
      <Title>
        <h1 className="mb-6">Wanna chat?</h1>
      </Title>
      <p>I&lsquo;ll add some contact information here later. Promise!</p>
    </Layout>
  )
}
