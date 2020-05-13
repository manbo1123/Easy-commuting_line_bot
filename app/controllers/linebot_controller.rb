class LinebotController < ApplicationController
  protect_from_forgery except: :sort

  def callback
    body = request.body.read
    events = client.parse_events_from(body)

    events.each { |event|
      require "date"
      require 'nokogiri'
      require 'open-uri'

      now = DateTime.now
      nowTime = now.strftime("%H:%M")

      if event.message["text"].include?("1")
      nextBus = BusTimetableKaiseiSt.all
      nextBusKaisei = []
      nextBus.each do |nextBus|
        time = nextBus.time.strftime("%H:%M")
        if time >= nowTime
          nextBusKaisei << time
        end
      end
      response = "開成発🚌"+nextBusKaisei[0]+"\n      Next "+nextBusKaisei[1]+"\n              "+nextBusKaisei[2]+"\n\n\n↓↓番号を選択↓↓\n1. 開成駅→会社(シャトルバス)🚌\n2. 会社→開成駅(シャトルバス)🚌\n3. 電車の運行状況🚃\n4. 会社周辺の天気🌦\n5. 東京の天気🌦\n\n※半角数字でお願いします。"
    
      elsif event.message["text"].include?("2")
        nextBus = BusTimetableTakematsu.all
      nextBusTakematsu = []
      nextBus.each do |nextBus|
        time = nextBus.time.strftime("%H:%M")
        if time >= nowTime
          nextBusTakematsu << time
        end
      end
      response = "会社発🚌"+nextBusTakematsu[0]+"\n      Next "+nextBusTakematsu[1]+"\n              "+nextBusTakematsu[2]+"\n\n\n↓↓番号を選択↓↓\n1. 開成駅→会社(シャトルバス)🚌\n2. 会社→開成駅(シャトルバス)🚌\n3. 電車の運行状況🚃\n4. 会社周辺の天気🌦\n5. 東京の天気🌦\n\n※半角数字でお願いします。"
    
    #電車の運行状況をスクレイピングで取得
      elsif event.message["text"].include?("3")
        urlOdakyu = 'https://www.odakyu.jp/cgi-bin/user/emg/emergency_bbs.pl'
        charset = nil
        htmlOdakyu = open(urlOdakyu) do |f|
          charset = f.charset
          f.read
        end

        docOdakyu = Nokogiri::HTML.parse(htmlOdakyu, nil, charset)
        docOdakyu.xpath('//div[@id="pagettl"]').each do |node|
          response = node.css('p').inner_text+"\n\n\n↓↓番号を選択↓↓\n1. 開成駅→会社(シャトルバス)🚌\n2. 会社→開成駅(シャトルバス)🚌\n3. 電車の運行状況🚃\n4. 会社周辺の天気🌦\n5. 東京の天気🌦\n\n※半角数字でお願いします。"
        end

      elsif event.message["text"].include?("4")
        urlWeatherKausei = 'https://tenki.jp/forecast/3/17/4620/14217/'
        charset = nil
        htmlWeatherKausei = open(urlWeatherKausei) do |f|
          charset = f.charset
          f.read
        end

        docWeatherKausei = Nokogiri::HTML.parse(htmlWeatherKausei, nil, charset)
        docWeatherKausei.xpath('//section[@class="today-weather"]').each do |node|
          response = "今日の開成の天気：" + node.css('p').inner_text+"\n\n\n↓↓番号を選択↓↓\n1. 開成駅→会社(シャトルバス)🚌\n2. 会社→開成駅(シャトルバス)🚌\n3. 電車の運行状況🚃\n4. 会社周辺の天気🌦\n5. 東京の天気🌦\n\n※半角数字でお願いします。"
        end

       elsif  event.message["text"].include?("5")
        urlWeatherMinatoku = 'https://tenki.jp/forecast/3/16/4410/13103/'
        charset = nil
        htmlWeatherMinatoku = open(urlWeatherMinatoku) do |f|
          charset = f.charset
          f.read
        end

        docWeatherMinatoku = Nokogiri::HTML.parse(htmlWeatherMinatoku, nil, charset)
        docWeatherMinatoku.xpath('//section[@class="today-weather"]').each do |node|
          response = "今日の東京の天気：" + node.css('p').inner_text+"\n\n\n↓↓番号を選択↓↓\n1. 開成駅→会社(シャトルバス)🚌\n2. 会社→開成駅(シャトルバス)🚌\n3. 電車の運行状況🚃\n4. 会社周辺の天気🌦\n5. 東京の天気🌦\n\n※半角数字でお願いします。"
        end

      else
        response = " ↓↓番号を選択↓↓\n1. 開成駅→会社(シャトルバス)🚌\n2. 会社→開成駅(シャトルバス)🚌\n3. 電車の運行状況🚃\n4. 会社周辺の天気🌦\n5. 東京の天気🌦\n\n※半角数字でお願いします。"
      end

      case event
      when Line::Bot::Event::Message
        case event.type
        when Line::Bot::Event::MessageType::Text
          message = {
            type: 'text',
            text: response
          }
          client.reply_message(event['replyToken'], message)
        when Line::Bot::Event::MessageType::Image, Line::Bot::Event::MessageType::Video
          response = client.get_message_content(event.message['id'])
          tf = Tempfile.open("content")
          tf.write(response.body)
        end
      end
    }
    "OK"
  end
end
