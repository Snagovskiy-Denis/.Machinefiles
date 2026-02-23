local home = vim.loop.fs_realpath(os.getenv 'ZETTELKASTEN')

require('telekasten').setup {
    home = home,

    -- dailies = home .. '../Journal',
    -- weeklies = home .. '../Journal',
    -- templates = home .. '../Templates',
    dailies = home .. '/Journal',
    weeklies = home .. '/Journal',
    templates = home .. '/Templates',
    image_subdir = home .. '/Files',

    weeklies_create_nonexisting = false,

    -- template_new_note = home .. '../Templates/Mine Моё.md',
    -- template_new_daily = home .. '../Templates/Daily.md',
    template_new_note = home .. '/Templates/Mine Моё.md',
    template_new_daily = home .. '/Templates/Daily.md',

    -- subdirs_in_links = false,  -- проблемы с переименованием заметок при включении

    plug_into_calendar = false,
}
