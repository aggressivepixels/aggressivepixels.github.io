import { ReactElement, ReactNode } from 'react'

type Props = {
  children: ReactNode
}

export default function Title({ children }: Props): ReactElement {
  return (
    <div className="font-semibold text-gray-900 text-3xl sm:text-4xl">
      {children}
    </div>
  )
}
