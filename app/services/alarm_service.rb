require 'line/bot'

class AlarmService
  def client
    @client ||= Line::Bot::Client.new do |config|
      config.channel_secret = ENV.fetch('LINE_CHANNEL_SECRET')
      config.channel_token = ENV.fetch('LINE_CHANNEL_TOKEN')
    end
  end

  def run
    message = {
      type: 'text',
      text: "現在時間：#{Time.current} 趕快起床吧"
    }
    client.push_message(ENV.fetch('LINE_USER_ID'), message)
  end
end
