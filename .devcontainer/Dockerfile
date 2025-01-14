FROM ocaml/opam:ubuntu-22.04-ocaml-5.2

RUN sudo apt update && sudo apt install gh

RUN opam install -y dune ocaml-lsp-server ocamlformat utop menhir ppx_jane
