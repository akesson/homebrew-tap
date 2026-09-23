class FigmaExplorer < Formula
  desc "High-level CLI on top of the Figma REST API: name-based navigation, asset extraction, design tokens, and bundled context export."
  homepage "https://github.com/akesson/figma-explorer"
  version "0.2.3"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/akesson/figma-explorer/releases/download/v0.2.3/figma-explorer-aarch64-apple-darwin.tar.xz"
    sha256 "77ca007cf824cb7b0a1288bd8562c9df0195048ae4df2a9831d675c5faea5f70"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/akesson/figma-explorer/releases/download/v0.2.3/figma-explorer-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "b73883c6e24d5291322f9f2e9099ac74a266e0be8a598211da8cfc321e8fdf84"
    end
    if Hardware::CPU.intel?
      url "https://github.com/akesson/figma-explorer/releases/download/v0.2.3/figma-explorer-x86_64-unknown-linux-musl.tar.xz"
      sha256 "c29d3693fb5e32a125765849a1f872179e021f9dc9806cb39b3e115ba89db42e"
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
