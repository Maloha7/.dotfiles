local dap = require("dap")

dap.adapters.coreclr = {
    type = "executable",
    command = "/home/maloha/.nix-profile/bin/netcoredbg",
    args = { "--interpreter=vscode" },
}

dap.configurations.cs = {
    {
        type = "coreclr",
        name = "launch - netcoredbg (mine)",
        request = "launch",
        program = function()
            return vim.fn.input("Path to dll", vim.fn.getcwd() .. "/bin/Debug/", "file")
        end,
    },
    {
        type = "coreclr",
        name = "Attach to ASP.NET Core (watch mode)",
        request = "attach",
        processId = require("dap.utils").pick_process,
    },
}
