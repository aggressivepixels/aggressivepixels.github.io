import Head from 'next/head'
import { ReactElement } from 'react'
import { name as appName } from 'app.json'
import Layout from 'components/layout'
import Title from 'components/title'

export default function Blog(): ReactElement {
  return (
    <Layout>
      <Head>
        <title>Blog &mdash; {appName}</title>
      </Head>
      <Title>Latest post</Title>
    </Layout>
  )
}
