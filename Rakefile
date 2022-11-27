

task default: %w[build]

desc "Bundle install dependencies"
task :bundle do
  sh "bundle install"
end

desc "Build the coinalyze.gem file"
task :build do
  sh "gem build coinalyze.gemspec"
end

desc "install coinalyze-x.x.x.gem"
task install: %w[build] do
  sh "gem install $(ls coinalyze-*.gem)"
end
