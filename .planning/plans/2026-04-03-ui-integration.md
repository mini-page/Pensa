# UI Integration and Sync Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Integrate 26 remote commits from `origin/main` into local work and safely push uncommitted UI changes.

**Architecture:** Use a `git commit` followed by `git pull --rebase` strategy to maintain a linear history and resolve conflicts early.

**Tech Stack:** Git, Flutter (for verification).

---

### Task 1: Secure Local Changes

**Files:**
- Modify: All currently modified files (see `git status`)

**Step 1: Stage all changes**

Run: `git add .`
Expected: All local modifications are staged.

**Step 2: Commit local work**

Run:
```bash
git commit -m "$(cat <<'EOF'
feat: implement UI updates and feature enhancements

- Update core theme and app colors
- Refactor expense providers and screens
- Integrate barcode/QR scanner and Power Pill menu

Co-Authored-By: Claude Opus 4.6 <noreply@anthropic.com>
EOF
)"
```
Expected: Local commit created successfully.

**Step 3: Verify local commit**

Run: `git status`
Expected: "Your branch is ahead of 'origin/main' by 1 commit and behind by 26 commits."

---

### Task 2: Integrate Remote Changes

**Step 1: Pull with Rebase**

Run: `git pull --rebase origin main`
Expected: Git attempts to replay local commit on top of 26 remote commits.

**Step 2: Resolve Conflicts (if any)**

If conflicts occur:
1.  Identify conflicting files using `git status`.
2.  Resolve manually or using `git checkout --ours/theirs` if appropriate.
3.  `git add <resolved-files>`
4.  `git rebase --continue`

**Step 3: Verify Integration**

Run: `git log --oneline -n 30`
Expected: A linear history with local commit at the top.

---

### Task 3: Quality Check

**Step 1: Run Flutter Analysis**

Run: `flutter analyze`
Expected: No critical linting errors or breaking changes.

**Step 2: Run Tests**

Run: `flutter test`
Expected: All tests pass.

---

### Task 4: Push to Remote

**Step 1: Push to Origin**

Run: `git push origin main`
Expected: Successfully pushed to remote main.
