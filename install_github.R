
github_pkgs <- c(
  'jeremystan/aargh',
  'JEFworks/HoneyBADGER',
  'jlmelville/uwot'
)

for(pkg in github_pkgs) {
  remotes::install_github(pkg)
}