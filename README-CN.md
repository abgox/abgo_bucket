<p align="center">
    <h1 align="center">✨ abgo_bucket ✨</h1>
</p>

<p align="center">
    <a href="README.md">English</a> |
    <a href="README-CN.md">简体中文</a> |
    <a href="https://github.com/abgox/abgo_bucket">Github</a> |
    <a href="https://gitee.com/abgox/abgo_bucket">Gitee</a>
</p>

<p align="center">
    <a href="https://github.com/abgox/abgo_bucket/blob/main/LICENSE">
        <img src="https://img.shields.io/github/license/abgox/abgo_bucket" alt="license" />
    </a>
    <a href="https://img.shields.io/github/languages/code-size/abgox/abgo_bucket.svg">
        <img src="https://img.shields.io/github/languages/code-size/abgox/abgo_bucket.svg" alt="code size" />
    </a>
    <a href="https://img.shields.io/github/repo-size/abgox/abgo_bucket.svg">
        <img src="https://img.shields.io/github/repo-size/abgox/abgo_bucket.svg" alt="code size" />
    </a>
    <a href="https://github.com/abgox/abgo_bucket">
        <img src="https://img.shields.io/badge/created-2023--6--1-blue" alt="created" />
    </a>
</p>

-   推荐使用 [PSCompletions 项目中的 scoop 补全 ](https://gitee.com/abgox/PSCompletions "PSCompletions")

### 正在使用 Scoop :

-   `scoop bucket add abgo_bucket https://gitee.com/abgox/abgo_bucket`

    -   此处的 `abgo_bucket` 为添加到本地的桶名称，可自由命名

-   列出 `abgo_bucket` 中所有可安装的应用

    ```powershell
        <your_scoop_path>\bucket\abgo_bucket\bin\list_all_app.ps1
    ```

-   使用外部浏览器下载应用

    ```powershell
        <your_scoop_path>\bucket\abgo_bucket\bin\download.ps1 <app_name> [-isUpdate]
    ```

### 没有使用过 Scoop :

-   [什么是 Scoop?](https://github.com/ScoopInstaller/Scoop)
-   [什么是 Scoop 中的 bucket?](https://github.com/ScoopInstaller/Scoop)
-   [什么是 Scoop 中的应用清单(App-Manifests)?](https://github.com/ScoopInstaller/Scoop/wiki/App-Manifests)
-   [安装 Scoop](https://github.com/ScoopInstaller/Install)
-   [Scoop 文档](https://github.com/ScoopInstaller/Scoop/wiki)

---

### 为什么创建此 `bucket` ？

1. 在使用官方或第三方 `bucket` 时，可能存在以下问题

    - 一些软件并没有进行`persist`
        - 没有必要持久化数据的软件除外
    - 软件卸载后,本地数据没有得到及时清理(如 `$env:AppData`、`$env:LocalAppData` 或其他目录下的软件数据)
    - 软件卸载时，存在进程占用无法卸载问题
    - ...

2. 主要用于整理我的常用应用

---

### 应用清单

-   说明
    -   应用：按照数字字母排序(0-9,a-z)
    -   persist: 软件重要数据保存到 `Scoop` 安装目录下的 `persist` 中
    -   数据清理：当软件卸载后，如果存在软件残留数据则删除(`persist` 数据除外)
    -   强制卸载：当软件正在运行时，使用 `scoop uninstall <app_name>` 会先终止进程，再进行卸载，避免卸载时出现软件正在使用，无法卸载的问题
    -   **√**：已实现
        -   对于`数据清理`, 卸载后不存在残留数据，就视为已完成
    -   **x**：未实现
    -   **/**：没必要或不满足条件
    -   **\*run**: 安装后会立即运行一次
    -   **invalid**: 无效应用，已放入 deprecated(废弃) 文件夹中，未来可能从清单中移除

|                                    应用                                     | persist | 数据清理 | 强制卸载 | 备注        |
| :-------------------------------------------------------------------------: | :-----: | :------: | :------: | ----------- |
|                          [7zip](https://7-zip.org)                          |    /    |    √     |    √     |             |
|                        [aardio](https://aardio.com)                         |    √    |    √     |    √     |             |
|                    [AutoHotkey](https://autohotkey.com)                     |    √    |    √     |    √     |             |
|                        [chfs](http://iscute.cn/chfs)                        |    √    |    √     |    √     |             |
|               [DownKyi](https://leiurayer.github.io/downkyi)                |    √    |    √     |    √     |             |
|                   [Everything](https://www.voidtools.com)                   |    √    |    √     |    √     |             |
|                    [Final2x](https://final2x.tohru.top)                     |    √    |    √     |    √     |             |
|                    [fnm](https://github.com/Schniz/fnm)                     |    /    |    √     |    √     |             |
|           [FastGithub](https://github.com/dotnetcore/FastGithub)            |    /    |    √     |    √     | **invalid** |
|               [Geek Uninstaller](https://geekuninstaller.com)               |    √    |    √     |    √     |             |
|                      [Helix](https://helix-editor.com)                      |    √    |    √     |    √     |             |
|                [Keyviz](https://mularahul.github.io/keyviz)                 |    √    |    √     |    √     |             |
|                     [Listary](https://www.listary.com)                      |    √    |    √     |    √     |             |
|                     [LocalSend](https://localsend.org)                      |    √    |    √     |    √     |             |
|                    [LX-Music](https://docs.lxmusic.top)                     |    √    |    √     |    √     |             |
|                     [MarkText](https://www.marktext.cc)                     |    √    |    √     |    √     |             |
|                        [Motrix](https://motrix.app)                         |    √    |    √     |    √     |             |
|        [MusicPlayer2](https://github.com/zhongyang219/MusicPlayer2)         |    √    |    √     |    √     |             |
|                         [Neovim](https://neovim.io)                         |    √    |    √     |    √     |             |
|                         [ngrok](https://ngrok.com)                          |    √    |    √     |    √     |             |
|                     [Oh-My-Posh](https://ohmyposh.dev)                      |    √    |    √     |    √     |             |
|                       [PixPin](https://pixpinapp.com)                       |    √    |    √     |    √     |             |
|                   [PotPlayer](https://potplayer.daum.net)                   |    √    |    √     |    √     |             |
|             [pyenv-win](https://github.com/pyenv-win/pyenv-win)             |    √    |    √     |    √     |             |
|                      [Quicker](https://getquicker.net)                      |    √    |    √     |    √     |             |
|              [Rubick](https://github.com/rubickCenter/rubick)               |    √    |    √     |    √     |             |
|              [RustDesk](https://github.com/rustdesk/rustdesk)               |    √    |    √     |    √     |             |
| [Sigma-File-Manager](https://github.com/aleksey-hoffman/sigma-file-manager) |    √    |    √     |    √     |             |
|                    [Snipaste](https://www.snipaste.com)                     |    √    |    √     |    √     |             |
|                    [Snipaste2](https://www.snipaste.com)                    |    √    |    √     |    √     |             |
|                [Steampp(Watt Toolkit)](https://steampp.net)                 |    √    |    √     |    √     |             |
|      [TrafficMonitor](https://github.com/zhongyang219/TrafficMonitor)       |    √    |    √     |    √     |             |
|                [tts-vue](https://github.com/LokerL/tts-vue)                 |    √    |    √     |    √     |             |
|                         [Typora](https://typora.io)                         |    √    |    √     |    √     |             |
|            [XBYDriver](https://github.com/gaozhangmin/aliyunpan)            |    √    |    √     |    √     |             |
