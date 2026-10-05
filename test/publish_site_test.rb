# Exercise publication against a real local Git remote, including concurrent CV updates.
require 'minitest/autorun'
require 'fileutils'
require 'open3'
require 'tmpdir'

class PublishSiteTest < Minitest::Test
  SCRIPT = File.expand_path('../bin/publish-site', __dir__)
  CV_PATH = 'otherFiles/MichaelSobrepera.pdf'

  def setup
    @directory = Dir.mktmpdir('publish-site-test-')
    @remote = File.join(@directory, 'remote.git')
    @source = File.join(@directory, 'source')
    @artifact = File.join(@directory, 'artifact')
    FileUtils.mkdir_p([@source, @artifact])
    git('init', '--bare', '--initial-branch=master', @remote)
    git('init', '--initial-branch=master')
    configure_author(@source)
    write_file(@source, CV_PATH, "%PDF-original CV\n")
    write_file(@source, 'obsolete.html', 'old page')
    git('add', '--all')
    git('commit', '-m', 'Initial published site')
    git('remote', 'add', 'origin', @remote)
    git('push', 'origin', 'master')
    @base = git('rev-parse', 'HEAD').strip
    # Source and published branches have independent trees and histories.
    git('switch', '--orphan', 'deploy')
    write_file(@source, 'source-only.txt', 'development source')
    git('add', '--all')
    git('commit', '-m', 'Source checkout')
    @source_commit = git('rev-parse', 'HEAD').strip
    write_file(@artifact, CV_PATH, "%PDF-original CV\n")
    write_file(@artifact, 'index.html', 'validated site')
    write_file(@artifact, '.github/dependabot.yml', 'version: 2')
  end

  def teardown
    FileUtils.remove_entry(@directory) if @directory
  end

  def test_publishes_artifact_as_descendant_and_preserves_cv
    output, errors, status = publish
    assert status.success?, "#{output}\n#{errors}"
    assert_equal @base, remote_git('rev-parse', 'master^').strip
    assert_equal "Publish validated site from #{@source_commit}", remote_git('log', '-1', '--format=%s').strip
    assert_equal "validated site", remote_git('show', 'master:index.html')
    assert_equal "%PDF-original CV\n", remote_git('show', "master:#{CV_PATH}")
    assert_equal 'version: 2', remote_git('show', 'master:.github/dependabot.yml')
    assert_equal '', remote_git('show', 'master:.nojekyll')
    refute_includes remote_git('ls-tree', '-r', '--name-only', 'master').lines.map(&:strip), 'obsolete.html'
    refute_includes remote_git('ls-tree', '-r', '--name-only', 'master').lines.map(&:strip), 'source-only.txt'
    assert_equal @source_commit, git('rev-parse', 'HEAD').strip
    assert_equal 'development source', File.read(File.join(@source, 'source-only.txt'))
  end

  def test_rejects_cv_update_while_build_was_running
    writer, updated_commit = prepare_cv_update
    git('push', 'origin', 'master', in_dir: writer)

    _output, errors, status = publish
    refute status.success?
    assert_includes errors, 'master changed since validation'
    assert_remote_cv_update_preserved(updated_commit)
  end

  def test_rejects_cv_update_after_initial_guard_before_push
    writer, updated_commit = prepare_cv_update
    # Interpose a real writer push immediately before the publisher's push.
    # This reproduces the race without sleeps or replacing Git's lease behavior.
    real_git = ENV.fetch('PATH').split(File::PATH_SEPARATOR)
                  .map { |path| File.join(path, 'git') }.find { |path| File.executable?(path) }
    wrapper_dir = File.join(@directory, 'git-wrapper')
    write_file(wrapper_dir, 'git', <<~'BASH')
      #!/usr/bin/env bash
      set -euo pipefail
      if [[ "${1:-}" == push ]]; then
        "$PUBLISH_RACE_GIT" -C "$PUBLISH_RACE_WRITER" push origin master
      fi
      exec "$PUBLISH_RACE_GIT" "$@"
    BASH
    FileUtils.chmod(0o755, File.join(wrapper_dir, 'git'))
    output, errors, status = publish(
      'PATH' => "#{wrapper_dir}#{File::PATH_SEPARATOR}#{ENV.fetch('PATH')}",
      'PUBLISH_RACE_GIT' => real_git,
      'PUBLISH_RACE_WRITER' => writer
    )

    refute status.success?, output
    assert_includes errors, '(stale info)'
    assert_includes errors, 're-run all jobs'
    assert_remote_cv_update_preserved(updated_commit)
  end

  def test_rejects_artifact_with_unvalidated_cv
    write_file(@artifact, CV_PATH, "%PDF-different CV\n")

    _output, errors, status = publish
    refute status.success?
    assert_includes errors, 'artifact CV differs'
    assert_equal @base, remote_git('rev-parse', 'master').strip
    assert_equal "%PDF-original CV\n", remote_git('show', "master:#{CV_PATH}")
  end

  private

  def publish(environment = {})
    Open3.capture3(environment, SCRIPT, @artifact, @base, chdir: @source)
  end

  def git(*arguments, in_dir: @source)
    output, errors, status = Open3.capture3('git', *arguments, chdir: in_dir)
    assert status.success?, "git #{arguments.join(' ')} failed: #{output}\n#{errors}"
    output
  end

  def remote_git(*arguments)
    git('--git-dir', @remote, *arguments)
  end

  def configure_author(directory)
    git('config', 'user.name', 'Publication Test', in_dir: directory)
    git('config', 'user.email', 'test@example.invalid', in_dir: directory)
  end

  def write_file(directory, path, content)
    destination = File.join(directory, path)
    FileUtils.mkdir_p(File.dirname(destination))
    File.write(destination, content)
  end

  def prepare_cv_update
    writer = File.join(@directory, 'cv-writer')
    git('clone', @remote, writer)
    configure_author(writer)
    write_file(writer, CV_PATH, "%PDF-updated CV\n")
    git('add', CV_PATH, in_dir: writer)
    git('commit', '-m', 'Update CV independently', in_dir: writer)
    [writer, git('rev-parse', 'HEAD', in_dir: writer).strip]
  end

  def assert_remote_cv_update_preserved(commit)
    assert_equal commit, remote_git('rev-parse', 'master').strip
    assert_equal "%PDF-updated CV\n", remote_git('show', "master:#{CV_PATH}")
    refute_includes remote_git('ls-tree', '--name-only', 'master').lines.map(&:strip), 'index.html'
  end
end
