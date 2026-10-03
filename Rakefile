require 'rake/testtask'
require 'html-proofer'

Rake::TestTask.new(:test) do |task|
  task.libs << 'test'
  task.pattern = 'test/**/*_test.rb'
end

desc 'Lint Ruby, maintained Markdown, and SCSS'
task :lint do
  sh 'bundle exec rubocop --no-server --cache false'
  sh 'npm run lint'
end

desc 'Build the site with strict front matter validation'
task :build do
  sh 'bundle exec jekyll build --strict_front_matter'
end

desc 'Check generated internal links and assets without network access'
task :verify => :build do
  HTMLProofer.check_directory('_site', {
    disable_external: true,
    check_external_hash: false,
    ignore_missing_alt: true,
    enforce_https: false,
    # Existing Windows-style PDF paths are fixed in the following PR.
    ignore_urls: [
      '/otherFiles\\projects\\ibvswscribbler\\ibvs-report.pdf',
      '\\otherFiles\\projects\\soundReactiveGuitar\\electronics layout Rev 1.2.pdf',
      '//embedr.flickr.com/assets/client-code.js'
    ]
  }).run
end

desc 'Run the same validation locally and in CI'
task :check => [:lint, :test, :verify]
task :default => :check
