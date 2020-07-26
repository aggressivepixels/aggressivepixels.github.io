import * as TE from 'fp-ts/lib/TaskEither'
import * as T from 'fp-ts/lib/Task'

export const unsafeToPromise: <A>(
  _: TE.TaskEither<Error, A>
) => T.Task<A> = TE.fold(
  (e) => () => Promise.reject(e),
  (params) => () => Promise.resolve(params)
)
