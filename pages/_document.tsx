import NextDocument, { Html, Head, Main, NextScript } from 'next/document'

export default class Document extends NextDocument {
  render() {
    return (
      <Html lang="en">
        <Head />
        <body className="antialiased bg-white text-gray-600">
          <Main />
          <NextScript />
        </body>
      </Html>
    )
  }
}
