require 'nokogiri'
require 'open-uri'
require 'uri'
require 'net/http'

class PostParser
  def search(params)
    post_urls = doc_node(params).search('div .title a').map { |url_path| ParseHost.ptt.delete_suffix('/bbs') + url_path.values[0] }

    url = URI(post_urls.sample)
    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true
    request = Net::HTTP::Get.new(url)
    response = https.request(request)
    response.read_body
  end

  private

  def doc_node(params)
    url = "#{ParseHost.ptt}/#{params[:board]}/search?page=#{params[:page]}&q=#{params[:type]}%3A#{params[:query]}"
    Nokogiri::HTML(URI.parse(url).open)
  end

  # def last_page_value
  #   return @last_page_value if @last_page_value.present?

  #   url = "#{ParseHost.ptt}/#{board}/search?page=1&q=#{type}%3A#{query}"
  #   doc = Nokogiri::HTML(URI.parse(url).open)
  #   @last_page_value ||= doc.search('.btn-group-paging a').select { |node| node.children.text == '最舊' }[0].values[1][/\d+/].to_i
  # end
end
