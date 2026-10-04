# Contributor instructions

Every pull request that changes code or behavior must include pictures or a video
in its description that show the change. Add the visual evidence before opening
the PR, and keep it current when the implementation changes. Documentation-only
PRs do not need screenshots of text; explain the change and use the diff.

- For UI changes, include before-and-after screenshots of the affected area at
  the same viewport size. Expand any controls needed to make the change visible.
- Use a short video when an interaction or animation is best demonstrated in
  motion.
- For code changes without a visible UI, show relevant generated output or
  validation results.
- Capture actual builds or output, and add captions explaining what reviewers
  should look for.
- Upload visual evidence as GitHub attachments and embed it in the PR description.
  Never commit PR screenshots or videos to the repository.
- Use GitHub's browser attachment control or a current authenticated GitHub CLI:
  `gh pr create --attach` or `gh pr edit --attach`. Verify that the installed CLI
  supports the flag and that the account has write access to the repository.
  Use `--body-file` with local image references to place each attachment beside
  its caption; the CLI replaces those paths with uploaded attachment URLs.
- Keep capture files outside the repository. If attachment upload is unavailable,
  report that limitation and provide the files for attachment.
