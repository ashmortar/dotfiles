return { -- Collection of various small independent plugins/modules
  'echasnovski/mini.nvim',
  version = '*',
  lazy = false,
  config = function()
    -- Better Around/Inside textobjects
    --
    -- Examples:
    --  - va)  - [V]isually select [A]round [)]paren
    --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
    --  - ci'  - [C]hange [I]nside [']quote
    require('mini.ai').setup { n_lines = 500 }

    -- Add/delete/replace surroundings (brackets, quotes, etc.)
    --
    -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
    -- - sd'   - [S]urround [D]elete [']quotes
    -- - sr)'  - [S]urround [R]eplace [)] [']
    require('mini.surround').setup()

    -- Simple and easy statusline.
    --  You could remove this setup call if you don't like it,
    --  and try some other statusline plugin
    -- local statusline = require 'mini.statusline'
    -- set use_icons to true if you have a Nerd Font
    -- statusline.setup { use_icons = vim.g.have_nerd_font }

    -- You can configure sections in the statusline by overriding their
    -- default behavior. For example, here we set the section for
    -- cursor location to LINE:COLUMN
    ---@diagnostic disable-next-line: duplicate-set-field
    -- statusline.section_location = function()
    -- return '%2l:%-2v'
    -- end

    -- setup sessions
    local sessions = require 'mini.sessions'
    sessions.setup()

    vim.keymap.set('n', '<leader>wn', function()
      vim.ui.input({ prompt = 'Enter  new session name: ' }, function(name)
        if name then
          sessions.write(name)
        end
      end)
    end, { desc = 'Create a new Session' })

    vim.keymap.set('n', '<leader>wl', function()
      sessions.select 'read'
    end, { desc = 'Load a Session' })

    vim.keymap.set('n', '<leader>ws', function()
      sessions.write()
    end, { desc = 'Save a Session' })

    -- setup starter
    local status, starter = pcall(require, 'mini.starter')
    if not status then
      return
    end
    starter.setup {
      evaluate_single = true,
      items = {
        starter.sections.recent_files(3, true),
        starter.sections.sessions(3, true),
        starter.sections.telescope(),
      },
      content_hooks = {
        starter.gen_hook.adding_bullet(),
        starter.gen_hook.padding(3, 2),
      },
      footer = os.date(),
      header = table.concat({
        [[                                           ,o88888 ]],
        [[                                        ,o8888888' ]],
        [[                  ,:o:o:oooo.        ,8O88Pd8888"  ]],
        [[              ,.::.::o:ooooOoOoO. ,oO8O8Pd888'"    ]],
        [[            ,.:.::o:ooOoOoOO8O8OOo.8OOPd8O8O"      ]],
        [[           , ..:.::o:ooOoOOOO8OOOOo.FdO8O8"        ]],
        [[          , ..:.::o:ooOoOO8O888O8O,COCOO"          ]],
        [[         , . ..:.::o:ooOoOOOO8OOOOCOCO"            ]],
        [[          . ..:.::o:ooOoOoOO8O8OCCCC"o             ]],
        [[             . ..:.::o:ooooOoCoCCC"o:o             ]],
        [[             . ..:.::o:o:,cooooCo"oo:o:            ]],
        [[          `   . . ..:.:cocoooo"'o:o:::'            ]],
        [[          .`   . ..::ccccoc"'o:o:o:::'             ]],
        [[         :.:.    ,c:cccc"':.:.:.:.:.'              ]],
        [[       ..:.:"'`::::c:"'..:.:.:.:.:.'               ]],
        [[     ...:.'.:.::::"'    . . . . .'                 ]],
        [[    .. . ....:."' `   .  . . ''                    ]],
        [[  . . . ...."'                                     ]],
        [[  .. . ."'                                         ]],
      }, '\n'),
    }
    -- ... and there is more!
    --  Check out: https://github.com/echasnovski/mini.nvim
  end,
}
