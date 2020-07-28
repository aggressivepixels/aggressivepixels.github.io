import Link from 'next/link'
import { useRouter } from 'next/router'
import { ReactElement } from 'react'

export default function Nav(): ReactElement {
  const { asPath } = useRouter()
  const inBlog = asPath.startsWith('/blog')
  const inContact = asPath.startsWith('/contact')

  return (
    <div className="mx-4 py-6 sm:mb-6 sm:flex sm:justify-between">
      <Link href="/">
        <a className="uppercase font-semibold pt-1 select-none text-xl text-gray-900">
          Aggressive
          <span className="text-orange-500">Pixels</span>
        </a>
      </Link>
      <div className="flex items-baseline sm:items-center">
        <NavLink href="/" title="Home" active={!inBlog && !inContact} />
        <NavLink href="/blog" title="Blog" active={inBlog} />
        <NavLink href="/contact" title="Contact" active={inContact} />
      </div>
    </div>
  )
}

type NavLinkProps = {
  href: string
  title: string
  active: boolean
}

function NavLink({ href, title, active }: NavLinkProps) {
  return (
    <Link href={href}>
      <a
        className={`pt-1 mr-3 sm:ml-6 sm:mr-0 ${
          active ? 'text-orange-500 text-xl sm:text-lg' : 'text-base sm:text-lg'
        }`}
      >
        {title}
      </a>
    </Link>
  )
}
