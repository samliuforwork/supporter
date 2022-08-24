require 'nokogiri'
require 'open-uri'
require 'uri'
require 'net/http'

class PostParser
  PTT_COOKIE = { 'Cookie' => 'over18=1' }.freeze
  include ActionView::Helpers::SanitizeHelper

  def search(params)
    url = URI(urls(doc_node(params)).sample)
    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true
    request = Net::HTTP::Get.new(url)
    response = https.request(request)
    response.read_body
  end

  def post_list(params)
    doc_node(params).search('.r-ent').each_with_object([]) do |node, post|
      post << json(node)
    end
  end

  def media(params)
    url = post_list(params)[params[:rank]].present? ? post_list(params)[params[:rank]][:url] : post_list(params)[0][:url]

    nodes = nokogiri_open(url).search('#main-container')[0]
    images = nodes.search('img').each_with_object([]) do |node, array|
      array << node.values[0]
    end
    videos = nodes.search('iframe').each_with_object([]) do |node, array|
      break if node.blank?

      array << node.values[2].gsub('embed/', 'watch?v=').gsub('//www.', 'https://')
    end

    {
      images: images,
      videos: videos
    }
  end

  private

  def doc_node(params)
    url = "#{ParseHost.ptt}/bbs/#{params[:board]}/search?page=#{params[:page]}&q=#{params[:type]}%3A#{params[:query]}"
    nokogiri_open(url)
  end

  def nokogiri_open(url)
    Nokogiri::HTML(URI.open(url, PTT_COOKIE))
  end

  def json(node)
    url_with_host = ParseHost.ptt + node.search('.title a')[0].values[0]
    search_title_with_host = ParseHost.ptt + node.search('.dropdown .item a')[0].values[0]
    search_author_with_host = ParseHost.ptt + node.search('.dropdown .item a')[1].values[0]

    {
      date: node.search('.date').children.text,
      recommends: node.search('.nrec').children.text.to_i,
      title: node.search('.title a').children.text,
      author: node.search('.author').children.text,
      url: url_with_host,
      search_title_url: search_title_with_host,
      search_author_url: search_author_with_host
    }
  end

  def urls(node)
    node.search('div .title a').map do |url_path|
      ParseHost.ptt + url_path.values[0]
    end
  end

  # The page can be search is less than total page.
  def last_page_value(params)
    last_page_node = @last_page_value ||= doc_node(params).search('.btn-group-paging a').select do |node|
      node.children.text == I18n.t('button.last_page')
    end
    last_page_node[0].values[1][/\d+/].to_i
  end
end
