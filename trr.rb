require "formula"

class Trr < Formula
  homepage "https://code.google.com/p/trr22/"
  url "https://trr22.googlecode.com/files/trr22_0.99-5.tar.gz"
  sha1 "17082cc5fcebb8c877e6a17f87800fecc3940f24"
  version "22.0.99.5"

  depends_on "apel"
  depends_on "nkf" => :build

  def install
    system "make", "clean"
    cp Dir["#{Formula['apel'].share}/emacs/site-lisp/*.elc"], buildpath

    # The file "CONTENTS" is firstly encoded to EUC-JP.
    # This encodes it to UTF-8 to avoid garbled characters.
    system "nkf", "-w", "--overwrite", "#{buildpath}/CONTENTS"

    # get email adder
    print "Email address?: "
    email_adder = gets.chomp

    system "make", "all", "installer=#{email_adder}",
                          "japanese=nil",
                          "LISPDIR=#{share}/emacs/site-lisp",
                          "TRRDIR=#{prefix}",
                          "INFODIR=#{info}",
                          "BINDIR=#{bin}"
    system "make", "install", "installer=#{email_adder}",
                              "japanese=nil",
                              "LISPDIR=#{share}/emacs/site-lisp",
                              "TRRDIR=#{prefix}",
                              "INFODIR=#{info}",
                              "BINDIR=#{bin}"
    cp "record/*" "#{prefix}/record/"
  end

  def caveats; <<-EOF.undent
    Please add below lines to your emacs configuration file. (ex. ~/emacs.d/init.el)

    (add-to-list 'load-path "#{Formula['apel'].share}/emacs/site-lisp")
    (add-to-list 'load-path "#{share}/emacs/site-lisp")
    (autoload 'trr "#{share}/emacs/site-lisp/trr" nil t)
    EOF
  end

  test do
    program = testpath/"test-trr.el"
    program.write <<-EOS.undent
      (add-to-list 'load-path "#{Formula['apel'].share}/emacs/site-lisp")
      (add-to-list 'load-path "#{share}/emacs/site-lisp")
      (require 'trr)
      (print (TRR:trainer-menu-buffer))
    EOS

    assert_equal "\"Type & Menu\"", shell_output("emacs -batch -l #{program}").strip
  end

end
