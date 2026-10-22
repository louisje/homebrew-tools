class TunnelClient < Formula
  desc "Fork build of Secure MCP Tunnel client"
  homepage "https://github.com/louisje/tunnel-client"
  version "0.0.17.1"
  license "Apache-2.0"

  on_macos do
    on_intel do
      url "https://github.com/louisje/tunnel-client/releases/download/fork-v0.0.17.1/tunnel-client-darwin-amd64.zip"
      sha256 "a4c7c917d1b611756d1ea762c45d226ea3a0f1c973041741460506cf76ad22d5"
    end
  end

  def install
    bin.install "tunnel-client"
  end

  test do
    assert_match "tunnel-client", shell_output("#{bin}/tunnel-client --help")
  end
end
