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

-   [Scoop completion in PSCompletions ](https://github.com/abgox/PSCompletions "PSCompletions")is recommended.

### For ones familiar with Scoop

1.  `scoop bucket add abgo_bucket https://github.com/abgox/abgo_bucket`

    -   The `abgo_bucket` here is the name of the bucket added locally, you can name it freely.

2.  Install apps.

    -   `scoop install [abgo_bucket/]<app_name>`

    -   Use an external browser to download app:

        ```powershell
        <your_scoop_path>\bucket\abgo_bucket\bin\download.ps1 <app_name> [-isUpdate]
        ```

-   List all installable apps in `abgo_bucket`:

    ```powershell
    <your_scoop_path>\bucket\abgo_bucket\bin\list_all_app.ps1
    ```

---

### Never used Scoop

-   [What is Scoop?](https://github.com/ScoopInstaller/Scoop)
-   [What is bucket in Scoop?](https://github.com/ScoopInstaller/Scoop/wiki/Buckets)
-   [What is App-Manifests in Scoop?](https://github.com/ScoopInstaller/Scoop/wiki/App-Manifests)
-   [Scoop install](https://github.com/ScoopInstaller/Install)
-   [Scoop Document](https://github.com/ScoopInstaller/Scoop/wiki)

---

### Why create this `bucket`

1. When using official or third-party `buckets`, there may be the following issues.

    - Some apps doesn't `persist` data.
        - They don't include apps that do not necessarily `persist` data.
    - After uninstalling app, local data was not cleaned up. (e.g. the app's data under `$env:AppData`,`$env:LocalAppData` or other directory.)
    - When uninstalling app, there's a problem where the process is occupied and cannot be uninstalled.
    - ...

2. Organize my commonly used apps.

---

### About `persist`

-   The apps in this `bucket` will use the built-in `persist` in `Scoop`, and will also implement `persist` through file linking.
-   The strategy is **radical**. If there is a data directory, the app will `persist` the entire data directory instead of some important configuration files.
-   Take `Neovim` as an example.It will form two directories under `$env: LocalAppData`, `nvim` and `nvim-data`, and both directories will be persisted.
    -   The advantage of it is that the software has a smooth and seamless user experience after reinstallation, but it may take up more storage space.

#### ⚠︎ About `persist` directory changes ⚠︎

-   On **January 15, 2024**, there're some changes in the `persist` of some apps. [Click to view this commit.](https://github.com/abgox/abgo_bucket/commit/3b65bc2fe6f836028e0b7bde9bce4de586550eb9)
-   List: `Final2x`,`GeekUninstaller`,`Helix`,`LX-Music`,`Listary`,`MarkText`,`Motrix`,`MusicPlayer2`,`ngrok`,`Oh-My-Posh`,`Quicker`,`Rubick`,`RustDesk`,`ScreenToGif`,`Sigma-File-Manager`,`TrafficMonitor`,`tts-vue`,`Typora`,`XBYDriver`
    -   Taking `GeekUninstaller` as an example:
        -   Before: `<your_scoop_path>\persist\geekuninstaller`
        -   After: `<your_scoop_path>\persist\geekuninstaller\Geek Uninstaller`

---

### App Manifests

-   All app Manifests are supported by default:

    -   **`Clear Data`** : When the software is uninstalled, delete data of the software if it exists.(Except for `persist` data).
    -   **`Forced uninstall`** : When the software is running, using the `scoop uninstall <app_name>` will try to terminate the process before uninstalling, to avoid the problem that the software is in use and cannot be uninstalled.

-   Guide

    -   **`App`** : Click to view to the official website or repository. Sort by first letter(0-9,a-z).
    -   **`Persist`** : Important data of software is saved to `persist` under the installation directory of "Scoop".
        -   **✔️** : It has been done.
        -   **❌** : It hasn't been done yet.
        -   **➖** : It's not necessary, or the conditions are not meet.(e.g. data file not found)
    -   **`Note`**
        -   `run` : Run the application once after installing.
        -   `UWP` : A `UWP` app. The app's program files are not within `Scoop`. `Scoop` only manages the persistence of data and operations for installing, updating, and uninstalling.
        -   `noAutoUpdate` : `json.autoupdate` are not configured, and Scoop cannot automatically detect updates.
        -   `invalid` : Invalid app placed in the deprecated folder. It may be removed from the list in the future.

---

|                                     App                                     | persist | Note         |
| :-------------------------------------------------------------------------: | :-----: | ------------ |
|                          [7zip](https://7-zip.org)                          |   ➖    |              |
|                        [aardio](https://aardio.com)                         |   ✔️    |              |
|                        [AFFINE](https://affine.pro)                         |   ✔️    |              |
|                    [AutoHotkey](https://autohotkey.com)                     |   ✔️    |              |
|                        [chfs](http://iscute.cn/chfs)                        |   ✔️    |              |
| [ContextMenuManager](https://github.com/BluePointLilac/ContextMenuManager)  |   ✔️    |              |
|                       [DevToys](https://devtoys.app)                        |   ✔️    | UWP          |
|                  [Ditto](https://ditto-cp.sourceforge.io)                   |   ✔️    |              |
|               [Dnest](https://github.com/davidkane0526/Dnest)               |   ➖    |              |
|               [DownKyi](https://leiurayer.github.io/downkyi)                |   ✔️    |              |
|                     [draw.io](https://www.diagrams.net)                     |   ✔️    |              |
|                   [Dropit](http://www.dropitproject.com)                    |   ✔️    |              |
|                   [Everything](https://www.voidtools.com)                   |   ✔️    |              |
|                    [Final2x](https://final2x.tohru.top)                     |   ✔️    |              |
|                  [Fluent-Search](https://fluentsearch.net)                  |   ✔️    | noAutoUpdate |
|                    [fnm](https://github.com/Schniz/fnm)                     |   ➖    |              |
|           [FastGithub](https://github.com/dotnetcore/FastGithub)            |   ➖    |              |
|               [GeekUninstaller](https://geekuninstaller.com)                |   ✔️    |              |
|              [GitExtensions](https://gitextensions.github.io)               |   ✔️    |              |
|                        [Gopeed](https://gopeed.com)                         |   ✔️    |              |
|                           [He3](https://he3.app)                            |   ✔️    |              |
|                      [Helix](https://helix-editor.com)                      |   ✔️    |              |
|                    [ImageGlass](https://imageglass.org)                     |   ✔️    |              |
|                [InputTip](https://github.com/abgox/InputTip)                |   ✔️    |              |
|                      [Insomnia](https://insomnia.rest)                      |   ✔️    |              |
|                            [jan](https://jan.ai)                            |   ✔️    |              |
|                       [Joplin](https://joplinapp.org)                       |   ✔️    |              |
|                [Keyviz](https://mularahul.github.io/keyviz)                 |   ✔️    |              |
|                  [Koodo-Reader](https://koodo.960960.xyz)                   |   ✔️    |              |
|                     [Listary](https://www.listary.com)                      |   ✔️    |              |
|                     [LocalSend](https://localsend.org)                      |   ✔️    |              |
|                    [LX-Music](https://docs.lxmusic.top)                     |   ✔️    |              |
|                     [MarkText](https://www.marktext.cc)                     |   ✔️    |              |
|                      [Monit](https://monit.fzf404.art)                      |   ✔️    |              |
|                        [Motrix](https://motrix.app)                         |   ✔️    |              |
|        [MusicPlayer2](https://github.com/zhongyang219/MusicPlayer2)         |   ✔️    |              |
|                         [Neovim](https://neovim.io)                         |   ✔️    |              |
|                         [ngrok](https://ngrok.com)                          |   ✔️    |              |
|                   [Notepads](https://www.notepadsapp.com)                   |   ✔️    | UWP          |
|            [nvm-desktop](https://github.com/1111mp/nvm-desktop)             |   ✔️    |              |
|                       [Obsidian](https://obsidian.md)                       |   ✔️    |              |
|                     [Oh-My-Posh](https://ohmyposh.dev)                      |   ✔️    |              |
|                     [PeaZip](https://peazip.github.io)                      |   ✔️    |              |
|                       [PixPin](https://pixpinapp.com)                       |   ✔️    |              |
|                         [pot](https://pot-app.com)                          |   ✔️    |              |
|                   [PotPlayer](https://potplayer.daum.net)                   |   ✔️    |              |
|             [pyenv-win](https://github.com/pyenv-win/pyenv-win)             |   ✔️    |              |
|              [QtScrcpy](https://github.com/barry-ran/QtScrcpy)              |   ✔️    |              |
|                      [Quicker](https://getquicker.net)                      |   ✔️    |              |
|              [Rubick](https://github.com/rubickCenter/rubick)               |   ✔️    |              |
|           [RunCat](https://github.com/Kyome22/RunCat_for_windows)           |   ➖    |              |
|              [RustDesk](https://github.com/rustdesk/rustdesk)               |   ✔️    |              |
|                [Screego](https://github.com/screego/server)                 |   ✔️    |              |
|         [ScreenToGif](https://github.com/NickeManarin/ScreenToGif)          |   ✔️    |              |
| [Sigma-File-Manager](https://github.com/aleksey-hoffman/sigma-file-manager) |   ✔️    |              |
|                     [SiYuan](https://b3log.org/siyuan)                      |   ✔️    |              |
|                    [Snipaste](https://www.snipaste.com)                     |   ✔️    |              |
|                    [Snipaste2](https://www.snipaste.com)                    |   ✔️    |              |
|                  [Spacedrive](https://www.spacedrive.com)                   |   ✔️    |              |
|                [Steampp(Watt Toolkit)](https://steampp.net)                 |   ✔️    |              |
|                [SwitchHosts](https://switchhosts.vercel.app)                |   ✔️    |              |
|      [TrafficMonitor](https://github.com/zhongyang219/TrafficMonitor)       |   ✔️    |              |
|       [TranslucentTB](https://github.com/TranslucentTB/TranslucentTB)       |   ✔️    | UWP          |
|                   [TTime](https://ttime.timerecord.cn/en)                   |   ✔️    |              |
|                [tts-vue](https://github.com/LokerL/tts-vue)                 |   ✔️    |              |
|                         [Typora](https://typora.io)                         |   ✔️    |              |
|                [Upscayl](https://github.com/upscayl/upscayl)                |   ✔️    |              |
|                          [uTools](https://u.tools)                          |   ✔️    |              |
|                   [VSCode](https://code.visualstudio.com)                   |   ✔️    |              |
|               [Widgets](https://github.com/widget-js/widgets)               |   ✔️    | noAutoUpdate |
|               [WonderPen](https://www.tominlab.com/wonderpen)               |   ✔️    |              |
|            [XBYDriver](https://github.com/gaozhangmin/aliyunpan)            |   ✔️    |              |
|               [XYplorer](https://www.xyplorer.com/index.php)                |   ✔️    |              |
|              [XYplorerFree](https://www.xyplorer.com/free.php)              |   ✔️    |              |
