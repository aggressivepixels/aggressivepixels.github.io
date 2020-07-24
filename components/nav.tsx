import Link from 'next/link'
import { useRouter } from 'next/router'
import { ReactElement, useState } from 'react'
import { MenuAlt1 } from 'heroicons/react/outline'
import { name as appName } from 'app.json'

export default function Nav(): ReactElement {
  const [open, setOpen] = useState(false)

  return (
    <header className="bg-white border-b">
      <nav>
        <div className="flex items-center justify-between px-2">
          <Link href="/">
            <a className="uppercase font-semibold text-lg text-orange-500 px-2 pt-2 pb-1">
              {appName}
            </a>
          </Link>
          <button
            type="button"
            className="mx-1 my-2 text-gray-600 focus:text-orange-500 hover:text-orange-500 focus:outline-none"
            onClick={() => setOpen((prevOpen) => !prevOpen)}
          >
            <MenuAlt1 className="w-6 h-6 mx-1 my-2" />
          </button>
        </div>
        <div className={`flex flex-col pb-3 ${open ? 'block' : 'hidden'}`}>
          <NavLink title="Home" href="/" />
          <NavLink title="Blog" href="/blog" />
        </div>
      </nav>
    </header>
  )
}

type NavLinkProps = {
  title: string
  href: string
}

function NavLink({ title, href }: NavLinkProps) {
  const { route } = useRouter()

  return (
    <Link href={href}>
      <a
        className={`font-semibold uppercase mx-3 pt-2 pb-1 mt-1 hover:text-orange-500 focus:text-orange-500 text-center ${
          route == href ? 'text-orange-500' : 'text-gray-500'
        }`}
      >
        {title}
      </a>
    </Link>
  )
}
