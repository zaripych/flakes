{lib, ...}: {
  vim = {
    options = {
      shiftwidth = 2;
    };

    theme = {
      enable = true;
      name = "gruvbox";
      style = "dark";
    };

    lsp = {
      enable = true;

      formatOnSave = true;
    };

    languages = {
      enableTreesitter = true;

      nix = {
        enable = true;
        format.enable = true;
      };
      markdown.enable = true;
      ts.enable = true;
    };

    statusline.lualine.enable = true;
    telescope.enable = true;
    autocomplete.nvim-cmp.enable = true;

    binds.whichKey.enable = true;

    mini = {
      animate.enable = true;
    };

    keymaps = [
      {
        mode = "n";
        key = "<leader>ff";
        action = ":Telescope find_files<CR>";
      }
    ];

    luaConfigRC.clipboard = lib.nvim.dag.entryAnywhere ''
      vim.o.clipboard = "unnamedplus"
      vim.api.nvim_create_autocmd("TextYankPost", {
        callback = function()
          -- vim.highlight.on_yank()
          local copy_to_unnamedplus = require("vim.ui.clipboard.osc52").copy("+")
          copy_to_unnamedplus(vim.v.event.regcontents)
          local copy_to_unnamed = require("vim.ui.clipboard.osc52").copy("*")
          copy_to_unnamed(vim.v.event.regcontents)
        end,
      })
    '';
  };
}
