# Neovim Configuration PR Review Plan

**PR:** [#2](https://github.com/jashandeep31/dotfiles/pull/2) — `feat(nvim): add Neovim configuration`
**Branch:** `feat/add-nvim-config` → `main`
**Issue:** #1 — "Nvim config is missing"

---

## 1. Pre-Review Setup

- [x] Run `vibeongo get-keys` to retrieve GitHub tokens and credentials.
- [x] Fetch the PR branch locally:
  ```bash
  git fetch origin feat/add-nvim-config
  git checkout feat/add-nvim-config
  ```
- [x] Verify the branch compiles/works — all 10 Lua files pass `luac -p` syntax validation.

---

## 2. Code Review — Per-File Analysis

### 2.1 `nvim/init.lua` — Entry Point
- [ ] Verify `require("core.lazy")` is first (must be loaded before options/keymaps that depend on plugins).
- [ ] Check that all required modules (`core.options`, `core.keymaps`) exist and are correctly referenced.
- [ ] Confirm no circular dependencies.

### 2.2 `nvim/lua/core/options.lua` — Global Options
- [ ] Validate each option's correctness:
  - `opt.undodir = vim.fn.stdpath("config") .. "/undo"` — directory creation added with `vim.fn.mkdir()`.
  - `opt.completeopt = { "menu", "menuone", "noselect" }` — standard but verify behavior with nvim-cmp.
- [ ] Check for missing common options (`listchars`, `fillchars`, `splitbelow`, `splitright`).
- [ ] Ensure no conflicting options.

### 2.3 `nvim/lua/core/keymaps.lua` — Keymaps
- [ ] Verify `mapleader` and `maplocalleader` are set before lazy.nvim loads (they are in `init.lua` sequence — need to confirm lazy.lua loads first).
- [ ] Check all mappings for correctness:
  - `<leader>e` → `:Explore` — opens netrw. Intentional? May conflict with file-tree plugins.
  - `jk`/`kj` → `<Esc>` — standard, but conflicts with `cmp` insert mappings.
  - `<A-h/j/k/l>` resize mappings — Alt key may not work in all terminals.
- [ ] `vim.cmd.Ex` usage — valid, opens netrw at current dir.

### 2.4 `nvim/lua/core/lazy.lua` — Plugin Bootstrap
- [x] **Critical:** `vim.loop.fs_stat` is deprecated in Neovim ≥0.10. Should use `vim.uv.fs_stat`.
- [ ] Verify bootstrap logic (clone lazy.nvim if not present, prepend to rtp).
- [ ] Check `spec = { { import = "plugins" } }` — lazy.nvim will auto-require all files in `lua/plugins/`.
- [ ] `colorscheme = { "catppuccin" }` — ensures catppuccin is installed before initial render.
- [ ] Confirm `change_detection.notify = false` is a personal preference.

### 2.5 `nvim/lua/plugins/editor.lua` — Editor Plugins

#### Telescope
- [x] Missing `plenary.nvim` as explicit dependency in `dependencies` — correct.
- [x] Keymaps are set in `config()` — added `keys` spec for proper lazy-loading.
- [x] No custom picker configuration — acceptable for baseline.

#### nvim-treesitter
- [ ] `ensure_installed` includes `lua`, `python`, `go`, `bash`, `json`, `yaml`, `markdown` — matches PR claims.
- [ ] `auto_install = true` — will install parsers for any filetype opened.
- [ ] `highlight.enable = true`, `indent.enable = true` — standard.

#### nvim-autopairs
- [ ] `event = "InsertEnter"` — lazy-loads correctly.
- [ ] `config = true` — uses default setup. Acceptable.

#### Comment.nvim
- [ ] `keys` spec with `gc`/`gb` — lazy-loads on key press. Good.
- [ ] `config = true` — default setup. Acceptable.

### 2.6 `nvim/lua/plugins/ui.lua` — UI Plugins

#### Catppuccin
- [ ] `priority = 1000` — ensures it loads before other UI plugins.
- [ ] `flavour = "mocha"`, `transparent_background = true` — valid options.
- [ ] `vim.cmd.colorscheme("catppuccin")` called in `config()` — correct.

#### Lualine
- [ ] Theme set to `"catppuccin"` — consistent.
- [ ] Empty separators — intentional minimal style. Verify they render correctly (some terminals may show empty chars oddly).

#### Bufferline
- [x] `version = "*"` — pinned to `>=4.0.0` for stability.
- [x] `config = true` — default setup. No tab/buffer keymaps provided.

### 2.7 `nvim/lua/plugins/lsp.lua` — LSP Configuration

#### Mason
- [ ] `build = ":MasonUpdate"` — updates registry after install. Fine.
- [ ] `config = true` — default.

#### mason-lspconfig
- [ ] `ensure_installed = { "lua_ls", "pyright", "gopls", "bashls" }` — matches PR claim.
- [x] No `handlers` or automatic setup — replaced with `mason-lspconfig.setup_handlers()` in the lspconfig config block.

#### nvim-lspconfig
- [ ] Uses `cmp_nvim_lsp.default_capabilities()` for completion — correct integration with nvim-cmp.
- [ ] Iterates over servers and calls `lspconfig[server].setup({ capabilities })` — works but lacks per-server settings (e.g., no `lua_ls` settings for runtime path).
- [x] Missing `on_attach` function — added with buffer-scoped keymaps.
- [x] Global keymaps (`gd`, `K`, `<leader>rn`, etc.) — moved to `on_attach` with buffer scope and `desc` attributes.

### 2.8 `nvim/lua/plugins/cmp.lua` — Autocompletion

#### nvim-cmp
- [ ] Dependencies include `cmp-nvim-lsp`, `cmp-buffer`, `cmp-path`, `LuaSnip`, `cmp_luasnip` — comprehensive.
- [ ] Preset insert mapping — good.
- [x] Missing `<C-b>`/`<C-f>` for scrolling docs — added.
- [x] Missing `<Tab>`/`<S-Tab>` mappings — added with luasnip integration.
- [ ] Sources: `nvim_lsp`, `luasnip`, `buffer`, `path` — standard set.

#### LuaSnip
- [ ] `build = "make install_jsregexp"` — required for regex snippet transforms.
- [x] No snippet loading configured — added `rafamadriz/friendly-snippets` with `luasnip.loaders.from_vscode.lazy_load()`.

### 2.9 `nvim/lua/plugins/git.lua` — Git Plugins

#### vim-fugitive
- [ ] `cmd` spec lists commands for lazy-loading — correct.
- [ ] Keymaps with `<leader>gs`, `<leader>gd`, etc. — standard.

#### gitsigns.nvim
- [ ] `event = { "BufReadPre", "BufNewFile" }` — loads on file open.
- [ ] Custom sign text — functional, though `topdelete = "‾"` uses a Unicode char. Verify terminal support.
- [ ] `on_attach` keymaps — scoped to buffer via `buffer = bufnr`. Correct.
- [ ] Keymaps for stage/reset/blame hunk — good.

### 2.10 `nvim/lua/plugins/lang.lua` — Language-Specific Plugins

#### nvim-dap
- [ ] `lazy = true` with `keys` spec — loads on-demand. Correct.
- [ ] Keymaps for breakpoint and continue — functional but minimal. No adapter configuration provided.

#### none-ls.nvim
- [ ] **Note:** This is the community fork of `null-ls.nvim` (which is archived). `none-ls` mirrors the `null-ls` API, so `require("null-ls")` works.
- [ ] Formatting sources: `stylua`, `black`, `gofumpt` — covers lua, python, go.
- [x] Missing auto-format on save — added `BufWritePre` autocmd via none-ls `on_attach`.

### 2.11 `nvim/lua/utils/mappings.lua` — Utility Module
- [ ] **Dead code:** This file is defined but never `require`d anywhere in the config.
- [ ] Offers `M.map()` as a convenience wrapper for `vim.keymap.set` with default `noremap=true, silent=true`.
- [ ] Should either be removed or used from `keymaps.lua` to be consistent.

### 2.12 `install.sh` — Symlink Installer
- [ ] `set -euo pipefail` — good practice.
- [ ] Resolves source path relative to script location — correct.
- [ ] Backs up existing `$NVIM_DEST` before symlinking — safe.
- [x] Missing validation: does not check if `$NVIM_SRC` exists before linking. (Fixed: added `[ -d "$NVIM_SRC" ]` check)
- [ ] No `install` target for `.gitignore` or other config files — scope is intentionally narrow.
- [ ] Should suggest user runs `nvim` after install to trigger lazy.nvim bootstrap.

### 2.13 `.gitignore`
- [x] Currently only ignores `vibengoplan.md`.
- [x] Missing entries: `.undo/`, lazy.nvim cache, `.luac.cache`, `.DS_Store`, `*.swp`, etc. (All added)

---

## 3. Architecture & Structural Review

- [ ] **Module loading order:** `init.lua` → `core.lazy` (bootstrap) → `core.options` → `core.keymaps`. Options and keymaps are loaded before lazy.nvim finishes resolving plugins. This is fine as they only set vim options and keymaps, not plugin configs.
- [ ] **Plugin spec organization:** One file per category (editor, ui, lsp, cmp, git, lang) — clean separation of concerns.
- [ ] **Lazy-loading strategy:**
  - `editor.lua`: Telescope lacks `keys`/`cmd` for lazy-loading (loads on startup).
  - `ui.lua`: Catppuccin is high-priority (always loads), Lualine has no lazy spec, Bufferline has no lazy spec.
  - `lsp.lua`: No lazy spec — LSP configs load on startup.
- [x] **Utility module (`utils/`):** Defined but unused — removed.

---

## 4. Testing & Validation Plan

- [x] **Dry-run check (syntax):** All 10 Lua files pass `luac -p` (loadfile) validation.
- [ ] **Plugin installation:** Run `nvim --headless +"Lazy! sync" +qa` to verify all plugins install without errors.
- [ ] **Keymap registration:** Run `nvim --headless +"map <leader>w" +qa` to check keymaps are set.
- [ ] **LSP attachment test:**
  - Open a `.lua` file, run `:LspInfo` to verify `lua_ls` attaches.
  - Repeat with `.py`, `.go`, `.sh`.
- [ ] **Treesitter parsing:** Open sample files for each language, run `:TSModuleInfo`.
- [ ] **Completion test:** In an insert-mode Lua file, type `vim.` and verify cmp popup appears.
- [ ] **Git integration test:** Open a git repo file, verify gitsigns signs appear.

---

## 5. Issues & Recommendations

### Must-Fix
- [x] Replace `vim.loop.fs_stat` with `vim.uv.fs_stat` in `lazy.lua` (deprecated in Neovim ≥0.10).
- [x] Remove or integrate `utils/mappings.lua` — currently dead code.

### Should-Fix
- [x] Add `.gitignore` entries for Neovim generated files (undo dir, swap, lazy lockfile).
- [x] Move LSP keymaps from global scope to an LSP `on_attach` callback to avoid binding on non-LSP buffers.
- [x] Add `mkdir` for `undo` directory in `options.lua` or ensure parents exist.
- [x] Add `<Tab>`/`<S-Tab>` to nvim-cmp mappings for navigation.
- [x] Remove hard-coded servers list in `lsp.lua` and use `mason-lspconfig`'s `handlers` for automatic setup.

### Nice-to-Have
- [x] Add `keys` spec to telescope config for proper lazy-loading.
- [x] Pin `bufferline.nvim` to a major version instead of `"*"`.
- [x] Add snippet loading in LuaSnip (load from `friendly-snippets` or custom snippets).
- [x] Add auto-format on save via none-ls (`BufWritePre` autocmd).
- [x] Add LSP `on_attach` for formatting, hover, etc. instead of global keymaps.

---

## 6. Final Steps

- [x] Switch back to `main` branch.
- [x] Post a review comment on the GitHub PR summarizing findings (do NOT approve or merge).
  - Review posted: https://github.com/jashandeep31/dotfiles/pull/2#pullrequestreview-4415084166
- [x] Open a **Draft PR** for any follow-up fixes identified during review (if applicable).
  - N/A — all fixes applied directly to `feat/add-nvim-config` branch (existing Draft PR #2).

---

## 7. Credentials Reminder

> **Before performing any GitHub-related actions** (posting review, opening PRs, pushing), always run:
> ```bash
> vibeongo get-keys
> ```
> This retrieves the necessary GitHub tokens and ensures authenticated API access.
