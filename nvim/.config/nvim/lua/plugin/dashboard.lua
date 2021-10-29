vim.g.dashboard_default_executive = 'telescope'

vim.g.dashboard_custom_header = {
   ' ███████████████████████████ ',
   ' ███████▀▀▀░░░░░░░▀▀▀███████ ',
   ' ████▀░░░░░░░░░░░░░░░░░▀████ ',
   ' ███│░░░░░░░░░░░░░░░░░░░│███ ',
   ' ██▌│░░░░░░░░░░░░░░░░░░░│▐██ ',
   ' ██░└┐░░░░░░░░░░░░░░░░░┌┘░██ ',
   ' ██░░└┐░░░░░░░░░░░░░░░┌┘░░██ ',
   ' ██░░┌┘▄▄▄▄▄░░░░░▄▄▄▄▄└┐░░██ ',
   ' ██▌░│██████▌░░░▐██████│░▐██ ',
   ' ███░│▐███▀▀░░▄░░▀▀███▌│░███ ',
   ' ██▀─┘░░░░░░░▐█▌░░░░░░░└─▀██ ',
   ' ██▄░░░▄▄▄▓░░▀█▀░░▓▄▄▄░░░▄██ ',
   ' ████▄─┘██▌░░░░░░░▐██└─▄████ ',
   ' █████░░▐█─┬┬┬┬┬┬┬─█▌░░█████ ',
   ' ████▌░░░▀┬┼┼┼┼┼┼┼┬▀░░░▐████ ',
   ' █████▄░░░└┴┴┴┴┴┴┴┘░░░▄█████ ',
   ' ███████▄░░░░░░░░░░░▄███████ ',
   ' ██████████▄▄▄▄▄▄▄██████████ ',
}

vim.g.dashboard_custom_section = {
    a = {
        description = { '  Find File          ' },
        command = 'Telescope find_files',
    },
    b = {
        description = { '  Recent Projects    ' },
        command = 'Telescope projects',
    },
    c = {
        description = { '  Recently Used Files' },
        command = 'Telescope oldfiles',
    },
    d = {
		description = { '洛 New File           ' },
		command = 'enew',
	},
    e = {
        description = { '  .vimrc             ' },
        command = ':edit $MYVIMRC | cd %:p:h',
    },
}

vim.g.dashboard_custom_footer = { '[self@machine]' }
