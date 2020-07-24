import { render, RenderOptions } from '@testing-library/react'
import { ReactElement, ReactNode } from 'react'

type ProviderProps = { children?: ReactNode }

const Providers = ({ children }: ProviderProps) => {
  return <>{children}</>
}

const customRender = (ui: ReactElement, options: RenderOptions = {}) =>
  render(ui, { wrapper: Providers, ...options })

export * from '@testing-library/react'
export { customRender as render }
