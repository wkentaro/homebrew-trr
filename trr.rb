class Trr < Formula
  desc "Typing software on Emacs"
  homepage "https://code.google.com/p/trr22/"
  url "https://trr22.googlecode.com/files/trr22_0.99-5.tar.gz"
  version "22.0.99.5"
  sha256 "6bac2f947839cebde626cdaab0c0879de8f6f6e40bfd7a14ccdfe1a035a3bcc6"

  depends_on "apel"
  depends_on "nkf" => :build

  def install
    # The file "CONTENTS" is firstly encoded to EUC-JP.
    # This encodes it to UTF-8 to avoid garbled characters.
    system "nkf", "-w", "--overwrite", "#{buildpath}/CONTENTS"

    # translate Japanese to English
    inreplace "#{buildpath}/CONTENTS", "ふつう".force_encoding("ASCII-8BIT"), "Normal"
    inreplace "#{buildpath}/CONTENTS", "やや難".force_encoding("ASCII-8BIT"), "Hard"
    inreplace "#{buildpath}/CONTENTS", "やや何".force_encoding("ASCII-8BIT"), "Hard"
    inreplace "#{buildpath}/CONTENTS", "推奨".force_encoding("ASCII-8BIT"), "Recommend"
    inreplace "#{buildpath}/CONTENTS", "安定してる".force_encoding("ASCII-8BIT"), "Stable"
    inreplace "#{buildpath}/CONTENTS", "見出しが多い".force_encoding("ASCII-8BIT"), "Lots_of_headers"
    inreplace "#{buildpath}/CONTENTS", "日本国憲法".force_encoding("ASCII-8BIT"), "Japan_Constitution"
    inreplace "#{buildpath}/CONTENTS", "合衆国憲法".force_encoding("ASCII-8BIT"), "USA_Constitution"
    inreplace "#{buildpath}/CONTENTS", "C言語".force_encoding("ASCII-8BIT"), "C_programs"
    inreplace "#{buildpath}/CONTENTS", "括弧が多い".force_encoding("ASCII-8BIT"), "Lots_of_parentheses"
    inreplace "#{buildpath}/CONTENTS", "Java言語".force_encoding("ASCII-8BIT"), "Java_programs"
    inreplace "#{buildpath}/CONTENTS", "いくつかの記号".force_encoding("ASCII-8BIT"), "Some_symbols"
    inreplace "#{buildpath}/CONTENTS", "Python言語".force_encoding("ASCII-8BIT"), "Python_programs"
    # wrong text filename
    inreplace "#{buildpath}/CONTENTS", "EmacsLisp", "Elisp_programs"

    system "make", "clean"
    cp Dir["#{Formula["apel"].share}/emacs/site-lisp/*.elc"], buildpath

    # texts for playing trr
    texts = "The_Constitution_Of_JAPAN Constitution_of_the_USA Iccad_90 C_programs Elisp_programs Java_programs Ocaml_programs Python_programs"

    inreplace "#{buildpath}/Makefile", "japanese = t", "japanese = nil"
    system "make", "all", "LISPDIR=#{share}/emacs/site-lisp",
                          "TRRDIR=#{prefix}",
                          "INFODIR=#{info}",
                          "BINDIR=#{bin}",
                          "TEXTS=#{texts}"
    system "make", "install", "LISPDIR=#{share}/emacs/site-lisp",
                              "TRRDIR=#{prefix}",
                              "INFODIR=#{info}",
                              "BINDIR=#{bin}",
                              "TEXTS=#{texts}"

    cp Dir["record/*"], "#{prefix}/record/"
  end

  def caveats; <<-EOF.undent
    Please add below lines to your emacs configuration file. (ex. ~/emacs.d/init.el)
    (add-to-list 'load-path "#{Formula["apel"].share}/emacs/site-lisp")
    (add-to-list 'load-path "#{share}/emacs/site-lisp")
    (autoload 'trr "#{share}/emacs/site-lisp/trr" nil t)
    EOF
  end

  test do
    program = testpath/"test-trr.el"
    program.write <<-EOS.undent
      (add-to-list 'load-path "#{Formula["apel"].share}/emacs/site-lisp")
      (add-to-list 'load-path "#{share}/emacs/site-lisp")
      (require 'trr)
      (print (TRR:trainer-menu-buffer))
    EOS

    assert_equal "\"Type & Menu\"", shell_output("emacs -batch -l #{program}").strip
  end
end

