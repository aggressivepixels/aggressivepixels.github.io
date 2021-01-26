import { name as appName } from 'app.json'
import CheckFilled from 'components/icons/check-filled'
import ExclamationFilled from 'components/icons/exclamation-filled'
import Loading from 'components/icons/loading'
import Layout from 'components/layout'
import Title from 'components/title'
import Head from 'next/head'
import { ReactElement, useState } from 'react'
import { useForm } from 'react-hook-form'

const FORM_ENDPOINT =
  'https://script.google.com/macros/s/AKfycbz4Sv0KQqAKGbfpZC7Huer01Y-uZ4d8P9JCwD3IPUsofFUbE0CfWyyJ/exec'

type Form = { name: string; email: string; message: string }
type Response = { result: boolean }

export default function Contact(): ReactElement {
  const { register, handleSubmit, errors, reset } = useForm<Form>()
  const [submitting, setSubmitting] = useState(false)
  const [showErrorAlert, setShowErrorAlert] = useState(false)
  const [showSuccessAlert, setShowSuccessAlert] = useState(false)

  async function onSubmit(form: Form) {
    if (submitting) {
      return
    }

    const formData = new FormData()
    formData.append('name', form.name)
    formData.append('email', form.email)
    formData.append('message', form.message)

    setSubmitting(true)

    try {
      const resp = await fetch(FORM_ENDPOINT, {
        method: 'POST',
        body: formData,
      })

      if (!resp.ok) {
        throw new Error('unknown error')
      }

      const { result }: Response = await resp.json()

      if (!result) {
        throw new Error('script error')
      }

      setShowSuccessAlert(true)
      setTimeout(setShowSuccessAlert, 3000, false)

      reset()
    } catch (err) {
      console.error('Contact: onSubmit:', err)

      setShowErrorAlert(true)
      setTimeout(setShowErrorAlert, 3000, false)
    } finally {
      setSubmitting(false)
    }
  }

  return (
    <Layout>
      <Head>
        <title>Contact &mdash; {appName}</title>
      </Head>
      <Title>
        <h1 className="mb-6">Contact</h1>
      </Title>
      <form onSubmit={handleSubmit(onSubmit)}>
        <div className="pt-5 pb-12 space-y-6">
          {/* NAME */}
          <div>
            <label
              htmlFor="name"
              className="block text font-medium text-gray-900"
            >
              Name
            </label>
            <div className="mt-1">
              <input
                ref={register({ required: true })}
                id="name"
                name="name"
                type="text"
                disabled={submitting}
                autoComplete="name"
                className="shadow-sm focus:ring-yellow-500 focus:border-yellow-500 mt-1 block w-full border-gray-300 rounded-md disabled:opacity-50"
              />
            </div>
            {errors.name ? (
              <p className="mt-2 text-sm text-red-500">Required</p>
            ) : null}
          </div>

          {/* EMAIL */}
          <div>
            <label htmlFor="email" className="block font-medium text-gray-900">
              Email
            </label>
            <div className="mt-1">
              <input
                ref={register({ required: true })}
                id="email"
                name="email"
                type="email"
                disabled={submitting}
                autoComplete="email"
                className="shadow-sm focus:ring-yellow-500 focus:border-yellow-500 mt-1 block w-full border-gray-300 rounded-md disabled:opacity-50"
              />
            </div>
            {errors.email ? (
              <p className="mt-2 text-sm text-red-500">Required</p>
            ) : null}
          </div>

          {/* MESSAGE */}
          <div>
            <label
              htmlFor="message"
              className="block font-medium text-gray-900"
            >
              Message
            </label>
            <div className="mt-1">
              <textarea
                ref={register({ required: true })}
                id="message"
                name="message"
                disabled={submitting}
                rows={4}
                className="shadow-sm focus:ring-yellow-500 focus:border-yellow-500 mt-1 block w-full border-gray-300 rounded-md disabled:opacity-50"
              />
            </div>
            {errors.message ? (
              <p className="mt-2 text-sm text-red-500">Required</p>
            ) : null}
          </div>

          {/* SEND */}
          <div className="text-right">
            <button
              type="submit"
              className={`${
                submitting ? 'cursor-not-allowed' : ''
              } inline-flex justify-center py-2 px-4 border border-transparent shadow-sm text-sm font-medium rounded-md text-white bg-yellow-600 hover:bg-yellow-700 focus:outline-none`}
            >
              {submitting ? (
                <span className="animate-spin -ml-1 mr-3 h-5 w-5 text-white">
                  <Loading />
                </span>
              ) : null}{' '}
              Send
            </button>
          </div>
        </div>
      </form>

      {/* ERROR ALERT */}
      <div
        className={`${
          showErrorAlert ? 'opacity-100' : 'opacity-0'
        } pointer-events-none py-8 px-4 fixed right-0 bottom-0 z-30 transition duration-300 ease-out transform scale-90`}
      >
        <div className="rounded-md shadow-2 px-4 py-3 bg-yellow-200 text-yellow-700">
          <p className="font-medium text-cool-gray-100">
            <span className="flex flex-row items-center">
              <span className="w-5 h-5 mr-2">
                <ExclamationFilled />
              </span>
              <span className="mt-1">
                An error has occured when sending your message, please try again
              </span>
            </span>
          </p>
        </div>
      </div>

      {/* SUCCESS ALERT */}
      <div
        className={`${
          showSuccessAlert ? 'opacity-100' : 'opacity-0'
        } pointer-events-none py-8 px-4 fixed right-0 bottom-0 z-30 transition duration-300 ease-out transform scale-90`}
      >
        <div className="rounded-md shadow-2 px-4 py-3 bg-green-200 text-green-700">
          <p className="font-medium text-cool-gray-100">
            <span className="flex flex-row items-center">
              <span className="w-5 h-5 mr-2">
                <CheckFilled />
              </span>
              <span className="mt-1">Message sent successfully</span>
            </span>
          </p>
        </div>
      </div>
    </Layout>
  )
}
