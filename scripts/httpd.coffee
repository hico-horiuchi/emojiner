# Description:
#   簡単なビルトインHTTPデーモン
#
# URLs:
#   GET /info - Emojinerの紹介ページを表示

module.exports = (robot) ->
  INFO_PAGE =
    """
<!DOCTYPE html>
<html>
  <head>
    <title>Info | Emojiner</title>
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
            <img src="https://raw.githubusercontent.com/hico-horiuchi/emojiner/master/data/icon.png" />
            <h1 class="bold">Emojiner</h1>
            <p>I am a slack custom emoji craftsman.</p>
            <p><a class="btn btn-default btn-lg" href="https://github.com/hico-horiuchi/emojiner"><i class="fa fa-lg fa-github-alt m-r-05"></i>Show GitHub</a></p>
            <p><i class="fa fa-copyright m-r-05"></i><a class="black" href="http://hico-horiuchi.github.io/" target="_blank">Akihiko Horiuchi</a></p>
          </div>
        </div>
        <div class="col-md-4"></div>
      </div>
    </div>
  </body>
</html>
    """

  robot.router.get '/info', (req, call) ->
    call.end(INFO_PAGE)
