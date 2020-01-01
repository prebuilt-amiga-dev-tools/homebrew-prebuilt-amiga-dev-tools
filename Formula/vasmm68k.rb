class Vasmm68k < Formula
  desc "Cross-assembler for 680x0 processors / Amiga OS"
  homepage "http://sun.hasenbraten.de/vasm"
  url "http://server.owl.de/~frank/tags/vasm1_8e.tar.gz"
  version "1.8e"
  sha256 "5f1ebb8b81d2d9664e5c2646f1abbc5fb795642ed117f55e84a66590a62760ff"
  version_scheme 1

  def install
    # ENV.deparallelize
    system "(make CPU=m68k SYNTAX=mot && chmod ugo+rx vasmm68k_mot)"
    system "(make CPU=m68k SYNTAX=std && chmod ugo+rx vasmm68k_std)"
    bin.install "vasmm68k_mot"
    bin.install "vasmm68k_std"
  end

  test do
    require "digest/md5"

    # Verify that vasmm68k_mot can assemble a given file and that the resulting object file has the right content

    (testpath/"test_mot.s").write <<~EOS
      	section	code,code

      main:
      	moveq	#0,d0
      	rts

      	section	data,data

      	dc.l	main
    EOS

    assert_match version.to_s, shell_output(["#{bin}/vasmm68k_mot", "-Fhunk", "-o", testpath/"test_mot.o", testpath/"test_mot.s"].join(" "))
    assert_match "46f347f0e0632a53e61130eb7f34f87fc17ffcaf", Digest::SHA1.hexdigest(File.read(testpath/"test_mot.o"))

    # Verify that vasmm68k_std can assemble a given file and that the resulting object file has the right content

    (testpath/"test_std.s").write <<~EOS
      	.section	code

      main:
      	moveq	#0,d0
      	rts

      	.section	data

      	.long	main
    EOS

    assert_match version.to_s, shell_output(["#{bin}/vasmm68k_std", "-Fhunk", "-o", testpath/"test_std.o", testpath/"test_std.s"].join(" "))
    assert_match "e06a1c7ade3326f33d1f65b0ebfc57cf27b70e1d", Digest::SHA1.hexdigest(File.read(testpath/"test_std.o"))
  end
end
