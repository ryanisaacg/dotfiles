Import-Module PSReadLine
Set-PSReadLineOption -EditMode Emacs

function Title {
    Param ([string]$title)
    $host.ui.RawUI.WindowTitle = $title
}

function Link {
    Param ([string]$path, [string]$name, [string]$value)
    new-item -itemtype symboliclink -path $path -name $name -value $value
}

Set-Alias g git
Set-Alias which get-command
Set-Alias e nvim-qt

Invoke-Expression (&starship init powershell)
