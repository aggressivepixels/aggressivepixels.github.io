import { name as appName } from 'app.json'
import Layout from 'components/layout'
import Head from 'next/head'
import { ReactElement } from 'react'
import { Post as PostModel, posts, previews } from 'lib/posts'
import Title from 'components/title'
import { GetStaticProps, GetStaticPaths } from 'next'

type Props = {
  post: PostModel
}

export default function Post({ post }: Props): ReactElement {
  return (
    <Layout>
      <Head>
        <title>{appName}</title>
      </Head>
      <article>
        <Title>{post.title}</Title>
        <div
          className="prose pt-4 pb-12 max-w-none"
          dangerouslySetInnerHTML={{ __html: post.content }}
        />
      </article>
    </Layout>
  )
}

export const getStaticProps: GetStaticProps<Props, { slug: string }> = async ({
  params,
}) => {
  if (!params) {
    throw new Error('no params received')
  }

  const post = posts.find((p) => p.slug === params.slug)
  if (!post) {
    throw new Error('post not found')
  }

  return { props: { post } }
}

export const getStaticPaths: GetStaticPaths = async () => {
  return {
    paths: previews.map((p) => `/blog/${p.slug}`),
    fallback: false,
  }
}
