@echo off
setlocal

:: Define the Branch That You Want for Deploying
set /p SOURCE_BRANCH=Enter the source branch name (e.g., branchA): 

:: Define the Branch That You On It
set /p TARGET_BRANCH=Enter the target branch name (e.g., branchB): 

:: Check out the target branch (branchB)
echo Switching to branch: %TARGET_BRANCH%
git checkout %TARGET_BRANCH%

Fetch the latest changes from remote (optional but recommended)
echo Fetching the latest changes from the remote repository...
git fetch --all


:: Reset the target branch to the source branch (branchA)

echo Resetting %TARGET_BRANCH% to match %SOURCE_BRANCH%...
git reset --hard origin/%SOURCE_BRANCH%

powershell -Command "(Get-Content '.\.github\workflows\%TARGET_BRANCH%.yml') -replace 'branchx', '%TARGET_BRANCH%' | Set-Content '.\.github\workflows\%TARGET_BRANCH%.yml'"




git add .

:: set /p commit=Enter The Commit (e.g., branchB):
:: git commit -m "%commit%"

git commit -m "This Is New Commit"



:: Push the reset target branch to the remote repository (optional, can be uncommented)

 echo Pushing changes to remote repository...
 git push origin %TARGET_BRANCH% --force

endlocal
pause
