const Sentry =  require('@sentry/node')

const handler = require('./handler')
const { BadRequest } = require('./errors')

Sentry.init({ dsn: process.env.SENTRY_KEY })

exports.handler = async ({ path }, context, callback) => {
  try {
    const [type, id, action] = path.split('/').slice(1)
    const body = await handler(type, id, action)
    callback(null, {
      statusCode: 200,
      headers: {
        'Content-Type': 'text/html'
      },
      body
    })
  } catch (error) {
    if (error instanceof BadRequest) {
      callback(null, {
        statusCode: 400,
        headers: {
          'Content-Type': 'text/html'
        },
        body: error.message
      })
    } else {
      console.log(error)
      Sentry.withScope(scope => {
        scope.setExtra('path', path)
        Sentry.captureException(error)
      })
      await Sentry.flush(2000)
    }
  }
}