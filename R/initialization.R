# after running the initialization command, run these lines once to set up
# your project in a consistent manner.
# private github repos can be made public via the web interface

# make a software license
usethis::use_mit_license("<your name here>")

# generate a readme file to explain your work
usethis::use_readme_md(open = FALSE)

# *** Only if developing a package ***
# uncomment and run to generate a news file to document updates.
# usethis::use_news_md()

# set your default branch to "main" for git init
system("git config --global init.defaultBranch main")

# initialize git
usethis::use_git()

# initialize github
usethis::use_github(private = TRUE)


### Delete this file after initializing the project! ###
