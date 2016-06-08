# Emojiner

![icon.png](https://raw.githubusercontent.com/hico-horiuchi/emojiner/master/data/icon.png)

## Install

Herokuでの簡単な導入説明。

    $ heroku create --stack cedar emojiner
    $ heroku config:set HUBOT_PING_PATH="/ping"
    $ heroku config:set HUBOT_CHANGELOG_ROOM="general"
    $ heroku config:set HUBOT_SLACK_EXIT_ON_DISCONNECT="true"
    $ heroku config:set HUBOT_SLACK_TOKEN=""
    $ heroku config:set REDIS_URL="redis://localhost:6379"
    $ heroku config:set TZ=Asia/Tokyo
    $ git push heroku master

## Commands

<table>
  <tbody>
    <tr>
      <td rowspan="2"><tt>help.coffee</tt></td>
      <td><tt>help</tt></td>
      <td>コマンドの一覧を表示</td>
    </tr>
    <tr>
      <td><tt>help &lt;command&gt;</tt></td>
      <td>コマンドの検索結果を表示</td>
    </tr>
  </tbody>
</table>

## URLs

<table>
  <tbody>
    <tr>
      <td><tt>changelog_web.coffee</tt></td>
      <td><tt>GET /changelog</tt></td>
      <td>今日追加された絵文字のリストを表示</td>
    </tr>
    <tr>
      <td><tt>httpd.coffee</tt></td>
      <td><tt>GET /info</tt></td>
      <td>Emojinerの紹介ページを表示</td>
    </tr>
  </tbody>
</table>

## Cron

<table>
  <tbody>
    <tr>
      <td><tt>changelog_cron.coffee</tt></td>
      <td>毎日0時に絵文字のリストを取得して保存(上書き)</td>
    </tr>
  </tbody>
</table>

## SpecialThanks

  - アイコンは「[In Spirited We Love Icon Se by Raindropmemory](http://raindropmemory.deviantart.com/art/In-Spirited-We-Love-Icon-Set-Repost-304014435)」を使っています。
