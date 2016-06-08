# Description:
#   今日追加された絵文字のリストを表示
#
# Commands:
#   hubot changelog - 今日追加された絵文字のリストを表示
#
# Configuration:
#   HUBOT_SLACK_TOKEN

querystring = require('querystring')
request = require('request')
_ = require('underscore')

module.exports = (robot) ->
  KEY = 'slack-emoji-list'
  NIL_MSG = '今日追加された絵文字はないよ! 職人さん頑張って!'

  getEmojiList = (args) ->
    args = args ? []
    options =
      url: 'https://slack.com/api/emoji.list'
      qs:
        token: process.env.HUBOT_SLACK_TOKEN
    request.get options, (err, res, body) ->
      if err? or res.statusCode isnt 200
        return args.msg.send("```\n#{err}\n```")
      json = JSON.parse(body)
      unless json.ok
        return args.msg.send("```\n#{json.error}\n```")
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
      return args.msg.send(NIL_MSG)
    diff = diff.map (name) ->
      ":#{name}: (#{name})"
    msg = "今日追加されたEmojiは *#{diff.length}個* です!\n#{diff.join(' ')}"
    args.msg.send(msg)
    if args.callbacks? and args.callbacks.length > 0
      args.callbacks.shift()(args)

  robot.respond /changelog$/i, (msg) ->
    args =
      msg: msg
      callbacks: [postChangelog]
    getEmojiList(args)
