import { name as appName } from 'app.json'
import Layout from 'components/layout'
import Title from 'components/title'
import {
  getPost,
  getSlugs,
  Post as PostType,
  Preview as PreviewType,
  getPrevPreview,
  getNextPreview,
} from 'lib/posts'
import { GetStaticPaths, GetStaticProps } from 'next'
import Head from 'next/head'
import Link from 'next/link'
import { ReactElement } from 'react'
import ArrowNarrowLeft from 'components/icons/arrow-narrow-left'
import ArrowNarrowRight from 'components/icons/arrow-narrow-right'

type Props = {
  post: PostType
  prevPreview: PreviewType | null
  nextPreview: PreviewType | null
}

type Params = {
  slug: string
}

export const getStaticProps: GetStaticProps<Props, Params> = async ({
  params,
}) => {
  if (!params) {
    throw new Error('params were undefined')
  }

  const [post, prevPreview, nextPreview] = await Promise.all([
    getPost(params.slug),
    getPrevPreview(params.slug),
    getNextPreview(params.slug),
  ])

  return { props: { post, prevPreview, nextPreview } }
}

export const getStaticPaths: GetStaticPaths<Params> = () =>
  getSlugs().then((slugs) => ({
    paths: slugs.map((s) => `/blog/${s}`),
    fallback: false,
  }))

export default function Post({
  post: { title, slug, content },
  prevPreview,
  nextPreview,
}: Props): ReactElement {
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
        <div className="sm:flex-row sm:pb-6 flex flex-col pb-12">
          <div className="flex-1">
            {prevPreview !== null && (
              <div>
                <p>Previous post</p>
                <p className="mt-1 text-xl text-yellow-500">
                  <Link href="/blog/[slug]" as={`/blog/${prevPreview.slug}`}>
                    <a>
                      <span className="sm:inline-block hidden w-4 h-4 pt-px">
                        <ArrowNarrowLeft />
                      </span>{' '}
                      {prevPreview.title}
                    </a>
                  </Link>
                </p>
              </div>
            )}
          </div>
          <div className="flex-1">
            {nextPreview !== null && (
              <div className="sm:mt-0 mt-6">
                <p>Next post</p>
                <p className="mt-1 text-xl text-yellow-500">
                  <Link href="/blog/[slug]" as={`/blog/${nextPreview.slug}`}>
                    <a>
                      {nextPreview.title}{' '}
                      <span className="sm:inline-block hidden w-4 h-4 pt-px">
                        <ArrowNarrowRight />
                      </span>
                    </a>
                  </Link>
                </p>
              </div>
            )}
          </div>
        </div>
      </article>
    </Layout>
  )
}
