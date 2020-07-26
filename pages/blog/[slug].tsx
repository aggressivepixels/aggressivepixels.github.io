import { name as appName } from 'app.json'
import Layout from 'components/layout'
import Title from 'components/title'
import { pipe } from 'fp-ts/lib/function'
import * as TE from 'fp-ts/lib/TaskEither'
import { getSlugs, Post as PostModel, posts } from 'lib/posts'
import { GetStaticPaths, GetStaticProps } from 'next'
import Head from 'next/head'
import { ReactElement } from 'react'
import { unsafeToPromise } from 'lib/task-either-utils'

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

export const getStaticPaths: GetStaticPaths = () =>
  pipe(
    getSlugs,
    TE.map((slugs) => ({
      paths: slugs.map((s) => `/blog/${s}`),
      fallback: false,
    })),
    unsafeToPromise
  )()
