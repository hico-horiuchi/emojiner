# Description:
#   毎日0時に絵文字のリストを取得して保存(上書き)
#
# Configuration:
#   HUBOT_CHANGELOG_ROOM
#   HUBOT_SLACK_TOKEN

cronJob = require('cron').CronJob
querystring = require('querystring')
request = require('request')
_ = require('underscore')

module.exports = (robot) ->
  KEY = 'slack-emoji-list'
  ROOM = process.env.HUBOT_CHANGELOG_ROOM ? 'general'

  getEmojiList = (args) ->
    args = args ? []
    options =
      url: 'https://slack.com/api/emoji.list'
      qs:
        token: process.env.HUBOT_SLACK_TOKEN
    request.get options, (err, res, body) ->
      if err? or res.statusCode isnt 200
        return robot.logger.error(err)
      json = JSON.parse(body)
      unless json.ok
        return robot.logger.error(json.error)
      args.list = []
      for name, url of json.emoji
        if url.match(/^alias:/)
          continue
        args.list.push(name)
      if args.callbacks? and args.callbacks.length > 0
        args.callbacks.shift()(args)

  postChangelog = (args) ->
    args = args ? []
    previous = robot.brain.get(KEY) ? []
    diff = _.difference(args.list, previous)
    if diff.length is 0
      return args.callbacks.shift()(args)
    diff = diff.map (name) ->
      ":#{name}:"
    msg = "昨日追加されたEmojiは *#{diff.length}個* です!\n#{diff.join(' ')}"
    robot.send({ room: ROOM }, msg)
    if args.callbacks? and args.callbacks.length > 0
      args.callbacks.shift()(args)

  updateEmojiList = (args) ->
    args = args ? []
    robot.brain.set(KEY, args.list)
    if args.callbacks? and args.callbacks.length > 0
      args.callbacks.shift()(args)

  changelogCron = new cronJob
    cronTime: '0 0 0 * * *'
    onTick: ->
      args =
        callbacks: [postChangelog, updateEmojiList]
      getEmojiList(args)
    start: true
    timeZone: 'Asia/Tokyo'
