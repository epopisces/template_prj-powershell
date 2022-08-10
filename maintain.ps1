#? Note '.ps1': PowerShell can execute git commands without extra imports if git is installed on the system.  Bash could also be used
#* Init subtrees - these are commands run to create this project's subtrees (commented out track which are used)
#? this example uses tools_user_io and tools_msgraph, but you can remove, replace, or add others to this list
#! Note!  As of 2020.10 Github calls the primary branch 'main', instead of 'master', but Github prior to that date (and all DevOps/bitbucket repos)
#! initialize with 'master' still.  If a tools repo can't be pulled from 'main' branch, try replacing 'main' with 'master' in the subtree command
#git subtree add --prefix tools/user_io https://github.com/GitHub_Org/tools_user_io main --squash
#git subtree add --prefix tools/msgraph https://github.com/GitHub_Org/tools_msgraph main --squash

#* List (the below command shows all subtrees used in this repo)
#! Caution!  The PowerShell version of this command lists any subtree ever added, even those since removed
git log | Select-String -Pattern git-subtree-dir | Sort-Object | Get-Unique

# The bash version of the same does not have that issue, only currently used subtrees will be listed
# (https://stackoverflow.com/questions/16641057/how-can-i-list-the-git-subtrees-on-the-root)
#git log | grep git-subtree-dir | tr -d ' ' | cut -d ":" -f2 | sort | uniq | xargs -I {} bash -c 'if [ -d $(git rev-parse --show-toplevel)/{} ] ; then echo {}; fi'


#* Maintain (update dependencies: run these periodically or when a new feature is available you want to use in your project)
git subtree pull --prefix tools/user_io https://github.com/GitHub_Org/tools_user_io main --squash
git subtree pull --prefix tools/msgraph https://github.com/GitHub_Org/tools_msgraph main --squash
