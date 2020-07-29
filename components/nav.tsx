import Menu from 'components/icons/menu'
import Link from 'next/link'
import { useRouter } from 'next/router'
import { ReactElement, useState } from 'react'

export default function Nav(): ReactElement {
  const { asPath } = useRouter()
  const inBlog = asPath.startsWith('/blog')
  const inContact = asPath.startsWith('/contact')

  const [menuOpen, setMenuOpen] = useState(false)

  return (
    <nav>
      <div className="py-4 flex justify-between items-center">
        <div className="ml-4">
          <Link href="/">
            <a className="uppercase font-semibold pt-1 select-none text-xl text-gray-900">
              Aggressive
              <span className="text-orange-500">Pixels</span>
            </a>
          </Link>
        </div>
        <div className="mr-3">
          <button
            className={`block h-8 w-8 p-1 rounded ${
              menuOpen
                ? 'text-orange-500 bg-orange-500 bg-opacity-25'
                : 'text-current'
            }`}
            onClick={() => setMenuOpen(!menuOpen)}
            type="button"
          >
            <Menu />
          </button>
        </div>
      </div>
      <div className={`mb-4 mx-3 ${menuOpen ? 'flex flex-col' : 'hidden'}`}>
        <NavLink href="/" title="Home" active={!inBlog && !inContact} />
        <NavLink href="/blog" title="Blog" active={inBlog} />
        <NavLink href="/contact" title="Contact" active={inContact} />
      </div>
    </nav>
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
        className={`text-xl pt-1 px-1 mb-1 ${active ? 'text-orange-500' : ''}`}
      >
        {title}
      </a>
    </Link>
  )
}
