# Description:
#   毎日0時に絵文字のリストを取得して保存(上書き)
#
# Configuration:
#   HUBOT_CHANGELOG_CHANGELOG_ROOM
#   HUBOT_SLACK_TOKEN

cronJob = require('cron').CronJob
querystring = require('querystring')
request = require('request')
_ = require('underscore')

module.exports = (robot) ->
  KEY = 'slack-emoji-list'
  CHANGELOG_ROOM = process.env.HUBOT_CHANGELOG_CHANGELOG_ROOM ? 'general'

  getEmojiList = (args) ->
    args = args ? []
    robot.adapter.client.web.emoji.list (err, info) ->
      if err?
        return robot.logger.error(err)
      unless info.ok
        return robot.logger.error(info.error)
      args.list = []
      for name, url of info.emoji
        if url.match(/^alias:/)
          continue
        args.list.push(name)
      if args.callbacks? and args.callbacks.length > 0
        args.callbacks.shift()(args)

  getChannelsList = (args) ->
    args = args ? []
    robot.adapter.client.web.channels.list (err, info) ->
      if err?
        return robot.logger.error(err)
      unless info.ok
        return robot.logger.error(info.error)
      args.channel_name = args.channel_name  ? ''
      for channel in info.channels
        if channel.name is args.channel_name
          args.channel_id = channel.id
          break
      if args.callbacks? and args.callbacks.length > 0
        args.callbacks.shift()(args)

  postChangelog = (args) ->
    args = args ? []
    previous = robot.brain.get(KEY) ? []
    diff = _.difference(args.list, previous)
    if diff.length is 0
      if args.callbacks? and args.callbacks.length > 0
        args.callbacks.shift()(args)
      else
        return
    diff = diff.map (name) ->
      ":#{name}:"
    msg =  "昨日追加された絵文字は *#{diff.length}個* です!\n"
    msg += "#{diff.slice(0, 10).join(' ')}#{' ...' if diff.length > 10}\n"
    msg += "#{URL.replace(/\/$/, '')}/changelog"
    robot.send({ room: args.channel_id }, msg)
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
        channel_name: CHANGELOG_ROOM.replace(/^#/, '')
        callbacks: [getChannelsList, postChangelog, updateEmojiList]
      getEmojiList(args)
    start: true
    timeZone: 'Asia/Tokyo'
