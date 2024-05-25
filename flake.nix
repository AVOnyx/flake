{
  description = "AVOnyx's system flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.3.0";
      # Optional but recommended to limit the size of your system closure.
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, lanzaboote }: {
    nixosConfigurations.complex = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [ 
        lanzaboote.nixosModules.lanzaboote
        ./configuration.nix
      ];
    };
  };
}
