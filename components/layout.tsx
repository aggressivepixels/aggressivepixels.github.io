import { ReactNode, ReactElement } from 'react'
import Nav from 'components/nav'

type Props = { children: ReactNode }

export default function Layout({ children }: Props): ReactElement {
  return (
    <div>
      <Nav />
      <main className="max-w-screen-sm mx-auto">{children}</main>
    </div>
  )
}
