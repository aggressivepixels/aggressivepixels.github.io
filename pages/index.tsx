import Head from 'next/head'
import { ReactElement } from 'react'
import { name as appName } from 'app.json'
import Layout from 'components/layout'
import Title from 'components/title'

export default function Home(): ReactElement {
  return (
    <Layout>
      <Head>
        <title>{appName}</title>
      </Head>
      <Title>Hello!</Title>
      <p>My name&lsquo;s Jonathan, and I&lsquo;m a web developer.</p>
      <p>There will be some stuff here later.</p>
    </Layout>
  )
}
