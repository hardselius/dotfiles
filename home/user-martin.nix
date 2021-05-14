{ ... }: 
let
  name = "Martin Hardselius";
  email = "martin@hardselius.dev";
in {
  programs = {
    git = {
      userName = "${name}";
      userEmail = "${email}";
      signing = {
        key = "${email}";
        signByDefault = true;
      };
      extraConfig = {
        github.user = "hardselius";
        url = {
          "git@github.com:" = {
            insteadOf = "https://github.com/";
          };
        };
      };
    };
  };
}
