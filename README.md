# ChatGPT Proxy Launcher (Windows)

[English](README_EN.md)

一个轻量级 PowerShell 启动脚本：在 **Windows** 上为 ChatGPT 桌面应用进程指定本地 HTTP 代理环境变量，用于排查 **Codex Remote Control** 配对码获取超时等问题。

> **非 OpenAI 官方项目。** 这不是 VPN 或远程桌面软件，也不是 Codex Remote Control 的通用修复方案。这里只记录在一台 Windows 11 电脑上实际成功的解决方法；其他版本、代理软件、网络环境可能有所不同。

## 适用条件

- Windows 11、PowerShell 5.1 或更高版本。
- 已安装 **ChatGPT Windows 桌面应用**，并且其 MSIX 包名为 `OpenAI.Codex`，入口位于 `app\ChatGPT.exe`。
- 已运行提供 **HTTP 代理** 的本地代理软件，例如 Clash for Windows。默认检测的端口：`7890`、`7897`、`10809`、`1080`。
- 代理线路本身能够正常访问所需服务。

## 使用

1. 下载仓库 ZIP 并解压到任意文件夹，或克隆仓库。
2. 打开代理软件，确认本地 **HTTP 或 mixed-port** 监听已开启。
3. **完全退出**已经运行的 ChatGPT 桌面应用，避免复用没有指定代理的旧进程。
4. 双击 `Launch-ChatGPT.cmd`；或在 PowerShell 中运行 `powershell.exe -NoProfile -ExecutionPolicy Bypass -File "<实际路径>\Start-ChatGPT.ps1"`。
5. ChatGPT 打开后，进入 `Settings → Connections → Control this PC`，尝试远程配对。

创建桌面快捷方式：右键 `Launch-ChatGPT.cmd` → 显示更多选项 → 发送到 → 桌面快捷方式。**不要只移动 `.cmd` 文件**，它需要和 `.ps1` 文件放在同一目录。

## 它做了什么

- 依次检查 `127.0.0.1` 上的常见代理端口是否接受 TCP 连接；
- 在**当前脚本启动的进程环境**内设置 `HTTP_PROXY`、`HTTPS_PROXY` 和 `NO_PROXY`；
- 查询安装的 `OpenAI.Codex` 应用包，在其中定位 `app\ChatGPT.exe` 并启动。

不修改系统级永久环境变量，不要求管理员权限，不修改 Clash 配置，不上传任何信息。

## 重要限制

- **端口监听 ≠ HTTP 代理可用。** 当前已验证版本只做 TCP 检测，且直接采用找到的第一个端口；它不会验证服务类型、认证要求、代理出口，也无法保证每个端口都是 HTTP 代理。仅有 SOCKS5 的端口不能直接套用 `http://`。
- 更换代理节点一般不用修改脚本；**更换代理软件、监听端口、代理协议**可能需要调整 `$ports` 或代理 URL。
- 代理配置能否被应用及其所有子进程采用，取决于具体客户端版本。直接运行 MSIX 内部可执行文件也不保证对其他版本有效。
- 如果仍出现 `Timed out waiting for remote control to connect`，原因也可能是客户端、服务、账号或其他网络问题。
- `-ExecutionPolicy Bypass` 只应用于此次 PowerShell 进程；它并非长期变更系统执行策略。仅运行你自己审核、信任的脚本。

## 故障排查

| 现象 | 检查方向 |
| --- | --- |
| `No proxy port found.` | 代理软件是否正在运行；HTTP/mixed-port 是否属于预设端口。 |
| `ChatGPT installation not found.` | 是否安装了符合条件的 Windows MSIX 版本；包名是否变化。 |
| `ChatGPT executable not found.` | 安装包内部的可执行文件路径可能已经变化。 |
| 可以打开 ChatGPT，但 Remote Control 仍超时 | 确保旧进程已完全退出；确认选中的是 HTTP 代理端口；检查线路与客户端服务状态。 |
| 双击脚本出现文本编辑器 | 请使用 `Launch-ChatGPT.cmd`，不要依赖 `.ps1` 的文件关联。 |

## 安全与隐私

项目只包含脚本和文档；**不包含**真实订阅地址、代理节点、认证信息、账户令牌、个人 Windows 用户名和固定个人路径。使用前请自行审核脚本。不会对远程连接安全性、可用性作任何保证。

## 许可证

[MIT License](LICENSE)。`ChatGPT`、`Codex` 等名称归其各自权利人所有；本项目与 OpenAI 无官方关联。
