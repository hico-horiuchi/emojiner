# Description:
#   今日追加された絵文字のリストを表示
#
# URLs:
#   GET /changelog - 今日追加された絵文字のリストを表示

querystring = require('querystring')
request = require('request')
_ = require('underscore')

module.exports = (robot) ->
  KEY = 'slack-emoji-list'

  changelogPage = (list) ->
    """
<!DOCTYPE html>
<html>
  <head>
    <title>Changelog | Emojiner</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta content="width=device-width, initial-scale=1" name="viewport" />
    <link href="//maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" rel="stylesheet" />
    <link href="//maxcdn.bootstrapcdn.com/bootswatch/3.3.7/lumen/bootstrap.min.css" rel="stylesheet" />
    <link href="//maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css" rel="stylesheet" />
    <link href="//fonts.googleapis.com/css?family=Exo:400,600" rel="stylesheet" />
    <link href="//raw.githubusercontent.com/hico-horiuchi/emojiner/master/data/favicon.ico" rel="shortcut icon" />
    <style type="text/css"><!--
      body, h1, h2, h3, h4, text {
        font-family: 'Exo', sans-serif;
        font-weight: 400;
      }
      .bold {
        font-weight: 600;
      }
      .main {
        text-align: center;
        margin: 50px 0;
      }
      .btn {
        text-transform: none;
      }
      span.emoji:not(:empty) {
        text-indent: 100%;
        color: transparent;
        text-shadow: none;
      }
      span.emoji {
        display: inline-block;
        width: 2em;
        height: 2em;
        line-height: 2em;
        text-align: left;
        background-size: contain;
        background-repeat: no-repeat;
        background-position: 50% 50%;
      }
      td {
        padding: 4px !important;
      }
      td:first-child {
        text-align: right;
      }
      td:last-child {
        text-align: left;
        padding-top: 0.6em !important;
      }
      a.black {
        color: #333333;
      }
      a.black:hover {
        color: #999999;
        text-decoration: none;
      }
      .m-r-05 {
        margin-right: .5rem !important;
      }
      @media screen and (max-width: 970px) {
        .main { margin: 15px 0; }
      }
    --></style>
  </head>
  <body>
    <div class="container">
      <div class="row">
        <div class="col-md-4"></div>
        <div class="col-md-4 main">
          <div class="well">
            <h1 class="bold">Changelog</h1>
            <p>New custom emoji added today.</p>
            <table class="table">
              <tbody>
                #{list.join('')}
              </tbody>
            </table>
            <p><a class="btn btn-default btn-lg" href="https://slack.com/customize/emoji"><i class="fa fa-lg fa-slack m-r-05"></i>Add Custom Emoji</a></p>
            <p><i class="fa fa-copyright m-r-05"></i><a class="black" href="http://hico-horiuchi.github.io/" target="_blank">Akihiko Horiuchi</a></p>
          </div>
        </div>
        <div class="col-md-4"></div>
      </div>
    </div>
  </body>
</html>
    """

  getEmojiList = (args) ->
    args = args ? []
    robot.adapter.client.web.emoji.list (err, info) ->
      if err?
        return args.call.send(err)
      unless info.ok
        return args.call.send(info.error)
      args.list = []
      args.url = {}
      for name, url of info.emoji
        if url.match(/^alias:/)
          continue
        args.list.push(name)
        args.url[name] = url
      if args.callbacks? and args.callbacks.length > 0
        args.callbacks.shift()(args)

  getChangelog = (args) ->
    args = args ? []
    previous = robot.brain.get(KEY) ? []
    diff = _.difference(args.list, previous)
    diff = diff.map (name) ->
      "<tr><td><span class=\"emoji m-r-05\" style=\"background-image: url(#{args.url[name]})\" title=\"#{name}\">:#{name}:</span></td><td>#{name}</td></tr>"
    args.call.end(changelogPage(diff))
    if args.callbacks? and args.callbacks.length > 0
      args.callbacks.shift()(args)

  robot.router.get '/changelog', (req, call) ->
    args =
      call: call
      callbacks: [getChangelog]
    getEmojiList(args)
