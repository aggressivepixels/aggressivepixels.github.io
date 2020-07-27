import { format, parse, compareDesc } from 'date-fns'
import * as Either from 'fp-ts/lib/Either'
import { promises as fs } from 'fs'
import matter from 'gray-matter'
import * as t from 'io-ts'
import { PathReporter } from 'io-ts/lib/PathReporter'
import { serializedDateFormat } from 'lib/post-date-format'
import path from 'path'
import rehypeAutolinkHeadings from 'rehype-autolink-headings'
import rehypeHighlight from 'rehype-highlight'
import rehypeSlug from 'rehype-slug'
import rehypeStringify from 'rehype-stringify'
import remarkParse from 'remark-parse'
import remarkRehype from 'remark-rehype'
import unified from 'unified'

const POSTS_DIR = path.join(process.cwd(), 'posts')
const EXCERPT_SEPARATOR = '<!-- end excerpt -->'

export type Post = {
  title: string
  date: string
  content: string
}

export type Preview = {
  title: string
  slug: string
  date: string
  excerpt: string
}

const PostDate = new t.Type<Date, string>(
  'PostDate',
  (u): u is Date => u instanceof Date,
  (u, c) => (u instanceof Date ? t.success(u) : t.failure(u, c)),
  (d) => format(d, serializedDateFormat)
)

const FrontMatter = t.type({
  title: t.string,
  date: PostDate,
})

export async function getSlugs(): Promise<string[]> {
  const files = await fs.readdir(POSTS_DIR)
  return files.map(slugify)
}

export async function getPost(slug: string): Promise<Post> {
  try {
    const { title, date, rawContent } = await readPost(slug)
    const [, markdownContent] = splitExcerpt(rawContent)
    const content = await markdownToHTML(markdownContent)

    return {
      title,
      content,
      date: PostDate.encode(date),
    }
  } catch (err) {
    throw new Error(`getting post for ${slug}: ${err}`)
  }
}

export async function getPreviews(): Promise<Preview[]> {
  const slugs = await getSlugs()
  return Promise.all(slugs.map(getPreview)).then((previews) =>
    previews.sort((a, b) =>
      compareDesc(
        parse(a.date, serializedDateFormat, 0),
        parse(b.date, serializedDateFormat, 0)
      )
    )
  )
}

async function getPreview(slug: string): Promise<Preview> {
  try {
    const { title, date, rawContent } = await readPost(slug)
    const [excerptContent] = splitExcerpt(rawContent)
    const excerpt = await markdownToHTML(excerptContent)

    return {
      title,
      slug,
      excerpt,
      date: PostDate.encode(date),
    }
  } catch (err) {
    throw new Error(`getting preview for ${slug}: ${err}`)
  }
}

type ReadPostResult = {
  title: string
  date: Date
  rawContent: string
}

async function readPost(slug: string): Promise<ReadPostResult> {
  const filepath = path.join(POSTS_DIR, unslugify(slug))
  const file = await fs.readFile(filepath)
  const { data, content: rawContent } = matter(file)

  try {
    const { title, date } = fromDecoder(FrontMatter, data)
    return { title, date, rawContent }
  } catch (err) {
    throw `parsing front matter: ${err}`
  }
}

function slugify(filename: string): string {
  return filename.replace(/\.md$/, '')
}

function unslugify(slug: string): string {
  return `${slug}.md`
}

function splitExcerpt(rawContent: string): [string, string] {
  if (!rawContent.includes(EXCERPT_SEPARATOR)) {
    throw 'missing excerpt'
  }

  const [excerpt, ...rest] = rawContent.split(EXCERPT_SEPARATOR)
  return [excerpt, rest.join(EXCERPT_SEPARATOR)]
}

function markdownToHTML(markdown: string): Promise<string> {
  return unified()
    .use(remarkParse)
    .use(remarkRehype)
    .use(rehypeSlug)
    .use(rehypeAutolinkHeadings, {
      behavior: 'wrap',
    })
    .use(rehypeHighlight)
    .use(rehypeStringify)
    .process(markdown)
    .then((vfile) => vfile.toString())
}

function fromDecoder<I, A>(decoder: t.Decoder<I, A>, value: I): A {
  const result = decoder.decode(value)
  if (Either.isLeft(result)) {
    throw PathReporter.report(result).join(', ')
  }

  return result.right
}
