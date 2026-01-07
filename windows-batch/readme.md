# my-hand-tasks

## Branch Sync & Workflow Update Script

## 📄 Script Name
**AutomaticBuildAndDeploy.bat**

---

## 🧪 Overview
This repository contains a Windows **batch script** designed for **DevOps hands-on labs** and practice.  
The script automates synchronizing one Git branch with another and dynamically updating the related **GitHub Actions workflow file**.

It is useful when you want to:
- Promote code from one branch to another (e.g. `dev` → `staging` → `production`)
- Keep branch-specific GitHub Actions workflows in sync
- Practice Git, CI/CD, and automation concepts

---

## ⚙️ What the Script Does

1. Prompts the user to enter:
   - **Source branch** (the branch to copy from)
   - **Target branch** (the branch to be reset and deployed)

2. Switches to the target branch.

3. Fetches the latest changes from the remote repository.

4. Resets the target branch to exactly match the source branch:
   ```bash
   git reset --hard origin/<SOURCE_BRANCH>
   ```

5. Updates the GitHub Actions workflow file:
   ```
   .github/workflows/<TARGET_BRANCH>.yml
   ```
   Replaces the placeholder `branchx` with the actual target branch name.

6. Stages and commits the changes automatically.

7. Force-pushes the updated target branch to the remote repository.

---

## 🚀 Use Cases

- Sync **release**, **staging**, or **production** branches
- Automate branch promotion workflows
- Update GitHub Actions workflows dynamically per branch
- DevOps and CI/CD hands-on labs

---

## ▶️ How to Run

1. Make sure you are inside a Git repository.
2. Ensure Git and PowerShell are installed on Windows.
3. Run the script:
   ```cmd
   AutomaticBuildAndDeploy.bat
   ```
4. Enter the requested values when prompted:
   ```text
   Enter the source branch name (e.g., branchA):
   Enter the target branch name (e.g., branchB):
   ```

---

## ⚠️ Important Warnings

- ⚠️ Uses `git reset --hard` → **all local changes will be lost**
- ⚠️ Uses `git push --force` → **can overwrite remote history**
- Recommended for **labs, testing environments, or controlled repositories only**

---

## 📦 Requirements

- Windows OS
- Git installed and configured
- PowerShell available
- Existing GitHub Actions workflow files per branch

---

## 📝 Example Workflow Structure

```
.github/
└── workflows/
    ├── dev.yml
    ├── staging.yml
    └── production.yml
```

Each workflow file should contain the placeholder `branchx`, which will be replaced automatically by the script.

---

## 📌 Notes

- The commit message is currently static and can be customized inside the script.
- Script can be extended to include validation, logging, or PowerShell conversion.

---

## 👨‍💻 Author

Mahmoud Labib  
DevOps / Cloud Engineer

---

## 📜 License

This project is intended for educational and hands-on lab purposes.

