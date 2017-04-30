require "./lib/yaassql/reader"

module Yaassql
  module DB
    def define_queries(file_path, db_conn)
      queries = Reader.new.from_file(file_path)
      queries.each do |q|
        define_method(q.name) do |arguments|
          q.execute(arguments, db_conn)
        end
      end
    end
  end
end
