#
# © 2019 Kirill Elagin <kirelagin@gmail.com>
#
# SPDX-License-Identifier: MIT
#

{ pkgs }:

let
  inherit (builtins) map;
  inherit (pkgs) lib;

in

rec {

#
# Simple records
#

a = address: { inherit address; };
aaaa = address: { inherit address; };
cname = cname: { inherit cname; };
ns = nsdname: { inherit nsdname; };
txt = data: { inherit data; };


#
# Modifiers
#

ttl = ttl: record: record // { inherit ttl; };


#
# Templates/shortcuts
#

delegateTo = nameservers: {
  NS = map ns nameservers;
};

letsEncrypt = email: [
  { issuerCritical = false;
    tag = "issue";
    value = "letsencrypt.org";
  }
  { issuerCritical = false;
    tag = "issuewild";
    value = ";";
  }
  { issuerCritical = false;
    tag = "iodef";
    value = "mailto:${email}";
  }
];

spf =
  let
    toSpf = rs:
      txt (lib.concatStringsSep " " (["v=spf1"] ++ rs));
  in {
    soft = rs: toSpf (rs ++ ["~all"]);
    strict = rs: toSpf (rs ++ ["-all"]);

    google = "include:_spf.google.com";
  };

}