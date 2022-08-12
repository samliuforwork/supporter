require "uri"
require "net/http"
require 'byebug'

# url = URI("https://www.ptt.cc/bbs/marvel/index.html")
# https = Net::HTTP.new(url.host, url.port)
# https.use_ssl = true
# request = Net::HTTP::Get.new(url)
# response = https.request(request)

# puts response.read_body

require 'nokogiri'
require 'open-uri'

# Fetch and parse HTML document
# doc = Nokogiri::HTML(URI.parse("#{ParseHost[:ptt]}/marvel/index.html").open)
doc = Nokogiri::HTML(URI.parse('https://www.ptt.cc/bbs/marvel/index.html').open)

previous_page_index = doc.search('.btn-group-paging a').map { |node| node.values[1]&.delete('^0-9') }.compact.max

# doc.search('div .title').each_with_index |post, index|
#   title = post.text
#   author
# end
# doc.search('div .title a').map(&:text)
# doc.search('div .title a').map(&:values)
# find the previous page index
# * 「author:使用者」搜尋該使用者在看板內的文章.
# * 「recommend:數字」搜尋推文數在指定數字以上(正數)或以下(負數)的文章.
# * 「thread:標題」以完整標題搜尋, 用於同主題閱讀.

# pp doc.search('div.nrec').map(&:text)
# pp doc.search('div .title').map { |post| post.text.strip }
pp doc.search('div .title a').map { |post| post.values }
