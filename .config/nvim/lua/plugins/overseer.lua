return {
  {
    "stevearc/overseer.nvim",
    keys = {
      {
        "<leader>os",
        function()
          vim.ui.input({ prompt = "Command: " }, function(input)
            if input and input ~= "" then
              require("overseer")
                .new_task({
                  cmd = vim.split(input, " "),
                  components = { "default" },
                })
                :start()
            end
          end)
        end,
        desc = "Run Manual Command",
      },
    },
    opts = {
      task_list = {
        direction = "bottom",
        min_height = 30,
      },
    }, -- Puedes poner opciones globales aquí
    config = function(_, opts)
      local overseer = require("overseer")
      overseer.setup(opts)
    end,
  },
}
