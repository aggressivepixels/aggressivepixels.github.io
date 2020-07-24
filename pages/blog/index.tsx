import Head from 'next/head'
import { ReactElement } from 'react'
import { name as appName } from 'app.json'
import Layout from 'components/layout'

export default function Blog(): ReactElement {
  return (
    <Layout>
      <Head>
        <title>{appName} &mdash; Blog</title>
      </Head>
      <h1>Blog</h1>
    </Layout>
  )
}
