require 'httparty'
require 'json'

class EditorsController < ApplicationController
  def new
    # 最初の表示時には何もせず、createからリダイレクトされてきたときに@resultがあれば表示される
  end

  def create
    code = params[:code]

    # Judge0 APIに送信するためのパラメータ
    payload = {
      source_code: code,
      language_id: 72, # RubyのID（Judge0の仕様による）
      stdin: "",
      base64_encoded: false
    }

    # APIにPOST送信してレスポンスを取得
    response = HTTParty.post(
      "https://ce.judge0.com/submissions?base64_encoded=false&wait=true",
      headers: {
        "Content-Type" => "application/json",
        "X-RapidAPI-Key" => ENV["RAPIDAPI_KEY"],
        "X-RapidAPI-Host" => "judge0-ce.p.rapidapi.com"
      },
      body: payload.to_json
    )

    puts "status: #{response.code}"
    puts "body: #{response.body.inspect}"
    puts "payload: #{payload.to_json}"
    puts "APIキー：#{ENV['RAPIDAPI_KEY'].present? ? '取得OK' : '取得失敗'}"

    # 出力結果をレスポンスから取り出す（stdout）
    if response.body.present?
      parsed = JSON.parse(response.body)
      @result = parsed["stdout"] || parsed["stderr"] || "出力なし"
      puts "成功"
    else
      @result = "APIからのレスポンスが空です"
      puts "失敗"
    end

    # newビューを再表示（@resultを渡す）
    render :new
  end
end
