# frozen_string_literal: true

task default: %w[test]

task :test do
  system('rspec')
end

task :deploy do
  sh 'git checkout main; git merge dev; git push; git checkout dev'
end

task :install do
  system('bundle install')
end
