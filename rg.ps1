# Dot-source this file in your PowerShell profile to wrap ripgrep with
# GNU grep -E (--extended-regexp) compatibility:
#
#   . /path/to/rg.ps1
#
# GNU grep -E enables extended regular expressions. ripgrep uses an
# equivalent regex syntax by default, so this wrapper strips -E and
# --extended-regexp from the argument list before forwarding to rg.
#
# If you need ripgrep's native -E (--encoding) flag, use --encoding.

function rg {
    $rgExe = (Get-Command rg -CommandType Application |
        Select-Object -First 1).Source
    $filtered = @()
    foreach ($a in $args) {
        if ($a -eq '-E' -or $a -eq '--extended-regexp') {
            continue
        }
        $filtered += $a
    }
    & $rgExe @filtered
}
