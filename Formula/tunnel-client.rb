class TunnelClient < Formula
  desc "Fork build of Secure MCP Tunnel client"
  homepage "https://github.com/louisje/tunnel-client"
  version "0.0.17"
  revision 2
  license "Apache-2.0"

  on_macos do
    on_intel do
      url "https://github.com/louisje/tunnel-client/releases/download/v0.0.17/tunnel-client-darwin-amd64.zip"
      sha256 "46d9cb45674b871bc751dc735de677e5fe18154f91831c9a1bf26807ab3e3a5f"
    end
  end

  def install
    bin.install "tunnel-client"
  end

  test do
    assert_match "tunnel-client", shell_output("#{bin}/tunnel-client --help")
  end
end
