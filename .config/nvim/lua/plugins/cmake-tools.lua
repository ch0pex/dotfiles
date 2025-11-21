-- return {
--   {
--     "Civitasv/cmake-tools.nvim",
--     config = function()
--       local cmake = require("cmake-tools")
--       local dap = require("dap")
--
--       cmake.setup({
--         cmake_command = "cmake",
--         cmake_build_directory = "", -- carpeta de build raíz
--         cmake_build_directory_prefix = "build/", -- prefijo de carpetas de build
--         cmake_build_type = "Debug", -- build type por defecto
--         cmake_generate_options = { "-D", "CMAKE_EXPORT_COMPILE_COMMANDS=1" },
--         cmake_build_options = {},
--         cmake_console_size = 10,
--         cmake_dap_configuration = {
--           name = "cpp",
--           type = "codelldb",
--
--           request = "launch",
--           cwd = "${workspaceFolder}",
--
--           stopOnEntry = false,
--           runInTerminal = true,
--           console = "integratedTerminal",
--         },
--         cmake_dap_open_command = dap.repl.open, -- opcional
--         cmake_variants_message = {
--           short = { show = true },
--           long = { show = true, max_length = 40 },
--         },
--         -- Añadimos la configuración de terminal con nombre
--         terminal = {
--           split_direction = "vertical",
--           split_size = 11,
--           single_terminal_per_instance = false,
--           single_terminal_per_tab = false,
--           keep_terminal_static_location = false,
--           auto_resize = true,
--
--           focus = true,
--           do_not_add_newline = false,
--         },
--       })
--
--       local opts = { noremap = true, silent = true }
--
--       -- Keymaps rápidos
--       vim.keymap.set("n", "<leader>jb", "<cmd>CMakeBuild<cr>", opts)
--       vim.keymap.set("n", "<leader>jr", "<cmd>CMakeRun<cr>", opts)
--       vim.keymap.set("n", "<leader>jd", "<cmd>CMakeDebug<cr>", opts)
--       vim.keymap.set("n", "<leader>js", "<cmd>CMakeSelectBuildTarget<cr>", opts)
--       vim.keymap.set("n", "<leader>jl", "<cmd>CMakeSelectLaunchTarget<cr>", opts)
--       vim.keymap.set("n", "<leader>jk", "<cmd>CMakeSelectKit<cr>", opts)
--       vim.keymap.set("n", "<leader>jc", "<cmd>CMakeSelectConfigurePreset<cr>", opts)
--       vim.keymap.set("n", "<leader>jp", "<cmd>CMakeSelectBuildPreset<cr>", opts)
--       vim.keymap.set("n", "<leader>jt", "<cmd>CMakeRunTest<cr>", opts)
--     end,
--   },
-- }
return {
  {
    "Civitasv/cmake-tools.nvim",
    lazy = true,
    event = { "BufReadPost", "BufNewFile" },

    config = function()
      local osys = require("cmake-tools.osys")
      local cmake = require("cmake-tools")
      local dap = require("dap")

      cmake.setup({
        cmake_command = "cmake",
        ctest_command = "ctest -j",
        cmake_generate_options = { "-DCMAKE_EXPORT_COMPILE_COMMANDS=1" },
        cmake_build_options = {},
        cmake_dap_configuration = {
          name = "cpp",
          type = "codelldb",
          request = "launch",
          stopOnEntry = false,
          runInTerminal = true,
          console = "integratedTerminal",
        },
        cmake_executor = { -- executor to use
          name = "quickfix", -- name of the executor

          opts = {}, -- the options the executor will get, possible values depend on the executor type. See `default_opts` for possible values.

          default_opts = { -- a list of default and possible values for executors
            quickfix = {
              show = "always", -- "always", "only_on_error"
              position = "vertical", -- "vertical", "horizontal", "leftabove", "aboveleft", "rightbelow", "belowright", "topleft", "botright", use `:h vertical` for example to see help on them

              size = 90,
              encoding = "utf-8", -- if encoding is not "utf-8", it will be converted to "utf-8" using `vim.fn.iconv`
              auto_close_when_success = true, -- typically, you can use it with the "always" option; it will auto-close the quickfix buffer if the execution is successful.
            },
          },
        },
        cmake_runner = { -- runner to use
          name = "quickfix", -- name of the runner
          opts = {}, -- the options the runner will get, possible values depend on the runner type. See `default_opts` for possible values.

          default_opts = { -- a list of default and possible values for runners
            quickfix = {
              show = "always", -- "always", "only_on_error"
              position = "vertical", -- "bottom", "top"

              size = 90,
              encoding = "utf-8",
              auto_close_when_success = true, -- typically, you can use it with the "always" option; it will auto-close the quickfix buffer if the execution is successful.
            },
          },
        },

        cmake_notifications = {
          runner = { enabled = true },
          executor = { enabled = true },
          spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" },
          refresh_rate_ms = 100,
        },
        cmake_virtual_text_support = true,
        cmake_use_scratch_buffer = false,
      })

      local opts = { noremap = true, silent = true }
      vim.keymap.set("n", "<leader>jb", "<cmd>CMakeBuild<cr>", opts)
      vim.keymap.set("n", "<leader>jr", "<cmd>CMakeRun<cr>", opts)
      vim.keymap.set("n", "<leader>jd", "<cmd>CMakeDebug<cr>", opts)
      vim.keymap.set("n", "<leader>js", "<cmd>CMakeSelectBuildTarget<cr>", opts)
      vim.keymap.set("n", "<leader>jl", "<cmd>CMakeSelectLaunchTarget<cr>", opts)
      vim.keymap.set("n", "<leader>jk", "<cmd>CMakeSelectKit<cr>", opts)
      vim.keymap.set("n", "<leader>jc", "<cmd>CMakeSelectConfigurePreset<cr>", opts)
      vim.keymap.set("n", "<leader>jp", "<cmd>CMakeSelectBuildPreset<cr>", opts)
      vim.keymap.set("n", "<leader>jt", "<cmd>CMakeRunTest<cr>", opts)
    end,
  },
}
