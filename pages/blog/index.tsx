import { name as appName } from 'app.json'
import Layout from 'components/layout'
import Head from 'next/head'
import Link from 'next/link'
import { ReactElement } from 'react'

const posts = [
  {
    title: 'Example post',
    slug: 'example-post',
    date: 'December 21, 2020',
    preview: 'This is an example preview.\n Here is some more text.',
  },
  {
    title: 'Example post',
    slug: 'example-post',
    date: 'December 21, 2020',
    preview: 'This is an example preview.\n Here is some more text.',
  },
  {
    title: 'Example post',
    slug: 'example-post',
    date: 'December 21, 2020',
    preview: 'This is an example preview.\n Here is some more text.',
  },
  {
    title: 'Example post',
    slug: 'example-post',
    date: 'December 21, 2020',
    preview: 'This is an example preview.\n Here is some more text.',
  },
  {
    title: 'Example post',
    slug: 'example-post',
    date: 'December 21, 2020',
    preview: 'This is an example preview.\n Here is some more text.',
  },
  {
    title: 'Example post',
    slug: 'example-post',
    date: 'December 21, 2020',
    preview: 'This is an example preview.<br/> Here is some more text.',
  },
]

export default function Blog(): ReactElement {
  const [latest, ...rest] = posts

  return (
    <Layout>
      <Head>
        <title>Blog &mdash; {appName}</title>
      </Head>
      <p className="font-semibold text-3xl sm:text-4xl text-gray-900">
        Latest post
      </p>
      <div className="border-b border-gray-200">
        <Preview {...latest} />
      </div>
      <p className="font-semibold text-3xl sm:text-4xl text-gray-900 pt-4">
        Older posts
      </p>
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

type PreviewProps = typeof posts[0]

function Preview({ title, slug, date, preview }: PreviewProps): ReactElement {
  return (
    <article className="leading-relaxed py-4">
      <time>{date}</time>
      <h2>
        <Link href="/blog/[slug]" as={`/blog/${slug}`}>
          <a className="font-semibold text-2xl text-gray-900">{title}</a>
        </Link>
      </h2>
      <div dangerouslySetInnerHTML={{ __html: preview }} />
      <Link href="/blog/[slug]" as={`/blog/${slug}`}>
        <a className="leading-loose text-orange-500">Read more &rarr;</a>
      </Link>
    </article>
  )
}
