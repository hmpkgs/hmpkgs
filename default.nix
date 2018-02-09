with import <nixpkgs> {};

{
  # org-build = import ../../src/hmpkgs/org-build;
  org-build = import (fetchFromGitHub {
    owner = "hmpkgs";
    repo = "org-build";
    rev = "924d4fec985dcac8db0f3b9aba5a76ada878a7c9";
    sha256 = "043ki0wnz45952h76p20wbyj35rcv3qh5bv714ydk6djd80cp11j";
  });

  # org-export = import ../../src/hmpkgs/org-export;
  org-export = import (fetchFromGitHub {
    owner = "hmpkgs";
    repo = "org-export";
    rev = "924c8f094ca8442c82949d5a2671075f4c1aeaf5";
    sha256 = "1haxvz3qd5bfbd6c63krqvvmnjkk343rawb5v3yviyclh1w6bq60";
  });

  # hammerspoon = import ../src/hmpkgs/hammerspoon;
  hammerspoon = import (fetchFromGitHub {
    owner = "hmpkgs";
    repo = "hammerspoon";
    rev = "1be4a32d2d1bed04c565a18da345b4c45b368117";
    sha256 = "0ygf01mf0x9x8gw62w78a5r2hhjy28iy989vjicdzm4shwzl0794";
  });

  # amethyst = import ../src/hmpkgs/amethyst;
  amethyst = import (fetchFromGitHub {
    owner = "hmpkgs";
    repo = "amethyst";
    rev = "886f8e8c3d742915638191fd8516ef5df021a224";
    sha256 = "16mj7rfz3ahmm3n5gn4a9qv5sy1gpmlhiv2prk8jvvbhjbk6lmj2";
  });

  # viscosity = import ../src/hmpkgs/viscosity;
  viscosity = import (fetchFromGitHub {
    owner = "hmpkgs";
    repo = "viscosity";
    rev = "6a1a058a4b815550fb7d9085381720c4f7dde122";
    sha256 = "0rb8xia8558vbnnff6agvpkz9g27c8grv6hzmq92b403yf79cli1";
  });

}
