module Yaassql
  class Reader
    def query_name(query)
      pattern = /^-- name: (.*)\n/
      match = query.match(pattern)
      if match
        match[1].to_sym
      else
        raise ArgumentError.new("Must provide a header comment with query name") unless query_name
      end
    end

    def query_components(query)
      name = query_name(query)

      body = query.sub(header, '')

      arguments = query.scan(/ :(.+)?;/).flatten.map(&:to_sym)
      {name: query_name,
       body: insert_pg_variables(body, arguments),
       arguments: arguments}
    end
  end
end
