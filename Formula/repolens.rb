class Repolens < Formula
  desc "Evidence-backed interactive diagrams for understanding code repositories"
  homepage "https://github.com/lijianrun/repolens"
  # Private source: installing needs read access to lijianrun/repolens over SSH (git@github.com).
  url "git@github.com:lijianrun/repolens.git", using: :git, tag: "v0.3.0", revision: "35f25bd3c87277503f5d3568d1aa2603b1c05c9a"
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
    # The installer reads git metadata of its own checkout; a keg is not one.
    inreplace libexec/"scripts/install-skill.sh" do |s|
      s.gsub!(/^REV=.*$/, "REV=\"v#{version} (homebrew)\"")
      s.gsub!(/^DIRTY=.*$/, "DIRTY=0")
    end
    (bin/"repolens-install-skill").write_env_script libexec/"scripts/install-skill.sh",
      PATH: "#{formula_opt_bin("node")}:$PATH"
  end

  def caveats
    <<~EOS
      Install the Claude Code skill (copies files to ~/.claude/skills/repolens):
        repolens-install-skill
      Project-level instead:
        repolens-install-skill --project /path/to/project
      Then ask Claude: "用 repolens 梳理 <仓库路径>" / "use repolens to map <repo>".

      Browser checks need a local Chrome/Chromium (or set REPOLENS_CHROME).
    EOS
  end

  test do
    assert_match "repolens #{version}", shell_output("#{bin}/repolens help")
    system bin/"repolens", "selftest"
  end
end
