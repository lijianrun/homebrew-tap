class Repolens < Formula
  desc "Evidence-backed interactive diagrams for understanding code repositories"
  homepage "https://github.com/lijianrun/repolens"
  # Private source: installing needs read access to lijianrun/repolens over SSH (git@github.com).
  url "git@github.com:lijianrun/repolens.git", using: :git, tag: "v0.4.1", revision: "1f34c63b7d6ab7549330f42275eb5b0675c9889f"
  license "MIT"

  depends_on "node"

  def install
    libexec.install Dir["*"] - %w[LICENSE NOTICE.md README.md test]
    # Homebrew keeps these metafiles at the keg root; the skill installer copies them from libexec.
    %w[LICENSE NOTICE.md README.md].each { |f| libexec.install_symlink prefix/f }
    (bin/"repolens").write <<~SH
      #!/bin/bash
      exec "#{formula_opt_bin("node")}/node" "#{libexec}/bin/repolens.mjs" "$@"
    SH
    # Releases up to 0.3.0 shipped a bash installer that read git metadata of its own checkout (a keg is not one).
    # From 0.4.0 `repolens install` does this in Node and install-skill.sh only delegates to it.
    legacy = libexec/"scripts/install-skill.sh"
    if legacy.read.match?(/^REV=/)
      inreplace legacy do |s|
        s.gsub!(/^REV=.*$/, "REV=\"v#{version} (homebrew)\"")
        s.gsub!(/^DIRTY=.*$/, "DIRTY=0")
      end
    end
    (bin/"repolens-install-skill").write_env_script libexec/"scripts/install-skill.sh",
      PATH: "#{formula_opt_bin("node")}:$PATH"
  end

  def caveats
    <<~EOS
      Add the RepoLens skill to your AI coding tools (Claude Code, Codex, Cursor):
        repolens install
      Project-level instead:  repolens install --scope project --project /path/to/project
      Status / uninstall:     repolens install --status | repolens install --uninstall
      (repolens-install-skill still works and installs for Claude Code.)
      Then ask your AI: "use RepoLens to map the cart flow in this repository".

      Browser checks need a local Chrome/Chromium (or set REPOLENS_CHROME).
    EOS
  end

  test do
    assert_match "repolens #{version}", shell_output("#{bin}/repolens help")
    system bin/"repolens", "selftest"
  end
end
