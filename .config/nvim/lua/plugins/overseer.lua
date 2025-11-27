return {
  {
    "stevearc/overseer.nvim",
    opts = {}, -- Puedes poner opciones globales aquí
    config = function(_, opts)
      local overseer = require("overseer")
      overseer.setup(opts)

      -- === 1. Tarea CMake Configure ===
      overseer.register_template({
        name = "CMake Configure",
        desc = "Generar archivos de construcción en ./build",

        params = {
          mi_arg = {
            type = "string",
            desc = "cmake [...]",
            optional = false,
          },
        },
        builder = function(params)
          return {

            cmd = { "cmake" },
            args = { params.mi_arg },
            components = {
              "default",
              "on_complete_notify",
            },
          }
        end,

        condition = {
          callback = function(search)
            return vim.fn.filereadable(search.dir .. "/CMakeLists.txt") == 1
          end,
        },
      })

      overseer.register_template({
        name = "Run CTest",

        desc = "Ejecutar tests dentro de ./build",
        params = {
          mi_arg = {
            type = "string",
            desc = "ctest [...]",
            optional = false,
          },
        },

        builder = function(params)
          return {
            cmd = { "ctest" },
            args = { params.mi_arg },

            cwd = "build",

            components = {
              "default",
              "on_complete_notify",
            },
          }
        end,
        condition = {
          callback = function(search)
            return vim.fn.isdirectory(search.dir .. "/build") == 1
          end,
        },
      })
    end,
  },
}
