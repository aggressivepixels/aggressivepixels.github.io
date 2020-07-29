import { name as appName } from 'app.json'
import Layout from 'components/layout'
import Title from 'components/title'
import { getPost, getSlugs, Post as PostModel } from 'lib/posts'
import { GetStaticPaths, GetStaticProps } from 'next'
import Head from 'next/head'
import { ReactElement } from 'react'

type Props = {
  post: PostModel
}

type Params = {
  slug: string
}

export const getStaticProps: GetStaticProps<Props, Params> = ({ params }) => {
  if (!params) {
    throw new Error('params were undefined')
  }

  return getPost(params.slug).then((post) => ({ props: { post } }))
}

export const getStaticPaths: GetStaticPaths<Params> = () =>
  getSlugs().then((slugs) => ({
    paths: slugs.map((s) => `/blog/${s}`),
    fallback: false,
  }))

export default function Post({ post }: Props): ReactElement {
  return (
    <Layout>
      <Head>
        <title>{appName}</title>
      </Head>
      <article>
        <Title>
          <h1>{post.title}</h1>
        </Title>
        <div
          className="prose pt-4 pb-12 max-w-none"
          dangerouslySetInnerHTML={{ __html: post.content }}
        />
      </article>
    </Layout>
  )
}
