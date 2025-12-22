_: {
  enable = true;
  lfs.enable = true;
  userName = "Tim Kalan";
  userEmail = "timkalan99@gmail.com";
  signing.key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGc1JHW7HfZxlNrIxHEnsfy3kqG1mhMSwupx9z4zLJrn";
  signing.signByDefault = true;

  extraConfig = {
    gpg = {
      format = "ssh";
    };
  };
}
