const fs = require('fs')
const path = require('path')
const { getModule } = require('awsdynamoutils')

const { BadRequest } = require('errors')

const {
  setNewValue,
  getByPK
} = getModule({})

const defaultParams = id => ({
  TableName: 'pomodoro_users',
  Key: { id }
})


const CONTENT = {
  POMODORO_NEWS_EMAIL: `<h1>We won't send you <a href="https://pomodoro.increaser.org">Pomodoro by Increaser</a> news!</h1>`,
  ASK_FOR_FEEDBACK: `<h1>We won't ask you for feedback!</h1>`
}

const HANDLER = {
  UNSUBSCRIBE: 'unsubscribe'
}

const TYPE = {
  POMODORO_NEWS_EMAIL: 'pomodoro-news-email',
  ASK_FOR_FEEDBACK: 'ask-for-feedback'
}

module.exports = async (type, id, handler) => {
  if (handler !== HANDLER.UNSUBSCRIBE) {
    throw new BadRequest(`handler "${handler}" is not supported`)
  }
  if (!Object.values(TYPE).includes(type)) {
    throw new BadRequest(`type "${type}" is not supported`)
  }
  const params = defaultParams(id)
  const userExists = await getByPK(params, ['id'])
  if (!userExists) {
    throw new BadRequest(`user with ${id} does not exist`)
  }

  const filePath = path.resolve(__dirname, `../templates/unsubscribe.html`)
  const html = await new Promise(resolve => fs.readFile(filePath, 'utf8', (_, data) => resolve(data)))
  if (type === TYPE.POMODORO_NEWS_EMAIL) {
    await setNewValue(params, 'ignorePomodoroNews', true)
  }

  const content = CONTENT[Object.entries(TYPE).find(([, v]) => v === type)[0]]
  return html.replace('{{content}}', content)
}