return {
  {
    "Civitasv/cmake-tools.nvim",
    config = function()
      local cmake = require("cmake-tools")
      local dap = require("dap")

      cmake.setup({
        cmake_command = "cmake",

        cmake_build_directory = "", -- carpeta de build raíz
        cmake_build_directory_prefix = "build/", -- prefijo de carpetas de build
        cmake_build_type = "Debug", -- build type por defecto
        cmake_generate_options = { "-D", "CMAKE_EXPORT_COMPILE_COMMANDS=1" },
        cmake_build_options = {},
        cmake_console_size = 10,
        cmake_dap_configuration = {
          name = "cpp",
          type = "codelldb",
          request = "launch",
          cwd = "${workspaceFolder}",
          stopOnEntry = false,

          runInTerminal = true,
          console = "integratedTerminal",
        },
        cmake_dap_open_command = dap.repl.open, -- opcional
        cmake_variants_message = {
          short = { show = true },
          long = { show = true, max_length = 40 },
        },
      })

      local opts = { noremap = true, silent = true }

      -- Keymaps rápidos
      vim.keymap.set("n", "<leader>jb", "<cmd>CMakeBuild<cr>", opts)
      vim.keymap.set("n", "<leader>jr", "<cmd>CMakeRun<cr>", opts)
      vim.keymap.set("n", "<leader>jd", "<cmd>CMakeDebug<cr>", opts)
      vim.keymap.set("n", "<leader>js", "<cmd>CMakeSelectBuildTarget<cr>", opts)
      vim.keymap.set("n", "<leader>jl", "<cmd>CMakeSelectLaunchTarget<cr>", opts)
      vim.keymap.set("n", "<leader>jk", "<cmd>CMakeSelectKit<cr>", opts)
      vim.keymap.set("n", "<leader>jc", "<cmd>CMakeSelectConfigurePreset<cr>", opts)
      vim.keymap.set("n", "<leader>jp", "<cmd>CMakeSelectBuildPreset<cr>", opts)
    end,
  },
}
