import { format } from 'date-fns'
import * as A from 'fp-ts/lib/Array'
import * as E from 'fp-ts/lib/Either'
import { pipe } from 'fp-ts/lib/function'
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
import { serializedDateFormat } from './post-date-format'

const postsDir = path.join(process.cwd(), 'posts')

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

export const getSlugs = (): TE.TaskEither<Error, string[]> =>
  pipe(readdir(postsDir), TE.map(A.map(slugify)))

export const getPost = (slug: string): TE.TaskEither<Error, Post> =>
  pipe(
    readPostWithFrontMatter(slug),
    TE.chain(({ title, date, content }) =>
      pipe(
        splitExcerpt(content, title),
        TE.map(([_excerpt, content]) => ({
          title,
          content,
          date,
        }))
      )
    ),
    TE.chain(({ title, date, content }) =>
      pipe(
        markdownToHTML(content),
        TE.map((markdownContent) => ({
          title,
          content: markdownContent,
          date: PostDate.encode(date),
        }))
      )
    )
  )

export const getPreviews = (): TE.TaskEither<Error, Preview[]> =>
  pipe(getSlugs(), TE.chain(A.traverse(TE.taskEither)(getPreview)))

const getPreview = (slug: string) =>
  pipe(
    readPostWithFrontMatter(slug),
    TE.chain(({ title, date, content }) =>
      pipe(
        splitExcerpt(content, title),
        TE.map(([excerpt, _content]) => ({
          title,
          excerpt,
          date,
        }))
      )
    ),
    TE.chain(({ title, date, excerpt }) =>
      pipe(
        markdownToHTML(excerpt),
        TE.map((markdownExcerpt) => ({
          title,
          slug,
          excerpt: markdownExcerpt,
          date: PostDate.encode(date),
        }))
      )
    )
  )

const readPostWithFrontMatter = (slug: string) =>
  pipe(readPost(slug), TE.map(matter), TE.chain(extractFrontMatter))

const extractFrontMatter = <I extends matter.Input>({
  content,
  data,
}: matter.GrayMatterFile<I>) =>
  pipe(
    TE.fromEither(FrontMatter.decode(data)),
    TE.bimap(
      (e) => new Error(JSON.stringify(e)),
      ({ title, date }) => ({ title, date, content })
    )
  )

const readPost = (slug: string): TE.TaskEither<Error, Buffer> =>
  readFile(path.join(postsDir, slug + '.md'), 'utf8')

const readdir: (pl: fs.PathLike) => TE.TaskEither<Error, string[]> = TE.taskify(
  fs.readdir
)

const readFile: (
  pl: fs.PathLike,
  options: string
) => TE.TaskEither<Error, Buffer> = TE.taskify(fs.readFile)

function slugify(s: string) {
  return s.replace(/\.md$/, '')
}

function markdownToHTML(s: string): TE.TaskEither<Error, string> {
  return pipe(
    TE.tryCatch(
      () =>
        unified()
          .use(remarkParse)
          .use(remarkRehype)
          .use(rehypeSlug)
          .use(rehypeAutolinkHeadings, {
            behavior: 'wrap',
          })
          .use(rehypeHighlight)
          .use(rehypeStringify)
          .process(s),
      E.toError
    ),
    TE.map((vf) => vf.toString())
  )
}

function splitExcerpt(
  s: string,
  title: string
): TE.TaskEither<Error, [string, string]> {
  const separator = '<!-- end excerpt -->'

  if (!s.includes(separator)) {
    return TE.left(new Error(`${title} is missing excerpt`))
  }

  const [excerpt, ...rest] = s.split(separator)
  const content = rest.join(separator)
  return TE.right([excerpt, content])
}
