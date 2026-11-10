class SniperSeo < Formula
  desc "Zero-hallucination SEO, GEO, and AEO verification engine"
  homepage "https://github.com/grvmon/sniper-seo-geo-aeo"
  url "https://github.com/grvmon/sniper-seo-geo-aeo/archive/refs/tags/v1.4.0.tar.gz"
  license "MIT"

  depends_on "curl"
  depends_on "python@3"

  def install
    bin.install "scripts/verify-page.sh" => "sniper-seo"
    prefix.install "SKILL.md", "README.md", "TUTORIAL.md"
    pkgshare.install Dir["references/*"]
  end

  test do
    output = shell_output("#{bin}/sniper-seo --help 2>&1", 2)
    assert_match "usage: verify-page.sh", output
  end
end
