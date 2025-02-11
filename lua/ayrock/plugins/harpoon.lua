return {
  "ThePrimeagen/harpoon",
  name = 'harpoon',
  branch = "harpoon2",
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope.nvim',
  },
  config = function()
    local harpoon = require("harpoon").setup()
    local conf = require("telescope.config").values

    local function toggle_telescope(harpoon_files)
      local file_paths = {}
      for _, item in ipairs(harpoon_files.items) do
        table.insert(file_paths, item.value)
      end
  
      require("telescope.pickers").new({}, {
        prompt_title = "Harpoon",
        finder = require("telescope.finders").new_table({
            results = file_paths,
        }),
        previewer = conf.file_previewer({}),
        sorter = conf.generic_sorter({}),
      }):find()
    end

    vim.keymap.set("n", "<leader>a", function() harpoon:list():append() end, { desc = "Harpoon this shit" })

    -- use telescope to open harpoon list
    vim.keymap.set("n", "<C-e>", function() toggle_telescope(harpoon:list()) end, { desc = "Explore Harpoons" })

    vim.keymap.set("n", "<C-h>", function() harpoon:list():select(1) end, { desc = "Goto Harpoon one" })
    vim.keymap.set("n", "<C-t>", function() harpoon:list():select(2) end, { desc = "Goto Harpoon two" })
    vim.keymap.set("n", "<C-n>", function() harpoon:list():select(3) end, { desc = "Goto Harpoon three" })
    vim.keymap.set("n", "<C-s>", function() harpoon:list():select(4) end, { desc = "Goto Harpoon four" })

    -- Toggle previous & next buffers stored within Harpoon list
    vim.keymap.set("n", "<C-S-P>", function() harpoon:list():prev() end, { desc = "Goto [P]revious Harpoon" })
    vim.keymap.set("n", "<C-S-N>", function() harpoon:list():next() end, { desc = "Goto [N]ext Harpoon four" })
  end,
}
