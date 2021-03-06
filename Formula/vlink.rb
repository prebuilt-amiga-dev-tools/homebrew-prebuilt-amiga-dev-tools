class Vlink < Formula
  desc "Cross-linker for various OSes"
  homepage "http://sun.hasenbraten.de/vlink"
  url "http://server.owl.de/~frank/tags/vlink0_16a.tar.gz"
  version "0.16a"
  sha256 "5ffeb9f544628d69257185771199530f31800a6949b4cc52d5da2ded72c212bc"
  version_scheme 1

  head do
    url "http://sun.hasenbraten.de/vlink/daily/vlink.tar.gz"
  end

  def install
    # ENV.deparallelize
    system "(make && chmod ugo+rx vlink)"
    bin.install "vlink"
  end

  test do
    require "digest/md5"

    # Verify that vlink can link an object file

    (testpath/"test_amigahunk.o").write [\
      "000003e700000003746573745f6d6f74"\
      "2e730000000003e800000001636f6465"\
      "000003e90000000170004e75000003f0"\
      "000000016d61696e0000000000000000"\
      "000003f2000003e80000000164617461"\
      "000003ea0000000100000000000003ec"\
      "00000001000000000000000000000000"\
      "000003f2",
    ].pack("H*")

    (testpath/"test_amigahunk.exe.expected").write [\
      "000003f3000000000000000200000000"\
      "000000010000000100000001000003e9"\
      "0000000170004e75000003f000000001"\
      "6d61696e0000000000000000000003f2"\
      "000003ea0000000100000000000003ec"\
      "00000001000000000000000000000000"\
      "000003f2",
    ].pack("H*")

    shell_output(["#{bin}/vlink", "-bamigahunk", "-o", testpath/"test_amigahunk.exe", testpath/"test_amigahunk.o"].join(" "))
    assert_match Digest::SHA1.hexdigest(File.read(testpath/"test_amigahunk.exe.expected")), Digest::SHA1.hexdigest(File.read(testpath/"test_amigahunk.exe"))
  end
end
