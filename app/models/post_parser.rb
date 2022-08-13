require 'nokogiri'
require 'open-uri'
require 'uri'
require 'net/http'

class PostParser
  include ActionView::Helpers::SanitizeHelper

  def search(params)
    url = URI(urls(doc_node(params)).sample)
    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true
    request = Net::HTTP::Get.new(url)
    response = https.request(request)
    response.read_body
  end

  def posts(params)
    posts = []
    doc_node(params).search('.r-ent').each_with_object(posts) do |node, post|
      post << json(node)
    end
  end

  private

  def doc_node(params)
    url = "#{ParseHost.ptt}/#{params[:board]}/search?page=#{params[:page]}&q=#{params[:type]}%3A#{params[:query]}"
    Nokogiri::HTML(URI.parse(url).open)
  end

  def json(node)
    {
      date: node.search('.date').children.text,
      recommends: node.search('.nrec').children.text.to_i,
      title: node.search('.title a').children.text,
      author: node.search('.author').children.text,
      url: node.search('.title a')[0].values[0],
      search_title: node.search('.dropdown .item a')[0].values,
      search_author: node.search('.dropdown .item a')[1].values
    }
  end

  def urls(node)
    node.search('div .title a').map do |url_path|
      ParseHost.ptt.delete_suffix('/bbs') + url_path.values[0]
    end
  end

  # def last_page_value
  #   return @last_page_value if @last_page_value.present?

  #   url = "#{ParseHost.ptt}/#{board}/search?page=1&q=#{type}%3A#{query}"
  #   doc = Nokogiri::HTML(URI.parse(url).open)
  #   @last_page_value ||= doc.search('.btn-group-paging a').select { |node| node.children.text == '最舊' }[0].values[1][/\d+/].to_i
  # end
end
