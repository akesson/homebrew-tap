class FigmaExplorer < Formula
  desc "High-level CLI on top of the Figma REST API: name-based navigation, implementation-ready node views, comments, screenshots, and asset export."
  homepage "https://github.com/akesson/figma-explorer"
  version "0.3.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/akesson/figma-explorer/releases/download/v0.3.0/figma-explorer-aarch64-apple-darwin.tar.xz"
    sha256 "68bfae5d4344e7b8b24d9cf5e4b645f7017f2b63f9b492685b9265f8467a59e4"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/akesson/figma-explorer/releases/download/v0.3.0/figma-explorer-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "c99ebe07c89eae8cdbe966fb88b8b76a5c869ebb3af19621635a2266ed559237"
    end
    if Hardware::CPU.intel?
      url "https://github.com/akesson/figma-explorer/releases/download/v0.3.0/figma-explorer-x86_64-unknown-linux-musl.tar.xz"
      sha256 "705acb471ff1c5309d9fa4cc789bee36dec56b050c1dead9c5728dac0de85037"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
    "aarch64-unknown-linux-gnu":         {},
    "x86_64-pc-windows-gnu":             {},
    "x86_64-unknown-linux-gnu":          {},
    "x86_64-unknown-linux-musl-dynamic": {},
    "x86_64-unknown-linux-musl-static":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "figma-explorer"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "figma-explorer"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "figma-explorer"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
