# Emojiner

![icon.png](https://raw.githubusercontent.com/hico-horiuchi/emojiner/master/data/icon.png)

## Install

Herokuでの簡単な導入説明。

    $ heroku create --stack cedar emojiner
    $ heroku config:set HUBOT_PING_PATH="/emojiner/ping"
    $ heroku config:set HUBOT_SLACK_TOKEN=""
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
      <td><tt>httpd.coffee</tt></td>
      <td><tt>GET /emojiner/info</tt></td>
      <td>Emojinerの紹介ページを表示</td>
    </tr>
  </tbody>
</table>

## Cron

<table>
  <tbody>
  </tbody>
</table>

## SpecialThanks

  - アイコンは「[In Spirited We Love Icon Se by Raindropmemory](http://raindropmemory.deviantart.com/art/In-Spirited-We-Love-Icon-Set-Repost-304014435)」を使っています。
