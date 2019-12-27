class Vasmm68k < Formula
    desc "Cross-assembler for 680x0 processors / Amiga OS"
    homepage "http://sun.hasenbraten.de/vasm"
    url "http://server.owl.de/~frank/tags/vasm1_8e.tar.gz"
    sha256 "abcd1234"
    version "1.8e"
  
    def install
      # ENV.deparallelize
      system "(make CPU=m68k SYNTAX=mot && chmod ugo+rx vasmm68k_mot)"
      system "(make CPU=m68k SYNTAX=std && chmod ugo+rx vasmm68k_std)"
      bin.install "vasmm68k_mot"
      bin.install "vasmm68k_std"
    end
  
    test do
    # Disable tests for the time being
    #    assert_match version.to_s, shell_output("#{bin}/vasmm68k_mot")
    #    assert_match version.to_s, shell_output("#{bin}/vasmm68k_std")
    end
  end
