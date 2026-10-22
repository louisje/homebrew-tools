class TunnelClient < Formula
  desc "Fork build of Secure MCP Tunnel client"
  homepage "https://github.com/louisje/tunnel-client"
  version "0.0.17"
  revision 1
  license "Apache-2.0"

  on_macos do
    on_intel do
      url "https://github.com/louisje/tunnel-client/releases/download/v0.0.17/tunnel-client-darwin-amd64.zip"
      sha256 "24c9f04bd6f6e3359a9bbfa832ad288d7597186212aab976be3031463860025b"
    end
  end

  def install
    bin.install "tunnel-client"
  end

  test do
    assert_match "tunnel-client", shell_output("#{bin}/tunnel-client --help")
  end
end
