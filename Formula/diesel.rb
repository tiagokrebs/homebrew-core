class Diesel < Formula
  desc "Command-line tool for Rust ORM Diesel"
  homepage "https://diesel.rs"
  url "https://github.com/diesel-rs/diesel/archive/v1.4.6.tar.gz"
  sha256 "6fe4e49b57c33774c36d2dfd18d60bdbde98a4d1cfd7c31904c16f5756f56f27"
  license "Apache-2.0"
  head "https://github.com/diesel-rs/diesel.git"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_big_sur: "03d1a2d6775baf9516d0ea0846893345411b4a78bc8482be1210bae928ac6fbd"
    sha256 cellar: :any, big_sur:       "82f26a0de3595ad68a20edf5ddc56328b38306d245e1dc750915ff9a6df92f01"
    sha256 cellar: :any, catalina:      "a63b7299a7b32a4c6f581ce4aac9b264bb4b1fbd555268126f2db791606846f2"
    sha256 cellar: :any, mojave:        "ecff18f1ca293e846f0a1742311c89a146315a051531a3fff6ff27ddb14f9e95"
    sha256 cellar: :any, high_sierra:   "f63d5ac49ce152f424ce1d0072177857a0c9724156bdb5faad34f74af58e24e6"
  end

  depends_on "rust" => [:build, :test]
  depends_on "libpq"
  depends_on "mysql-client"

  uses_from_macos "sqlite"

  def install
    # Fix compile on newer Rust.
    # Remove with 1.5.x.
    ENV["RUSTFLAGS"] = "--cap-lints allow"

    cd "diesel_cli" do
      system "cargo", "install", *std_cargo_args
    end

    system "#{bin}/diesel completions bash > diesel.bash"
    system "#{bin}/diesel completions zsh > _diesel"
    system "#{bin}/diesel completions fish > diesel.fish"

    bash_completion.install "diesel.bash"
    zsh_completion.install "_diesel"
    fish_completion.install "diesel.fish"
  end

  test do
    ENV["DATABASE_URL"] = "db.sqlite"
    system "cargo", "init"
    system bin/"diesel", "setup"
    assert_predicate testpath/"db.sqlite", :exist?, "SQLite database should be created"
  end
end
