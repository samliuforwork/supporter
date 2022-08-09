require 'nokogiri'
require 'open-uri'
require 'uri'
require 'net/http'

class PostParser
  attr_accessor :board

  def initialize(board)
    @board = board.downcase
  end

  def search(type:, query:, page: 1)
    url = "#{ParseHost.ptt}/#{board}/search?page=#{page}&q=#{type}%3A#{query}"
    doc = Nokogiri::HTML(URI.parse(url).open)
    last_page_value = doc.search('.btn-group-paging a').select { |node| node.children.text == '最舊' }[0].values[1][/\d+/].to_i
    url = "#{ParseHost.ptt}/#{board}/search?page=#{rand(last_page_value)}&q=#{type}%3A#{query}"
    doc = Nokogiri::HTML(URI.parse(url).open)
    post_urls = doc.search('div .title a').map { |url_path| ParseHost.ptt.delete_suffix('/bbs') + url_path.values[0] }

    url = URI(post_urls.sample)
    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true
    request = Net::HTTP::Get.new(url)
    response = https.request(request)
    response.body
  end
end
