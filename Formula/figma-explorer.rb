class FigmaExplorer < Formula
  desc "High-level CLI on top of the Figma REST API: name-based navigation, asset extraction, design tokens, and bundled context export."
  homepage "https://github.com/akesson/figma-explorer"
  version "0.2.2"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/akesson/figma-explorer/releases/download/v0.2.2/figma-explorer-aarch64-apple-darwin.tar.xz"
    sha256 "b9143b39f0833105b00eabb05838057ac772e5e7ca52b227430e791f6d4db4c9"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/akesson/figma-explorer/releases/download/v0.2.2/figma-explorer-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "182468825bdfae9673488eac9826499ae10724b4c707c4544f7c4c4134495595"
    end
    if Hardware::CPU.intel?
      url "https://github.com/akesson/figma-explorer/releases/download/v0.2.2/figma-explorer-x86_64-unknown-linux-musl.tar.xz"
      sha256 "8ac486ffe165f1da387d7a081f44d753ac984ac319a9aed69bf5f44b2b7608e9"
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
