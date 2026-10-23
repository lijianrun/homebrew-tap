class Repolens < Formula
  desc "Evidence-backed interactive diagrams for understanding code repositories"
  homepage "https://github.com/lijianrun/homebrew-tap"
  # Release package built from the (private) source: minified JavaScript, the AI-agent skill and licences.
  url "https://github.com/lijianrun/homebrew-tap/releases/download/repolens-v0.5.2/repolens-0.5.2.tar.gz"
  sha256 "70b2e0fa73479551c14aaa7ec23e4c81deb4bd0bfc9e81455c6d05931a8bdd18"
  license :cannot_represent

  depends_on "node"

  def install
    libexec.install Dir["*"] - %w[LICENSE NOTICE.md README.md]
    # Homebrew keeps these metafiles at the keg root; the skill installer copies them from libexec.
    %w[LICENSE NOTICE.md README.md].each { |f| libexec.install_symlink prefix/f }
    (bin/"repolens").write <<~SH
      #!/bin/bash
      exec "#{formula_opt_bin("node")}/node" "#{libexec}/bin/repolens.mjs" "$@"
    SH
    (bin/"repolens-install-skill").write_env_script libexec/"scripts/install-skill.sh",
      PATH: "#{formula_opt_bin("node")}:$PATH"
  end

  def caveats
    <<~EOS
      Add the RepoLens skill to your AI coding tools (Claude Code, Codex, Cursor):
        repolens install
      Project-level instead:  repolens install --scope project --project /path/to/project
      Status / uninstall:     repolens install --status | repolens install --uninstall
      Then ask your AI: "use RepoLens to map the cart flow in this repository".

      Browser checks need a local Chrome/Chromium (or set REPOLENS_CHROME).
      Licensed for use only: see #{opt_prefix}/LICENSE.
    EOS
  end

  test do
    assert_match "repolens #{version}", shell_output("#{bin}/repolens help")
    system bin/"repolens", "selftest"
  end
end
