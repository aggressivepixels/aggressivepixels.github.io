import { format } from 'date-fns'
import * as A from 'fp-ts/lib/Array'
import * as E from 'fp-ts/lib/Either'
import { pipe } from 'fp-ts/lib/function'
import * as IOE from 'fp-ts/lib/IOEither'
import * as TE from 'fp-ts/lib/TaskEither'
import fs from 'fs'
import matter from 'gray-matter'
import * as t from 'io-ts'
import path from 'path'
import rehypeAutolinkHeadings from 'rehype-autolink-headings'
import rehypeHighlight from 'rehype-highlight'
import rehypeSlug from 'rehype-slug'
import rehypeStringify from 'rehype-stringify'
import remarkParse from 'remark-parse'
import remarkRehype from 'remark-rehype'
import unified from 'unified'

const PostDate = new t.Type<Date, string>(
  'PostDate',
  (u): u is Date => u instanceof Date,
  (u, c) => (u instanceof Date ? t.success(u) : t.failure(u, c)),
  (d) => format(d, 'yyyy-MM-dd')
)

type PostDate = t.TypeOf<typeof PostDate>

export type Preview = {
  title: string
  date: string
  slug: string
  excerpt: string
}

export type Post = Preview & { content: string }

const FrontMatter = t.type({
  title: t.string,
  date: PostDate,
})

type FrontMatter = t.TypeOf<typeof FrontMatter>

const postsPath = path.join(process.cwd(), 'posts')
const files = fs.readdirSync(postsPath)

export const posts: Post[] = files.map((f) => {
  const excerptSeparator = '<!-- end excerpt -->'
  const filePath = path.join(postsPath, f)
  const slug = f.replace(/\.md$/, '')
  const file = matter.read(filePath)
  const frontMatter = FrontMatter.decode(file.data)
  if (E.isLeft(frontMatter)) {
    throw new Error(frontMatter.left.map(({ message }) => message).join(', '))
  }

  if (!file.content.includes(excerptSeparator)) {
    throw new Error('post is missing excerpt')
  }

  const [excerpt, ...rest] = file.content.split(excerptSeparator)
  const content = rest.join(excerptSeparator)

  function toHTML(s: string) {
    return unified()
      .use(remarkParse)
      .use(remarkRehype)
      .use(rehypeSlug)
      .use(rehypeAutolinkHeadings, {
        behavior: 'wrap',
      })
      .use(rehypeHighlight)
      .use(rehypeStringify)
      .processSync(s)
      .toString()
  }

  return {
    title: frontMatter.right.title,
    date: PostDate.encode(frontMatter.right.date),
    excerpt: toHTML(excerpt),
    content: toHTML(content),
    slug,
  }
})

export const previews: Preview[] = posts.map(
  ({ title, date, slug, excerpt }) => ({ title, date, slug, excerpt })
)

const toError = (u: unknown) => (u instanceof Error ? u : new Error(String(u)))

const getCWD: IOE.IOEither<Error, string> = IOE.tryCatch(
  () => process.cwd(),
  toError
)

const getPostsDir: IOE.IOEither<Error, string> = pipe(
  getCWD,
  IOE.map((cwd) => path.join(cwd, 'posts'))
)

const readdir: (pl: fs.PathLike) => TE.TaskEither<Error, string[]> = TE.taskify(
  fs.readdir
)

const slugify = (s: string) => s.replace(/\.md$/, '')

const getPosts: TE.TaskEither<Error, string[]> = pipe(
  TE.fromIOEither(getPostsDir),
  TE.chain(readdir)
)

export const getSlugs: TE.TaskEither<Error, string[]> = pipe(
  getPosts,
  TE.map(A.map(slugify))
)
