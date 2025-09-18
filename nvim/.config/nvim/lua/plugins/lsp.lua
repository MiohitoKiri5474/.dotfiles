return {
  {
    "mason-org/mason.nvim",
    optional = true,
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        -- Lua related
        vim.list_extend(opts.ensure_installed, { "lua-language-server", "stylua", "luacheck" })
        -- C/C++ related
        vim.list_extend(opts.ensure_installed, { "clangd", "clang-format" })
        -- Golang related
        vim.list_extend(opts.ensure_installed, { "gopls", "golangci-lint-langserver" })
        -- Python related
        vim.list_extend(opts.ensure_installed, { "pyright", "black", "isort" })
        -- LaTeX related
        vim.list_extend(opts.ensure_installed, { "ltex-ls", "latexindent" })
        -- CSS related
        vim.list_extend(opts.ensure_installed, { "typescript-language-server", "css-lsp" })
        -- TailWindCSS related
        vim.list_extend(opts.ensure_installed, { "tailwindcss-language-server", "astro-language-server" })
        -- JavaScript related
        vim.list_extend(opts.ensure_installed, { "eslint_d", "oxlint", "prettier", "prettierd" })
        -- sh related
        vim.list_extend(opts.ensure_installed, { "shfmt", "shellcheck" })
        -- Vue related
        vim.list_extend(opts.ensure_installed, { "vue-language-server" })
        -- Rust related
        vim.list_extend(opts.ensure_installed, { "rust-analyzer" })
      end
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = { enabled = true },
      ---@type lspconfig.options
      servers = {
        cssls = {},
        html = {},
        eslint = {
          on_attach = function(client, bufnr)
            vim.api.nvim_create_autocmd("BufWritePre", {
              buffer = bufnr,
              command = "EslintFixAll",
            })
          end,
        },
        pyright = {},
        gopls = {
          cmd = { "gopls" },
          filetypes = { "go", "gomod", "gowork", "gotmpl" },
          root_dir = require("lspconfig/util").root_pattern("go.work", "go.mod", ".git"),
          autoformat = false,
        },
        ltex = {
          filetypes = { "tex" },
          flags = { debounce_text_changes = 300 },
        },
        tsserver = {
          cmd = { "tsserver" },
          filetypes = { "typescript", "typescriptreact" },
        },
        astro = {},
        volar = {},
        ts_ls = {
          init_options = {
            plugins = {
              {
                name = "@vue/typescript-plugin",
                location = "/usr/local/lib/node_modules/@vue/language-server",
                languages = { "vue" },
              },
            },
          },
          filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
        },
        clangd = {
          filetypes = { "c", "cpp" },
          cmd = { "clangd" },
          capabilities = vim.lsp.protocol.make_client_capabilities(),
        },
        lua_ls = {
          -- enabled = false,
          single_file_support = true,
          settings = {
            Lua = {
              workspace = {
                checkThirdParty = false,
              },
              completion = {
                workspaceWord = true,
                callSnippet = "Both",
              },
              misc = {
                parameters = {
                  -- "--log-level=trace",
                },
              },
              hint = {
                enable = true,
                setType = false,
                paramType = true,
                paramName = "Disable",
                semicolon = "Disable",
                arrayIndex = "Disable",
              },
              doc = {
                privateName = { "^_" },
              },
              type = {
                castNumberToInteger = true,
              },
              diagnostics = {
                disable = { "incomplete-signature-doc", "trailing-space" },
                -- enable = false,
                groupSeverity = {
                  strong = "Warning",
                  strict = "Warning",
                },
                groupFileStatus = {
                  ["ambiguity"] = "Opened",
                  ["await"] = "Opened",
                  ["codestyle"] = "None",
                  ["duplicate"] = "Opened",
                  ["global"] = "Opened",
                  ["luadoc"] = "Opened",
                  ["redefined"] = "Opened",
                  ["strict"] = "Opened",
                  ["strong"] = "Opened",
                  ["type-check"] = "Opened",
                  ["unbalanced"] = "Opened",
                  ["unused"] = "Opened",
                },
                unusedLocalExclude = { "_*" },
              },
              format = {
                enable = false,
                defaultConfig = {
                  indent_style = "space",
                  indent_size = "4",
                  continuation_indent_size = "4",
                },
              },
            },
          },
        },
      },
      setup = {
        pyright = function(_, opts)
          opts.settings = {

            python = {
              pythonPath = (function()
                local executable_name = "python"

                -- 1. Fast path: $VIRTUAL_ENV
                if vim.env.VIRTUAL_ENV then
                  local candidate = vim.env.VIRTUAL_ENV .. "/bin/" .. executable_name
                  if vim.fn.filereadable(candidate) == 1 then
                    return candidate
                  end
                end

                -- 2. Fast path: local `.venv` in project root
                local venv_dir = vim.fn.finddir(".venv", ".;")
                if venv_dir ~= "" then
                  local candidate = venv_dir .. "/bin/" .. executable_name
                  if vim.fn.filereadable(candidate) == 1 then
                    return candidate
                  end
                end

                -- 3. Fallback: if poetry.lock exists, run poetry (slow, but only when needed)
                local poetry_lock = vim.fn.findfile("poetry.lock", ".;")
                if poetry_lock ~= "" then
                  local poetry_envs =
                    vim.fn.systemlist("poetry env list --full-path -C " .. vim.fn.fnamemodify(poetry_lock, ":h"))
                  for _, env_path in ipairs(poetry_envs) do
                    if env_path ~= "" and env_path:sub(1, 1) == "/" then
                      env_path = env_path:gsub(" %(Activated%)", ""):gsub("%s+$", "")
                      local candidate = env_path .. "/bin/" .. executable_name
                      if vim.fn.filereadable(candidate) == 1 then
                        return candidate
                      end
                    end
                  end
                end

                -- 4. Last fallback: Mason
                local mason_registry = require("mason-registry")
                if mason_registry.has_package(executable_name) then
                  return mason_registry.get_package(executable_name):get_install_path()
                    .. "/venv/bin/"
                    .. executable_name
                end

                return executable_name
              end)(),
              analysis = { diagnosticMode = "off", typeCheckingMode = "off" },
            },
          }
          require("lspconfig").pyright.setup(opts)
          return true
        end,
      },
    },
  },
  "nvim-lua/lsp-status.nvim",
  {
    "hrsh7th/nvim-cmp",
    dependencies = { "hrsh7th/cmp-emoji" },
    opts = function(_, opts)
      table.insert(opts.sources, { name = "emoji" })
    end,
  },
}
