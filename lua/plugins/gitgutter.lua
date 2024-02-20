return {
    'airblade/vim-gitgutter',
    cond = function()
        local git_dir = vim.fn.finddir(".git")
        return git_dir ~= ""
    end
}
