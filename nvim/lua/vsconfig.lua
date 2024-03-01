local vscode = require('vscode-neovim')

-- navigation
local navigation = {
    previousEditor = function()
        vscode.call("workbench.action.previousEditor")
    end,
    nextEditor = function()
        vscode.call("workbench.action.nextEditor")
    end,
    gotoSymbol = function()
        vscode.call("workbench.action.gotoSymbol")
    end,
    gotoSymbolInProject = function()
        vscode.call("workbench.action.showAllSymbols")
    end,
    peekDefinition = function()
        vscode.call("editor.action.peekDefinition")
    end,
    peekReferences = function()
        vscode.call("editor.action.referenceSearch.trigger")
    end,
    quickOpen = function()
        vscode.call("workbench.action.quickOpen")
    end,
}

vim.keymap.set({ 'n', 'v' }, 'gh', '^')
vim.keymap.set({ 'n', 'v' }, 'gl', '$')
vim.keymap.set({ 'n', 'v' }, 'ga', '%')
vim.keymap.set({ 'n', 'v' }, "<leader>h", navigation.previousEditor)
vim.keymap.set({ 'n', 'v' }, "<leader>l", navigation.nextEditor)
vim.keymap.set({ 'n', 'v' }, 'gs', navigation.gotoSymbol)
vim.keymap.set({ 'n', 'v' }, 'gS', navigation.gotoSymbolInProject)
vim.keymap.set({ 'n', 'v' }, 'gd', navigation.peekDefinition)
vim.keymap.set({ 'n', 'v' }, 'gr', navigation.peekReferences)
vim.keymap.set({ 'n', 'v' }, 'gp', navigation.quickOpen)

-- misc
local misc = {
    smartSelectOut = function()
        vscode.call("editor.action.smartSelect.expand")
    end,
    smartSelectIn = function()
        vscode.call("editor.action.smartSelect.shrink")
    end,
    quickfix = function()
        vscode.call("editor.action.quickFix")
    end,
    rename = function()
        vscode.call("editor.action.rename")
    end,
}

vim.keymap.set({ 'n', 'v' }, 'go', misc.smartSelectOut)
vim.keymap.set({ 'n', 'v' }, 'gi', misc.smartSelectIn)

vim.keymap.set({ 'n', 'x' }, 'z=', misc.quickfix)
vim.keymap.set({ 'n', 'v' }, 'gR', misc.rename)

-- file
local file = {
    new = function()
        vscode.call("workbench.explorer.fileView.focus")
        vscode.call("explorer.newFile")
    end,
    save = function()
        vscode.call("workbench.action.files.save")
    end,
    saveAll = function()
        vscode.call("workbench.action.files.saveAll")
    end,
    format = function()
        vscode.call("editor.action.formatDocument")
    end,
    showInExplorer = function()
        vscode.call("workbench.files.action.showActiveFileInExplorer")
    end,

    rename = function()
        vscode.call("workbench.files.action.showActiveFileInExplorer")
        vscode.call("renameFile")
    end
}

vim.keymap.set({ 'n', 'v' }, "<leader>fs", file.save)
vim.keymap.set({ 'n', 'v' }, "<leader>fS", file.saveAll)
vim.keymap.set({ 'n' }, "<leader>ff", file.format)
vim.keymap.set({ 'n' }, "<leader>fn", file.new)
vim.keymap.set({ 'n' }, "<leader>ft", file.showInExplorer)
vim.keymap.set({ 'n' }, "<leader>fr", file.rename)

local vscodeStuff = {
    showCommands = function()
        vscode.call("workbench.action.showCommands")
    end,
    toggleActivityBar = function()
        vscode.call("workbench.action.toggleActivityBarVisibility")
    end,
    toggleSideBarVisibility = function()
        vscode.call("workbench.action.toggleSidebarVisibility")
    end,
    selectTheme = function()
        vscode.call("workbench.action.selectTheme")
    end,
}

vim.keymap.set({ 'n', 'v' }, "<leader>vp", vscodeStuff.showCommands)
vim.keymap.set({ 'n', 'v' }, "<leader>va", vscodeStuff.toggleActivityBar)
vim.keymap.set({ 'n', 'v' }, "<leader>vs", vscodeStuff.toggleSideBarVisibility)
vim.keymap.set({ 'n', 'v' }, "<leader>vt", vscodeStuff.selectTheme)

--folding
local fold = {
    toggle = function()
        vscode.call("editor.toggleFold")
    end,
    all = function()
        vscode.call("editor.foldAll")
    end,
    openAll = function()
        vscode.call("editor.unfoldAll")
    end,
    close = function()
        vscode.call("editor.fold")
    end,
    open = function()
        vscode.call("editor.unfold")
    end,
    openRecursive = function()
        vscode.call("editor.unfoldRecursively")
    end,
    blockComment = function()
        vscode.call("editor.foldAllBlockComments")
    end,
    allMarkerRegion = function()
        vscode.call("editor.foldAllMarkerRegions")
    end,
    openAllMarkerRegion = function()
        vscode.call("editor.unfoldAllMarkerRegions")
    end,
}

vim.keymap.set({ 'n' }, "zm", fold.all)
vim.keymap.set({ 'n' }, "zr", fold.openAll)
vim.keymap.set({ 'n' }, "zO", fold.openRecursive)
vim.keymap.set({ 'n' }, "zo", fold.open)
vim.keymap.set({ 'n' }, "zb", fold.blockComment)
vim.keymap.set({ 'n' }, "zc", fold.close)
vim.keymap.set({ 'n' }, "zg", fold.allMarkerRegion)
vim.keymap.set({ 'n' }, "zG", fold.openAllMarkerRegion)
vim.keymap.set({ 'n' }, "za", fold.toggle)
vim.keymap.set({ 'n' }, "<tab>", fold.toggle)

-- errors
local error = {
    list = function()
        vscode.call("workbench.actions.view.problems")
    end,
    next = function()
        vscode.call("editor.action.marker.next")
    end,
    previous = function()
        vscode.call("editor.action.marker.prev")
    end,
}

vim.keymap.set({ 'n' }, "<leader>el", error.list)
vim.keymap.set({ 'n' }, "]e", error.next)
vim.keymap.set({ 'n' }, "<leader>en", error.next)
vim.keymap.set({ 'n' }, "[e", error.previous)
vim.keymap.set({ 'n' }, "<leader>ep", error.previous)

-- windows
local window = {
    up = function()
        vscode.call("workbench.action.navigateUp")
    end,
    down = function()
        vscode.call("workbench.action.navigateDown")
    end,
    left = function()
        vscode.call("workbench.action.navigateLeft")
    end,
    right = function()
        vscode.call("workbench.action.navigateRight")
    end,
    vSplit = function()
        vscode.call("workbench.action.splitEditor")
    end,
    split = function()
        vscode.call("workbench.action.splitEditorDown")
    end,
    close = function()
        vscode.call("workbench.action.closeActiveEditor")
    end,
}

vim.keymap.set({ 'n' }, "<leader>wk", window.up)
vim.keymap.set({ 'n' }, "<leader>wj", window.down)
vim.keymap.set({ 'n' }, "<leader>wh", window.left)
vim.keymap.set({ 'n' }, "<leader>wl", window.right)
vim.keymap.set({ 'n' }, "<leader>wv", window.vSplit)
vim.keymap.set({ 'n' }, "<leader>ws", window.split)
vim.keymap.set({ 'n' }, "<leader>wc", window.close)
