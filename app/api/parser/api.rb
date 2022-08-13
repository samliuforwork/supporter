module Parser
  class API < Grape::API
    version 'v1', using: :header, vendor: 'parser'
    format :json
    prefix :api
    add_swagger_documentation

    resource :ptt do
      desc 'get random post from ptt'
      params do
        requires :board, type: String
        optional :page, type: Integer
        requires :type, type: String, values: %w[recommend author thread]
        requires :query, type: String
      end
      get do
        PostParser.new.search(params)
      end
    end

    resource :users do
      desc 'Return certain user all ptt post in given board'
      params do
        requires :board, type: String
        optional :type, type: String, default: 'author'
        requires :query, type: String
      end
      route_param :query do
        resource :posts do
          get do
            PostParser.new.posts(params)
          end
        end
      end
    end
  end
end
