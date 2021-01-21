#
# © 2019 Kirill Elagin <kirelagin@gmail.com>
#
# SPDX-License-Identifier: MIT
#

{ pkgs }:

let
  inherit (pkgs) lib;

  types = import ./types { inherit pkgs; };
  combinators = import ./combinators.nix { inherit pkgs; };

  evalZone = name: zone:
    (lib.evalModules {
      modules = [
        { options = {
            zones = lib.mkOption {
              type = lib.types.attrsOf types.zone;
              description = "DNS zones";
            };
          };
          config = {
            zones = { "${name}" = zone; };
          };
        }
      ];
    }).config.zones."${name}";

  writeZone = name: zone:
    pkgs.writeTextFile {
      name = "${name}.zone";
      text = types.zoneToString name (evalZone name zone);
    };
in

{
  inherit evalZone writeZone;

  inherit types;

  inherit combinators;
}
