require "bundler/gem_tasks"
require "rake/testtask"

TEST_DB = 'yaasql_test'

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList['test/**/*_test.rb']
end

desc "Setup the test DB"
task :setup do
  `dropdb --if-exists #{TEST_DB}`
  `createdb #{TEST_DB}`
  `psql -d #{TEST_DB} -f ./test/schema.sql`
end

task :default => :test
