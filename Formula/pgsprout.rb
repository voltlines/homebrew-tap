class Pgsprout < Formula
  desc "Masked golden copies of Postgres, sprouted into local branches in seconds"
  homepage "https://github.com/voltlines/voltlines-pgsprout"
  url "https://github.com/voltlines/voltlines-pgsprout/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "9dbdbd7609a82e918296d58fe95d3b54570499d368138382085feb2a1df22028"
  license "MIT"

  depends_on "greenmask"
  depends_on "libpq"
  depends_on "python@3.13"

  def install
    libexec.install "pgsprout.py"
    # libpq is keg-only; append it so a user's own psql/pg_dump (e.g. Postgres.app) still wins
    (bin/"pgsprout").write <<~SH
      #!/bin/bash
      export PATH="$PATH:#{formula_opt_bin("libpq")}"
      exec "#{formula_opt_bin("python@3.13")}/python3.13" "#{libexec}/pgsprout.py" "$@"
    SH
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pgsprout --version")
    system bin/"pgsprout", "init"
    assert_path_exists testpath/"pgsprout.toml"
  end
end
