# ChatGPT Proxy Launcher (Windows)

[简体中文](README.md)

A small PowerShell launcher that sets a **local HTTP proxy** for the **ChatGPT Windows desktop app** process. It may help troubleshoot Codex Remote Control pairing timeouts.

> **Unofficial project.** This is neither a VPN nor a general fix for Remote Control. The script was reported working on one Windows 11 setup; behavior can vary across app versions, proxy tools and networks.

## Requirements

- Windows 11 with Windows PowerShell 5.1 or newer.
- The ChatGPT Windows app installed as the `OpenAI.Codex` MSIX package, containing `app\ChatGPT.exe`.
- A running local **HTTP proxy**, e.g. Clash for Windows. Tested script checks ports `7890`, `7897`, `10809`, and `1080`.
- A network route that can reach the required service.

## Usage

1. Download and extract the repository ZIP (or clone it).
2. Start the proxy app and ensure its HTTP or mixed proxy port is listening.
3. **Fully exit** any existing ChatGPT desktop processes.
4. Double-click `Launch-ChatGPT.cmd`, or run `powershell.exe -NoProfile -ExecutionPolicy Bypass -File "<actual path>\Start-ChatGPT.ps1"` in PowerShell.
5. In the app, try `Settings → Connections → Control this PC` again.

To create a desktop shortcut, make a shortcut to `Launch-ChatGPT.cmd`. Keep the `.cmd` and `.ps1` files together.

## How it works

The script checks a short list of local TCP ports, selects the first responsive port, sets `HTTP_PROXY`, `HTTPS_PROXY`, and `NO_PROXY` in the launching process, locates the `OpenAI.Codex` MSIX package, then launches `app\ChatGPT.exe`. It does **not** modify permanent system proxy settings or send data anywhere.

## Limitations

- **An open TCP port is not proof of a working HTTP proxy.** The script does not validate the actual protocol, authentication or connectivity. A SOCKS5-only port is not necessarily usable with an `http://` proxy URL.
- Changing remote proxy nodes normally requires no script edits. Changing the local proxy port, protocol or application may require updating `$ports` or the proxy URL.
- Proxy variable inheritance and direct MSIX executable startup may vary across versions and subprocesses.
- Pairing timeouts may originate in the app or remote service rather than the proxy.
- `-ExecutionPolicy Bypass` is limited to the invoked PowerShell process. Review scripts before running them.

## Troubleshooting

| Symptom | What to check |
| --- | --- |
| `No proxy port found.` | Proxy app running? HTTP/mixed port within the configured list? |
| `ChatGPT installation not found.` | Is the `OpenAI.Codex` MSIX app installed? Has its package identity changed? |
| `ChatGPT executable not found.` | The app's internal file layout may have changed. |
| App launches but remote pairing times out | Fully exit older processes, verify HTTP proxy type, then check network/app/service behavior. |
| `.ps1` opens in an editor | Use `Launch-ChatGPT.cmd` instead. |

## Privacy & security

No subscription URLs, credentials, tokens, user-specific paths or usernames are included. No elevated privileges are required. Use at your own risk and review the script before running it.

## License

[MIT](LICENSE). ChatGPT and Codex are trademarks of their respective owners. Not affiliated with OpenAI.
