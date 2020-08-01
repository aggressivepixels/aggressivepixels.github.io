import { name as appName } from 'app.json'
import Layout from 'components/layout'
import Title from 'components/title'
import { getPost, getSlugs, Post as PostType } from 'lib/posts'
import { GetStaticPaths, GetStaticProps } from 'next'
import Head from 'next/head'
import Link from 'next/link'
import { ReactElement } from 'react'

type Props = PostType

type Params = {
  slug: string
}

export const getStaticProps: GetStaticProps<Props, Params> = ({ params }) => {
  if (!params) {
    throw new Error('params were undefined')
  }

  return getPost(params.slug).then((post) => ({ props: post }))
}

export const getStaticPaths: GetStaticPaths<Params> = () =>
  getSlugs().then((slugs) => ({
    paths: slugs.map((s) => `/blog/${s}`),
    fallback: false,
  }))

export default function Post({ title, slug, content }: Props): ReactElement {
  return (
    <Layout>
      <Head>
        <title>
          {title} &mdash; {appName}
        </title>
      </Head>
      <article>
        <Title>
          <h1>
            <Link href="/blog/[slug]" as={`/blog/${slug}`}>
              <a>{title}</a>
            </Link>
          </h1>
        </Title>
        <div
          className="prose pt-6 pb-12 max-w-none"
          dangerouslySetInnerHTML={{ __html: content }}
        />
      </article>
    </Layout>
  )
}
