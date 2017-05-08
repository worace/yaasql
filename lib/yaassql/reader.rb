module Yaasql
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

    def from_file(path)
      query_strings = File.read(path).split("\n\n")
      query_strings.map { |q| Query.new(components(q)) }
    end
  end
end
