module Yaassql
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

    def body(query)
      query.split("\n").map(&:strip).reject do |line|
        line.start_with?('--')
      end.join('\n')
    end

    def arguments(body)
      body.scan(/:(\w+);?/).flatten.map(&:to_sym)
    end

    def query_components(query)
      name = name(query)
      body = body(query)
      arguments = arguments(body)
      {name: name, body: body, arguments: arguments}
    end
  end
end
