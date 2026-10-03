# Local and CI tasks for linting, filter tests, and generated site validation.
# Run bin/check for the full suite or bundle exec rake <task> for an individual task.
require 'rake/testtask'
require 'open3'

Rake::TestTask.new(:test) do |task|
  task.libs << 'test'
  task.pattern = 'test/**/*_test.rb'
end

desc 'Lint SCSS, stripping Jekyll front matter while preserving line numbers'
task :lint_styles do
  ['css/main.scss', *Dir['_sass/*.scss']].each do |file|
    source = File.read(file).sub(/\A---\r?\n.*?\r?\n---\r?\n/m) do |front_matter|
      front_matter.gsub(/[^\r\n]/, '')
    end
    output, errors, status = Open3.capture3(
      'node_modules/.bin/stylelint', '--stdin', '--stdin-filename', file,
      stdin_data: source
    )
    print output
    warn errors unless errors.empty?
    raise "Stylelint failed for #{file}" unless status.success?
  end
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
  require 'html-proofer'
  HTMLProofer.check_directory('_site', {
    disable_external: true,
    check_external_hash: false,
    ignore_missing_alt: true,
    enforce_https: false,
    # The Git command's <source> placeholder is fixed in the defect-fix PR.
    ignore_files: ['_site/guides/gitGuide.html'],
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
