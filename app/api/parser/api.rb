module Parser
  class API < Grape::API
    version 'v1', using: :header, vendor: 'parser'
    format :json
    prefix :api

    resource :ptt do
      desc 'get random post from ptt'
      params do
        optional :board, type: String
        optional :page, type: Integer
        optional :type, type: String
        optional :query, type: Integer
      end
      get do
        PostParser.new.search(params)
      end
    end
  end
end
