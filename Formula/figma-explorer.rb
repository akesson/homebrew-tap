class FigmaExplorer < Formula
  desc "High-level CLI on top of the Figma REST API: name-based navigation, implementation-ready node views, comments, screenshots, and asset export."
  homepage "https://github.com/akesson/figma-explorer"
  version "0.3.1"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/akesson/figma-explorer/releases/download/v0.3.1/figma-explorer-aarch64-apple-darwin.tar.xz"
    sha256 "d57a5edf157eaa500054d0b4adcfae150ff120d22dbebc5e5b4dc306a921c006"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/akesson/figma-explorer/releases/download/v0.3.1/figma-explorer-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "b601d4736415a3af0960e037f1bba5a7d83bf3409f6808911e30616312ed713d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/akesson/figma-explorer/releases/download/v0.3.1/figma-explorer-x86_64-unknown-linux-musl.tar.xz"
      sha256 "acaa31b5103662b74dc9b4fbf19260913041c80d6f5e8d4fb84364ff5fe8399d"
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
