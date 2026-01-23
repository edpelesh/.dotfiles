
return {
  -----------------------------------------------------------------------------
  -- LSP servers
  -----------------------------------------------------------------------------
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Mason-managed
        lua_ls = {},
        gopls = {},
        clangd = {},

        -- Swift (NOT managed by Mason)
        sourcekit = {
          filetypes = {
            "swift",
            "objective-c",
            "objective-cpp",
          },
        },
      },
    },
    config = function(_, opts)
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      for server, config in pairs(opts.servers) do
        config.capabilities = vim.tbl_deep_extend("force", capabilities, config.capabilities or {})
        vim.lsp.config(server, config)
        vim.lsp.enable(server)
      end
    end,
  },

  -----------------------------------------------------------------------------
  -- Mason core
  -----------------------------------------------------------------------------
  {
    "williamboman/mason.nvim",
    opts = {
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    },
  },

  -----------------------------------------------------------------------------
  -- Mason ↔ LSP bridge
  -----------------------------------------------------------------------------
  {
    "williamboman/mason-lspconfig.nvim",
    opts = {
      -- ONLY servers Mason actually installs
      ensure_installed = {
        "lua_ls",
        "gopls",
        "clangd",
      },
      automatic_installation = true,
    },
  },

  -----------------------------------------------------------------------------
  -- Swift tooling
  -----------------------------------------------------------------------------
  {
    "mfussenegger/nvim-dap",
  },

  {
    "wojciech-kulik/xcodebuild.nvim",
    ft = "swift",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "mfussenegger/nvim-dap",
    },
    opts = {
      restore_session = true,
      show_build_progress_bar = true,
      auto_open_qf = true,
    },
  },

  -----------------------------------------------------------------------------
  -- LSP keymaps
  -----------------------------------------------------------------------------
  {
    "folke/noice.nvim",
    opts = function()
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function()
          local noice = require("noice.lsp")

          vim.keymap.set("n", "K", noice.hover, { buffer = true })
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = true })
          vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = true })
          vim.keymap.set("n", "[g", vim.diagnostic.goto_prev, { buffer = true })
          vim.keymap.set("n", "g]", vim.diagnostic.goto_next, { buffer = true })
          vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { buffer = true })
        end,
      })
    end,
  },
}
