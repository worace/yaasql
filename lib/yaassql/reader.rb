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

  class Reader
    HEADER_PATTERN = /^-- name: (.*)\n/
    def name(query)
      match = query.match(HEADER_PATTERN)
      if match
        match[1].to_sym
      else
        raise ArgumentError.new("Must provide a header comment with query name")
      end
    end

    def raw_body(query)
      query.split("\n").map(&:strip).reject do |line|
        line.start_with?('--')
      end.join('\n')
    end

    def with_sql_args(body, arguments)
      arguments.each.with_index.reduce(body) do |body, (arg, index)|
        body.gsub(":#{arg}", "$#{index+1}")
      end
    end

    def arguments(body)
      body.scan(/:(\w+);?/).flatten.map(&:to_sym)
    end

    def components(query)
      name = name(query)
      body = raw_body(query)
      arguments = arguments(body)
      {name: name, body: with_sql_args(body, arguments), arguments: arguments}
    end
  end
end
