$ports = @(7890, 7897, 10809, 1080)

$proxy = $null

foreach ($port in $ports) {
    $client = [System.Net.Sockets.TcpClient]::new()
    try {
        $task = $client.ConnectAsync("127.0.0.1", $port)
        if ($task.Wait(500) -and $client.Connected) {
            $proxy = "http://127.0.0.1:$port"
            break
        }
    } catch {
    } finally {
        $client.Dispose()
    }
}

if (-not $proxy) {
    Write-Host "No proxy port found." -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit
}

$env:HTTP_PROXY = $proxy
$env:HTTPS_PROXY = $proxy
$env:NO_PROXY = "localhost,127.0.0.1,::1"

$pkg = Get-AppxPackage -Name "OpenAI.Codex" |
    Sort-Object Version -Descending |
    Select-Object -First 1

if (-not $pkg) {
    Write-Host "ChatGPT installation not found." -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit
}

$exe = Join-Path $pkg.InstallLocation "app\ChatGPT.exe"

if (-not (Test-Path -LiteralPath $exe)) {
    Write-Host "ChatGPT executable not found." -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit
}

Write-Host "Starting ChatGPT with proxy $proxy"
& $exe
