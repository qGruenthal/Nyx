(define-module (nyx momus)
  #:use-module (guix packages)
  #:use-module (guix git-download)
  #:use-module (guix build-system gnu)
  #:use-module (guix build-system guile)
  #:use-module (guix licenses)
  #:use-module (gnu packages guile)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages autotools))

(define-public momus
  (package
   (name "momus")
   (version "0.0.1-dev")
   (source (origin
            (method git-fetch)
            (uri (git-reference
                  (url "https://github.com/qGruenthal/Momus")
                  (commit "a145925db38f77762aeb04d883f1c7c2d7f5827c")))
            (file-name (git-file-name name version))
            (sha256
             (base32
              "00cwayxfsmfwvlcbp1y4fqw5hj6kggyr13d7ixzzxfhsy3bdw2dz"))))
   (build-system gnu-build-system)
   (arguments
    `(#:phases
      (modify-phases %standard-phases
                     (add-after 'install 'wrap
                                (lambda* (#:key outputs #:allow-other-keys)
                                  (let* ((out (assoc-ref outputs "out"))
                                         (scm (string-append out "/share/guile/site/2.2"))
                                         (lib (string-append out "lib")))
                                    (wrap-program (string-append out "/bin/momus")
                                                  `("GUILE_LOAD_PATH" ":" prefix
                                                    (,scm))
                                                  `("LD_LIBRARY_PATH" suffix
                                                    (,lib)))
                                    #t))))))
   (native-inputs
    `(("pkg-config" ,pkg-config)
      ("autoconf" ,autoconf)
      ("automake" ,automake)
      ("libtool" ,libtool)))
   (inputs
    `(("guile" ,guile-2.2)))
   (synopsis "Momus, Critism Personified")
   (description
    "Momus is a testing framework for testing student code in a classroom setting.")
   (home-page "https://github.com/qGruenthal/Momus")
   (license gpl3+)))
