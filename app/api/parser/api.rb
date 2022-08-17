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
            PostParser.new.post_list(params)
          end
        end
      end
    end

    resource :posts do
      desc 'get '
      params do
        optional :rank, type: Integer, values: 0..19, default: 0
        optional :type, type: String
        optional :query, type: String
        optional :page, type: Integer
        requires :board, type: String
        optional :random, type: Boolean
      end
      route_param :rank do
        resource :media do
          get do
            params[:rank] = rand(0..19) if params[:random] == true
            PostParser.new.media(params)
          end
        end
      end
    end
  end
end
