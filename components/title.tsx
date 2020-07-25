import { ReactElement } from 'react'

type Props = {
  children: string
}

export default function Title({ children }: Props): ReactElement {
  return (
    <h1 className="font-semibold text-gray-900 text-3xl sm:text-4xl">
      {children}
    </h1>
  )
}
