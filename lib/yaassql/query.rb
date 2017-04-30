require "./lib/yaassql/reader"

module Yaassql
  class Query
    attr_reader :name, :body, :arguments

    def self.from_string(query)
      new(Reader.new.components(query))
    end

    def initialize(components)
      [:body, :name, :arguments].each do |param|
        raise ArgumentError.new("Query missing component #{param}") unless components[param]
      end
      @body = components[:body]
      @name = components[:name]
      @arguments = components[:arguments]
    end

    def execute(connection, args = {})
      params = self.arguments.map { |a| args.fetch(a) }
      connection.exec_params(body, params).to_a
    end
  end
end
