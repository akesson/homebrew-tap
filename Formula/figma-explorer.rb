class FigmaExplorer < Formula
  desc "High-level CLI on top of the Figma REST API: name-based navigation, asset extraction, design tokens, and bundled context export."
  homepage "https://github.com/akesson/figma-explorer"
  version "0.2.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/akesson/figma-explorer/releases/download/v0.2.0/figma-explorer-aarch64-apple-darwin.tar.xz"
    sha256 "3cbaff3a738d985c58ee0a1712fcf2900ac79fadeab12e776ee644defc38698e"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/akesson/figma-explorer/releases/download/v0.2.0/figma-explorer-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "2347315a89087dd9640625f0c208b1db8ec618829becb134aea7909b482342c8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/akesson/figma-explorer/releases/download/v0.2.0/figma-explorer-x86_64-unknown-linux-musl.tar.xz"
      sha256 "36402e00442d407338d42b24e536fc3f7594a740f8d0a0b016bbd4f35eb3df25"
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
    bin.install "figma-explorer" if OS.mac? && Hardware::CPU.arm?
    bin.install "figma-explorer" if OS.linux? && Hardware::CPU.arm?
    bin.install "figma-explorer" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
