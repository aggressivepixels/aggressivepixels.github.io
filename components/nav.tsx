import Link from 'next/link'
import { ReactElement } from 'react'
import { useRouter } from 'next/router'

export default function Nav(): ReactElement {
  const { route } = useRouter()
  const inBlog = route.startsWith('/blog')
  const inContact = route.startsWith('/contact')

  return (
    <div className="px-4 py-6">
      <Link href="/">
        <a className="uppercase font-semibold text-xl pt-1 text-gray-900">
          Aggressive
          <span className="text-orange-500">Pixels</span>
        </a>
      </Link>
      <div className="flex items-baseline pt-1">
        <NavLink href="/" title="Home" active={!inBlog && !inContact} />
        <NavLinkSeparator />
        <NavLink href="/blog" title="Blog" active={inBlog} />
        <NavLinkSeparator />
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
      <a className={`${active ? 'text-orange-500 text-xl' : 'text-base'}`}>
        {title}
      </a>
    </Link>
  )
}

function NavLinkSeparator() {
  return <span className="w-3" />
}
