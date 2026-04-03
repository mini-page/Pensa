# Hero Section Enhancement Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Transform the Hero section into a realistic, interactive app mockup using the user's layout base and an actionable icon grid.

**Architecture:** 
- Replace the existing hero section with the user's provided structure.
- Infuse realistic financial data (₹14,250 balance) into the floating card.
- Build a responsive 2x2 squircle action grid for key app features.
- Apply consistent `animate-fadeInUp` and `stagger` classes for a polished entrance.

**Tech Stack:** HTML5, Tailwind CSS, FontAwesome.

---

### Task 1: Replace Hero Section Structure

**Files:**
- Modify: `index.html:483-558`

**Step 1: Replace the entire Hero section**
Use the user's provided snippet as the base, ensuring background decorations and text content are correctly placed.

**Step 2: Restore descriptive text**
Ensure the body text ("Track expenses, manage budgets...") from the original file is preserved for clarity.

**Step 3: Commit**
```bash
git add index.html
git commit -m "refactor: update hero section layout based on new design"
```

### Task 2: Enhance Card with Realistic Stats

**Files:**
- Modify: `index.html` (Hero section floating card)

**Step 1: Update Balance**
Replace `₹0` with `₹14,250`.

**Step 2: Update Income/Expense Grid**
Replace the `₹0` values with `₹2,800` (Expense) and `₹17,050` (Income). Ensure the colors match (`text-blue-600` for expense, `text-green-600` for income).

**Step 3: Commit**
```bash
git add index.html
git commit -m "feat: add realistic financial stats to hero app mockup"
```

### Task 3: Implement 2x2 Action Grid

**Files:**
- Modify: `index.html` (Hero section floating card bottom section)

**Step 1: Replace existing buttons with grid**
Remove the "Split" and "Recurring" full-width buttons. Add a `grid grid-cols-2 gap-3 pt-2` container.

**Step 2: Add Action Buttons**
Implement 4 squircle buttons:
1. **Split**: `bg-teal-50 text-teal-600`, icon `fas fa-users-between-lines`.
2. **Bills**: `bg-amber-50 text-amber-600`, icon `fas fa-file-invoice-dollar`.
3. **Scan**: `bg-indigo-50 text-indigo-600`, icon `fas fa-barcode`.
4. **Export**: `bg-rose-50 text-rose-600`, icon `fas fa-share-nodes`.

**Step 3: Add Hover Effects**
Ensure each button has `hover:scale-105 transition-transform`.

**Step 4: Commit**
```bash
git add index.html
git commit -m "feat: implement actionable 2x2 grid in hero app mockup"
```

### Task 4: Final Polish and Animation Sync

**Files:**
- Modify: `index.html`

**Step 1: Verify Animations**
Ensure `animate-fadeInUp` and `animate-slideInRight` are working correctly. Check stagger delays.

**Step 2: Check responsiveness**
Verify that the hero section looks good on mobile (buttons should stack, card might hide).

**Step 3: Commit**
```bash
git add index.html
git commit -m "chore: final polish of hero section animations and layout"
```
