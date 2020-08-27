require 'json'
require 'net/https'
module Language
  class << self
    def analyzeSentiment(text)
      # APIのURL作成
      api_url = "https://language.googleapis.com/v1beta1/documents:analyzeSentiment?key=#{ENV['GOOGLE_NATURAL_LANGUAGE_API_KEY']}"
      # APIリクエスト用のJSONパラメータ
      # これはget_scoreの引数で与えたtextをapiに送る用の形に整形している
      params = {
        document: {
          # typeでデータ型、contentで実際にapiに送る文章を渡している。事前にtextに実際に送る文を入れて関数呼び出してあげる。
          type: 'PLAIN_TEXT',
          content: text
        }
      }.to_json
      # Google Cloud Natural Language APIにリクエスト
      # api_urlだけだと、ただの文字列なので、https通信をするための形に整形してる。 *uri = #<URI::HTTPS https://language.googleapis.com/v1beta1/documents~>みたいな形になる
      uri = URI.parse(api_url)
      # httpsでuriの中のhostカラム(?)とportカラム(?)の値をhttpsに渡し、https通信する際の設定 *https = #<Net::HTTP language.googleapis.com:443 open=false> みたいな形になる
      https = Net::HTTP.new(uri.host, uri.port)
      https.use_ssl = true
      # requstを作成した時点でapi側にリクエストが投げられる。apiによってどういう形のデータを渡すか指定があるためそれにそった形でデータを整形してあげる。
      request = Net::HTTP::Post.new(uri.request_uri)
      # request(及びレスポンス)の形をjson形式で受け渡しをする設定
      request['Content-Type'] = 'application/json'
      # リクエストを送った結果が、responseに格納されて帰ってくる
      response = https.request(request, params)
      # p JSON.parse(response.body)
      # APIレスポンス出力
      # responseの中でも必要な情報(response.headerとかもいろいろあるけどapiのメインのレスポンスは.bodyに格納されてる)をJSON形式からRubyに変換(=parse)している
      JSON.parse(response.body)
    end

    def analyzeEntities(text)
      # APIのURL作成
      api_url = "https://language.googleapis.com/v1/documents:analyzeEntities?key=#{ENV['GOOGLE_NATURAL_LANGUAGE_API_KEY']}"
      # APIリクエスト用のJSONパラメータ
      params = {
        document: {
          type: 'PLAIN_TEXT',
          content: text
        }
      }.to_json
      uri = URI.parse(api_url)
      https = Net::HTTP.new(uri.host, uri.port)
      https.use_ssl = true
      request = Net::HTTP::Post.new(uri.request_uri)
      request['Content-Type'] = 'application/json'
      response = https.request(request, params)
      # APIレスポンス出力
      JSON.parse(response.body)
    end
  end
end
