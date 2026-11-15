class TunnelClient < Formula
  desc "Fork build of Secure MCP Tunnel client"
  homepage "https://github.com/louisje/tunnel-client"
  version "0.0.21"
  license "Apache-2.0"

  on_macos do
    on_intel do
      url "https://github.com/louisje/tunnel-client/releases/download/v0.0.21/tunnel-client-darwin-amd64.zip"
      sha256 "19eaaa8f615530afd29e4fdb8d4237bd9a36d03d1145787cefdbec59a157b5cb"
    end
  end

  def install
    bin.install "tunnel-client"
  end

  test do
    assert_match "tunnel-client", shell_output("#{bin}/tunnel-client --help")
  end
end
