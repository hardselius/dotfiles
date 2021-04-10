{ ... }: {
  programs.git = {
    userName = "Martin Hardselius";
    userEmail = "martin@hardselius.dev";
    signing = {
      key = "martin@hardselius.dev";
      signByDefault = true;
    };
    extraConfig = {
      github.user = "hardselius";
    };
  };
}
