function print_message ($msg) {
  Write-Host $msg -ForegroundColor "Green"
}

function print_error ($msg) {
  Write-Host $msg -ForegroundColor "Red"
}

function has_command ($command) {
  Get-command -Name $command  -ErrorAction "silentlycontinue"
}

Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser


$scoop_main_package_list = @(
  "bat",
  "clangd",
  "cmake",
  "curl",
  "delta",
  "fd",
  "fzf",
  "gcc",
  "git",
  "glslviewer",
  "go",
  "gzip",
  "jq",
  "llvm",
  "lua",
  "luarocks",
  "make",
  "msys2",
  "neovim",
  "ninja",
  "nodejs-lts",
  "oh-my-posh",
  "python",
  "ripgrep",
  "rust-analyzer",
  "rustup",
  "sudo",
  "tokei",
  "tree-sitter",
  "unzip",
  "uutils-coreutils",
  "vim",
  "wget",
  "zoxide"
)
$scoop_extras_package_list = @(
  "lazygit",
  "posh-git",
  "psfzf",
  "terminal-icons"
)

if (!(has_command scoop)) {
  print_message("Installing scoop...")
  # Command to install scoop
  irm get.scoop.sh | iex
}
scoop update

scoop bucket add extras
scoop bucket add versions  # glslviewer requires
scoop bucket add nerd-fonts

foreach ($package in $scoop_main_package_list) {
  scoop install $package
}
foreach ($package in $scoop_extras_package_list) {
  scoop install $package
}
scoop install Hack-NF-Mono

.\symbolic.ps1

# setup Winget
$winget_app_list = @{
  "3D Viewer"                 = "9NBLGGH42THS"
  "7zip"                      = "7zip.7zip"
  "Adobe Creative Cloud"      = "XPDLPKWG9SW2WD"
  "AutoHotkey"                = "AutoHotkey.AutoHotkey"
  "DeepL"                     = "XPDNX7G06BLH2G"
  "Everything"                = "voidtools.Everything"
  "EverythingToolbar"         = "stnkl.EverythingToolbar"
  "Flow Launcher"             = "Flow-Launcher.Flow-Launcher"
  "Google Chrome"             = "Google.Chrome"
  "PowerToys"                 = "Microsoft.PowerToys"
  "QuickLook"                 = "QL-Win.QuickLook"
  "VLC"                       = "XPDM1ZW6815MQM"
  "Visual Studio Build Tools" = "Microsoft.VisualStudio.2022.BuildTools" # rustに必要
  "Visual Studio Code"        = "Microsoft.VisualStudioCode"
  "Windows Terminal"          = "Microsoft.WindowsTerminal"
  "iCloud"                    = "9PKTQ5699M62"
}

if (!(has_command winget)) {
  print_error("Error: `"winget`" is not found.")
} else {
  foreach ($app in $winget_app_list.GetEnumerator()) {
    print_message("Installing $($app.Key)...")
    winget install $app.Value
  }
  winget upgrade
}

Write-Output ". `$env:USERPROFILE\.config\powershell\user_profile.ps1" > $PROFILE
