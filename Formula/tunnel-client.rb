class TunnelClient < Formula
  desc "Fork build of Secure MCP Tunnel client"
  homepage "https://github.com/louisje/tunnel-client"
  version "0.0.18"
  license "Apache-2.0"

  on_macos do
    on_intel do
      url "https://github.com/louisje/tunnel-client/releases/download/v0.0.18/tunnel-client-darwin-amd64.zip"
      sha256 "f9d17d84b4ab0e2588b45a3442c97b4a72b01770ef7105166b7e32ee9437d7b9"
    end
  end

  def install
    bin.install "tunnel-client"
  end

  test do
    assert_match "tunnel-client", shell_output("#{bin}/tunnel-client --help")
  end
end
