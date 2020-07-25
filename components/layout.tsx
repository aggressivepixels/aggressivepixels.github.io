import Nav from 'components/nav'
import { ReactElement, ReactNode } from 'react'

type Props = { children: ReactNode }

export default function Layout({ children }: Props): ReactElement {
  return (
    <div className="max-w-screen-md mx-auto">
      <Nav />
      <main className="px-4">{children}</main>
    </div>
  )
}