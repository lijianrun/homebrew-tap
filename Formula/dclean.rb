class Dclean < Formula
  desc "Deep disk cleaner for macOS with structural build-artifact detection"
  homepage "https://github.com/lijianrun/deep-clean"
  # Private source: installing needs read access to lijianrun/deep-clean over SSH (git@github.com).
  url "git@github.com:lijianrun/deep-clean.git", using: :git, tag: "v1.0.1", revision: "16504e6fae13da22429b0f8f639b2c0d25cac530"
  license "MIT"
  head "git@github.com:lijianrun/deep-clean.git", using: :git, branch: "main"

  depends_on "rust" => :build
  depends_on :macos

  def install
    system "cargo", "install", *std_cargo_args
    # Ship the skill definition so Claude Code can install it from the keg.
    pkgshare.install "SKILL.md"
  end

  def caveats
    <<~EOS
      Install the Claude Code skill with:
        mkdir -p ~/.claude/skills/deep-clean
        cp #{opt_pkgshare}/SKILL.md ~/.claude/skills/deep-clean/

      dclean never uses sudo and defaults to a read-only scan:
        dclean doctor      # check for blocking build / fleet processes
        dclean scan        # read-only report
        dclean clean --yes # actually reclaim
    EOS
  end

  test do
    # usage() exits 2 by design
    assert_match "dclean", shell_output("#{bin}/dclean --help 2>&1", 2)
    # doctor is read-only and must work in a non-TTY shell
    assert_match "门禁结论", shell_output("#{bin}/dclean doctor")
  end
end
