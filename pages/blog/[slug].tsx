import { name as appName } from 'app.json'
import Layout from 'components/layout'
import Title from 'components/title'
import * as E from 'fp-ts/lib/Either'
import { pipe } from 'fp-ts/lib/function'
import * as TE from 'fp-ts/lib/TaskEither'
import { getPost, getSlugs, Post as PostModel } from 'lib/posts'
import { unsafeToPromise } from 'lib/task-either-utils'
import { GetStaticPaths, GetStaticProps } from 'next'
import Head from 'next/head'
import { ReactElement } from 'react'

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

type Params = {
  slug: string
}

export const getStaticProps: GetStaticProps<Props, Params> = ({ params }) =>
  pipe(
    params,
    E.fromNullable(new Error('params were undefined')),
    TE.fromEither,
    TE.chain(({ slug }) => getPost(slug)),
    TE.map((post) => ({ props: { post } })),
    unsafeToPromise
  )()

export const getStaticPaths: GetStaticPaths = () =>
  pipe(
    getSlugs(),
    TE.map((slugs) => ({
      paths: slugs.map((s) => `/blog/${s}`),
      fallback: false,
    })),
    unsafeToPromise
  )()
