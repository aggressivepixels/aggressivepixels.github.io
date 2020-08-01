import { name as appName } from 'app.json'
import Layout from 'components/layout'
import Title from 'components/title'
import { getPreviews, Preview as PreviewType } from 'lib/posts'
import { GetStaticProps } from 'next'
import Head from 'next/head'
import Link from 'next/link'
import { ReactElement } from 'react'

type Props = {
  previews: PreviewType[]
}

type PreviewProps = PreviewType

export const getStaticProps: GetStaticProps<Props> = () =>
  getPreviews().then((previews) => ({ props: { previews } }))

export default function Blog({ previews }: Props): ReactElement {
  const [latest, ...rest] = previews

  return (
    <Layout>
      <Head>
        <title>Blog &mdash; {appName}</title>
      </Head>
      <Title>Latest post</Title>
      <div className="border-b border-gray-200 mb-4">
        <Preview {...latest} />
      </div>
      <Title>Older posts</Title>
      <ul className="pb-4">
        {rest.map((p) => (
          <li key={p.slug}>
            <Preview {...p} />
          </li>
        ))}
      </ul>
    </Layout>
  )
}

function Preview({
  title,
  slug,
  date,
  displayDate,
  excerpt,
}: PreviewProps): ReactElement {
  return (
    <article className="space-y-1 py-4">
      <time dateTime={date}>{displayDate}</time>
      <h2>
        <Link href="/blog/[slug]" as={`/blog/${slug}`}>
          <a className="font-semibold leading-snug text-2xl text-gray-900">
            {title}
          </a>
        </Link>
      </h2>
      <div className="prose" dangerouslySetInnerHTML={{ __html: excerpt }} />
      <Link href="/blog/[slug]" as={`/blog/${slug}`}>
        <a className="inline-block text-orange-500">Read more &rarr;</a>
      </Link>
    </article>
  )
}
