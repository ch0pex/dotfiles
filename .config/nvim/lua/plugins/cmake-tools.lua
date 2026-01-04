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
        ctest_command = "ctest --preset Debug-linux-gcc",
        cmake_regenerate_on_save = false,
        cmake_dap_configuration = {
          name = "cpp",
          type = "codelldb",
          request = "launch",
          stopOnEntry = false,
          runInTerminal = true,
          console = "integratedTerminal",
        },
        cmake_executor = {
          name = "overseer",
          default_opts = {
            overseer = {
              new_task_opts = {
                strategy = {
                  "jobstart",
                  use_terminal = false,
                  perserve_output = false,
                },
              },
              -- if you don't want the overseer task list to open overwritting this
              -- function helps. Otherwise just remove this section
              on_new_task = function(task)
                require("overseer").open({ enter = true, direction = "bottom" })
              end,
            },
          },
        },
        cmake_runner = { -- runner to use
          name = "overseer",
          default_opts = {
            overseer = {
              new_task_opts = {
                strategy = {
                  "jobstart",
                  use_terminal = false,
                  perserve_output = false,
                },
              },
              -- if you don't want the overseer task list to open overwritting this
              -- function helps. Otherwise just remove this section
              on_new_task = function(task)
                require("overseer").open({ enter = true, direction = "bottom" })
              end,
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
