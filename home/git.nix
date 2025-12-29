_: {
  enable = true;
  lfs.enable = true;
  settings = {
    user = {
      name = "Tim Kalan";
      email = "timkalan99@gmail.com";
    };
    gpg = {
      format = "ssh";
    };
  };
  signing.key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGc1JHW7HfZxlNrIxHEnsfy3kqG1mhMSwupx9z4zLJrn";
  signing.signByDefault = true;
}
