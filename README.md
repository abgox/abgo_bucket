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

-   [Scoop completion in PSCompletions ](https://github.com/abgox/PSCompletions 'PSCompletions')is recommended.

### For ones familiar with Scoop

1.  `scoop bucket add abgo_bucket https://github.com/abgox/abgo_bucket`

    -   The `abgo_bucket` here is the name of the bucket added locally, you can name it freely.

2.  Install apps.

    -   `scoop install [abgo_bucket/]<app_name>`

    -   Use an external way to download/update app:
        -   It's good choice to use it when downloads the app in the command line are slow and you have better ways to download the app by the download link.
        ```powershell
            <your_scoop_path>\bucket\abgo_bucket\bin\download.ps1 [bucket/]<app_name>
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

### Why create `abgo_bucket`

1. When using official or third-party `buckets`, there may be the following issues.

    - Some apps doesn't `persist` data.(Don't include apps that do not necessarily `persist` data.)
        - `abgo_bucket` uses soft link to persist data, which is not limited to data in app directories, including app data under directories such as `$env:AppData` and `$env:LocalAppData`.
    - After uninstalling app, local data was not cleaned up. (e.g. the app's data under `$env:AppData`,`$env:LocalAppData` or other directory.)
        - When the app in `abgo_bucket` is uninstalled, all related app data will be deleted, and only the data in the `persist` directory will be retained.
        - If you use the `-p/--purge` parameter when uninstalling, the data in the `persist` directory will also be deleted.
    - When uninstalling app, there's a problem where the process is occupied and cannot be uninstalled.
        - When the app in `abgo_bucket` is running, using the `scoop uninstall <app_name>` will try to terminate the process before uninstalling, to avoid the problem that the software is in use and cannot be uninstalled.
    - App installation is limited to unpacking and obtaining the app directory. Some files/libraries/registries may be missing.
        - When the app in `abgo_bucket` is installing, If the exe installation can be run, it will be run silently to ensure the integrity of the app directory after installing.
        - When it's uninstalling, the built-in uninstaller of the app will be used first to uninstall.
    - ...

2. Organize some commonly used apps with good user experience.

---

### About `persist`

-   The apps in `abgo_bucket` will uses soft link to persist data, which is not limited to data in app directories.
-   The strategy is **radical**. If there is a data directory, the app will `persist` the entire data directory instead of some important configuration files.
-   Take `Neovim` as an example. It will form two directories under `$env:LocalAppData`, `nvim` and `nvim-data`, and both directories will be persisted.

    -   The advantage of it is that the software has a smooth and seamless user experience after reinstalling, but it may take up more storage space.

-   This **radical** `persist` strategy will result in `abgo_bucket` having a different persist file (directory) than other `buckets`.
-   So, if you are migrating from another `bucket` to `abgo_bucket` or from `abgo_bucket` to another repository, please pay attention to the changes in the `persist`.

#### ⚠︎ About `persist` directory changes ⚠︎

-   On **January 15, 2024**, there're some changes in the `persist` of some apps. [Click to view this commit.](https://github.com/abgox/abgo_bucket/commit/3b65bc2fe6f836028e0b7bde9bce4de586550eb9)
-   List: `Final2x`,`GeekUninstaller`,`Helix`,`LX-Music`,`Listary`,`MarkText`,`Motrix`,`MusicPlayer2`,`ngrok`,`Oh-My-Posh`,`Quicker`,`Rubick`,`RustDesk`,`ScreenToGif`,`Sigma-File-Manager`,`TrafficMonitor`,`tts-vue`,`Typora`,`XBYDriver`
    -   Taking `GeekUninstaller` as an example:
        -   Before: `<your_scoop_path>\persist\geekuninstaller`
        -   After: `<your_scoop_path>\persist\geekuninstaller\Geek Uninstaller`

### About Shortcut

-   By default, apps in `abgo_bucket` automatically create desktop shortcuts when installing and updating.
-   You can disable the creation of desktop shortcuts by running the command to add the `Scoop` configuration. `scoop config abgo_bucket_no_shortcut true`

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
    -   **`Tag`**
        -   `run` : Run the app once after installing.
        -   `UWP` : A `UWP` app. The app's program files are not within `Scoop`. `Scoop` only manages the persistence of data and operations for installing, updating, and uninstalling.
        -   `confirm` : The app has a command line(or uninstaller) interactive confirmation when uninstalling.
        -   `noAutoUpdate` : `json.autoupdate` are not configured, and Scoop cannot automatically detect updates.
        -   `invalid` : Invalid app placed in the deprecated folder. It may be removed from the list in the future.
    -   **`Note`**: Some other information.

---

|                                     App                                     | persist |     Tag      |              Note               |
| :-------------------------------------------------------------------------: | :-----: | :----------: | :-----------------------------: |
|              [1History](https://github.com/1History/1History)               |   ➖    |              |                                 |
|                          [7zip](https://7-zip.org)                          |   ➖    |   confirm    |                                 |
|                      [123pan](https://www.123pan.com)                       |   ✔️    |              |            123 云盘             |
|                        [aardio](https://aardio.com)                         |   ✔️    |              |                                 |
|                    [AdsPower](https://www.adspower.net)                     |   ✔️    |              |           指纹浏览器            |
|                        [AFFINE](https://affine.pro)                         |   ✔️    |              |                                 |
|                    [aliyunDrive](https://www.alipan.com)                    |   ✔️    |              |            阿里云盘             |
|                        [Apifox](https://apifox.com)                         |   ✔️    |              |                                 |
|                     [AppFlowy](https://www.appflowy.io)                     |   ✔️    |              |                                 |
|                    [AutoHotkey](https://autohotkey.com)                     |   ✔️    |              |                                 |
|               [BaiduNetdisk](https://pan.baidu.com/download)                |   ✔️    |              |            百度网盘             |
|                  [BaiduTranslate](https://fanyi.baidu.com)                  |   ✔️    |              |            百度翻译             |
|                    [Bilibili](https://app.bilibili.com)                     |   ✔️    |              |            哔哩哔哩             |
|        [BitMeterOS](https://codebox.net/pages/bitmeteros-downloads)         |   ➖    |              |                                 |
|                      [Bruno](https://www.usebruno.com)                      |   ✔️    |              |                                 |
|                       [Carnac](http://carnackeys.com)                       |   ✔️    |              |                                 |
|                      [Chatbox](https://chatboxai.app)                       |   ✔️    |              |                                 |
|                        [chfs](http://iscute.cn/chfs)                        |   ✔️    |              |                                 |
|                  [CLion](https://www.jetbrains.com/clion)                   |   ✔️    |              |                                 |
|                     [CloudMusic](https://music.163.com)                     |   ✔️    |              |           网易云音乐            |
| [ContextMenuManager](https://github.com/BluePointLilac/ContextMenuManager)  |   ✔️    |              |                                 |
|                         [Cursor](https://cursor.sh)                         |   ✔️    |              |                                 |
|               [DataGrip](https://www.jetbrains.com/datagrip)                |   ✔️    |              |                                 |
|              [DataSpell](https://www.jetbrains.com/dataspell)               |   ✔️    |              |                                 |
|                       [DevToys](https://devtoys.app)                        |   ✔️    |     UWP      |                                 |
|                  [Ditto](https://ditto-cp.sourceforge.io)                   |   ✔️    |              |                                 |
|               [Dnest](https://github.com/davidkane0526/Dnest)               |   ➖    |              |                                 |
|                      [DouYin](https://www.douyin.com)                       |   ✔️    |              |              抖音               |
|               [DownKyi](https://leiurayer.github.io/downkyi)                |   ✔️    |              |                                 |
|                     [draw.io](https://www.diagrams.net)                     |   ✔️    |              |                                 |
|                   [Dropit](http://www.dropitproject.com)                    |   ✔️    |              |                                 |
|             [Escrcpy](https://github.com/viarotel-org/escrcpy)              |   ✔️    |              |                                 |
|                   [Everything](https://www.voidtools.com)                   |   ✔️    |              |                                 |
|                    [Final2x](https://final2x.tohru.top)                     |   ✔️    |              |                                 |
|                    [FishingFunds](https://ff.1zilc.top)                     |   ✔️    |              |          基金股票相关           |
|                [Flow-Launcher](https://www.flowlauncher.com)                |   ✔️    |              |                                 |
|                  [Fluent-Search](https://fluentsearch.net)                  |   ✔️    |              |                                 |
|                    [fnm](https://github.com/Schniz/fnm)                     |   ➖    |              |                                 |
|                         [Fonger](http://morin.vin)                          |   ✔️    |              |            方格音乐             |
|          [FSViewer](https://www.faststone.org/FSViewerDetail.htm)           |   ✔️    |              |     FastStone Image Viewer      |
|           [FastGithub](https://github.com/dotnetcore/FastGithub)            |   ➖    | noAutoUpdate |                                 |
|                       [FeiShu](https://www.feishu.cn)                       |   ✔️    |              |              飞书               |
|               [GeekUninstaller](https://geekuninstaller.com)                |   ✔️    |              |                                 |
|              [GitExtensions](https://gitextensions.github.io)               |   ✔️    |              |                                 |
|                 [GoLand](https://www.jetbrains.com/goland)                  |   ✔️    |              |                                 |
|                        [Gopeed](https://gopeed.com)                         |   ✔️    |              |                                 |
|              [HBuilderX](https://www.dcloud.io/hbuilderx.html)              |   ✔️    |              |                                 |
|                           [He3](https://he3.app)                            |   ✔️    |              |                                 |
|                      [Helix](https://helix-editor.com)                      |   ✔️    |              |                                 |
|                       [Heynote](https://heynote.com)                        |   ✔️    |              |                                 |
|            [hummingbird](https://arayofsunshine.dev/hummingbird)            |   ✔️    |              |                                 |
|        [Hydrogen-Music](https://github.com/Kaidesuyo/Hydrogen-Music)        |   ✔️    |              |                                 |
|                   [Idea](https://www.jetbrains.com/idea)                    |   ✔️    |              |          IntelliJ IDEA          |
|                  [IdeaCE](https://www.jetbrains.com/idea)                   |   ✔️    |              | IntelliJ IDEA Community Edition |
|                    [ImageGlass](https://imageglass.org)                     |   ✔️    |              |                                 |
|                [InputTip](https://github.com/abgox/InputTip)                |   ✔️    |              |                                 |
|                      [Insomnia](https://insomnia.rest)                      |   ✔️    |              |                                 |
|                            [jan](https://jan.ai)                            |   ✔️    |              |                                 |
|                       [Joplin](https://joplinapp.org)                       |   ✔️    |              |                                 |
|                [Keyviz](https://mularahul.github.io/keyviz)                 |   ✔️    |              |                                 |
|                       [Knotes](https://knotesapp.cn)                        |   ✔️    |              |            糯词笔记             |
|                  [Koodo-Reader](https://koodo.960960.xyz)                   |   ✔️    |              |                                 |
|                     [KuGouMusic](https://www.kugou.com)                     |   ✔️    |              |            酷狗音乐             |
|                      [Lark](https://www.larksuite.com)                      |   ✔️    |              |           飞书国际版            |
|                   [Lattics](https://lattics.zineapi.com)                    |   ✔️    |              |                                 |
|                     [Listary](https://www.listary.com)                      |   ✔️    |              |                                 |
|                     [LocalSend](https://localsend.org)                      |   ✔️    |              |                                 |
|                    [LX-Music](https://docs.lxmusic.top)                     |   ✔️    |              |          洛雪音乐助手           |
|                   [Mailpit](https://mailpit.axllent.org)                    |   ➖    |              |                                 |
|           [Manuskript](https://github.com/olivierkes/manuskript)            |   ➖    |              |                                 |
|                     [MarkLion](https://www.marklion.cn)                     |   ✔️    |              |             标记狮              |
|                     [MarkText](https://www.marktext.cc)                     |   ✔️    |              |                                 |
|      [MediaElch](https://mediaelch.github.io/mediaelch-doc/about.html)      |   ➖    |              |                                 |
|                      [Monit](https://monit.fzf404.art)                      |   ✔️    |              |                                 |
|                        [Motrix](https://motrix.app)                         |   ✔️    |              |                                 |
|                            [mpv](https://mpv.io)                            |   ✔️    |              |                                 |
|        [MusicPlayer2](https://github.com/zhongyang219/MusicPlayer2)         |   ✔️    |              |                                 |
|                         [Neovim](https://neovim.io)                         |   ✔️    |              |                                 |
|                         [ngrok](https://ngrok.com)                          |   ✔️    |              |                                 |
|                        [Noi](https://noi.nofwl.com)                         |   ✔️    |              |             AI 助手             |
|           [NotepadNext](https://github.com/dail8859/NotepadNext)            |   ✔️    |              |                                 |
|                   [Notepads](https://www.notepadsapp.com)                   |   ✔️    |     UWP      |                                 |
|            [nvm-desktop](https://github.com/1111mp/nvm-desktop)             |   ✔️    |              |                                 |
|                    [OBS-Studio](https://obsproject.com)                     |   ✔️    |              |          直播录屏相关           |
|                       [Obsidian](https://obsidian.md)                       |   ✔️    |              |                                 |
|                     [Oh-My-Posh](https://ohmyposh.dev)                      |   ✔️    |              |                                 |
|                     [PDFgear](https://www.pdfgear.com)                      |   ✔️    |              |                                 |
|                     [PeaZip](https://peazip.github.io)                      |   ✔️    |              |                                 |
|               [PhpStorm](https://www.jetbrains.com/phpstorm)                |   ✔️    |              |                                 |
|                   [PicGo](https://molunerfinn.com/PicGo)                    |   ✔️    |              |                                 |
|                       [PixPin](https://pixpinapp.com)                       |   ✔️    |              |                                 |
|                     [PixPinBeta](https://pixpinapp.com)                     |   ✔️    |              |           PixPin Beta           |
|                    [Postman](https://www.getpostman.com)                    |   ✔️    |              |                                 |
|                         [pot](https://pot-app.com)                          |   ✔️    |              |                                 |
|                   [PotPlayer](https://potplayer.daum.net)                   |   ✔️    |              |                                 |
|           [PSCompletions](https://github.com/abgox/PSCompletions)           |   ✔️    |              |        PowerShell Module        |
|                [PyCharm](https://www.jetbrains.com/pycharm)                 |   ✔️    |              |                                 |
|               [PyCharmCE](https://www.jetbrains.com/pycharm)                |   ✔️    |              |    PyCharm Community Edition    |
|             [pyenv-win](https://github.com/pyenv-win/pyenv-win)             |   ✔️    |              |                                 |
|                           [QQ](https://im.qq.com)                           |   ✔️    |              |              QQ NT              |
|                     [QQBrowser](https://browser.qq.com)                     |   ✔️    |              |            QQ 浏览器            |
|              [QtScrcpy](https://github.com/barry-ran/QtScrcpy)              |   ✔️    |              |                                 |
|                      [Quicker](https://getquicker.net)                      |   ✔️    |              |                                 |
|                 [Raptor](https://github.com/InfpHub/Raptor)                 |   ✔️    |              |         阿里云盘第三方          |
|                     [Recyclarr](https://recyclarr.dev)                      |   ➖    |              |                                 |
|                  [Rider](https://www.jetbrains.com/rider)                   |   ✔️    |              |                                 |
|                           [Rime](https://rime.im)                           |   ✔️    |   confirm    |          weasel,小狼毫          |
|              [Rubick](https://github.com/rubickCenter/rubick)               |   ✔️    |              |                                 |
|               [RubyMine](https://www.jetbrains.com/rubymine)                |   ✔️    |              |                                 |
|           [RunCat](https://github.com/Kyome22/RunCat_for_windows)           |   ➖    |              |                                 |
|              [RustDesk](https://github.com/rustdesk/rustdesk)               |   ✔️    |              |                                 |
|                [Screego](https://github.com/screego/server)                 |   ✔️    |              |                                 |
|         [ScreenToGif](https://github.com/NickeManarin/ScreenToGif)          |   ✔️    |              |                                 |
| [Sigma-File-Manager](https://github.com/aleksey-hoffman/sigma-file-manager) |   ✔️    |              |                                 |
|        [SimpleMindMap](https://wanglin2.github.io/mind-map/#/index)         |   ✔️    |              |          思绪思维导图           |
|              [SimplyListenMusic](https://music.codepublic.top)              |   ✔️    |              |            普听音乐             |
|                     [SiYuan](https://b3log.org/siyuan)                      |   ✔️    |              |              思源               |
|                    [Snipaste](https://www.snipaste.com)                     |   ✔️    |              |                                 |
|                    [Snipaste2](https://www.snipaste.com)                    |   ✔️    |              |                                 |
|                    [SodaMusic](https://music.douyin.com)                    |   ✔️    |              |         汽水音乐 - 抖音         |
|                  [Spacedrive](https://www.spacedrive.com)                   |   ✔️    |              |                                 |
|                       [Starship](https://starship.rs)                       |   ✔️    |              |                                 |
|                       [Steampp](https://steampp.net)                        |   ✔️    |              |          Watt Toolkit           |
|               [StrokesPlus.net](https://www.strokesplus.net)                |   ✔️    |              |                                 |
|                 [SublimeText](https://www.sublimetext.com)                  |   ✔️    |              |                                 |
|             [superProductivity](https://super-productivity.com)             |   ✔️    |              |                                 |
|                [SwitchHosts](https://switchhosts.vercel.app)                |   ✔️    |              |                                 |
|                [SyncBackFree](https://www.2brightsparks.com)                |   ✔️    |              |                                 |
|                [Thunderbird-CN](https://www.thunderbird.net)                |   ✔️    |              |                                 |
|                 [Thunderbird](https://www.thunderbird.net)                  |   ✔️    |              |                                 |
|                    [TinyRDM](https://redis.tinycraft.cc)                    |   ✔️    |              |                                 |
|      [TrafficMonitor](https://github.com/zhongyang219/TrafficMonitor)       |   ✔️    |   confirm    |                                 |
|       [TranslucentTB](https://github.com/TranslucentTB/TranslucentTB)       |   ✔️    |     UWP      |                                 |
|                    [TTime](https://ttime.timerecord.cn)                     |   ✔️    |              |                                 |
|                [tts-vue](https://github.com/LokerL/tts-vue)                 |   ✔️    |              |                                 |
|                         [Typora](https://typora.io)                         |   ✔️    |              |                                 |
|                       [TyporaFree](https://typora.io)                       |   ✔️    | noAutoUpdate |                                 |
|   [uncle-novel](https://uncle-novel.github.io/uncle-novel-official-site)    |   ✔️    |              |           Uncle 小说            |
|                     [Uninstalr](https://uninstalr.com)                      |   ➖    |              |                                 |
|                [Upscayl](https://github.com/upscayl/upscayl)                |   ✔️    |              |                                 |
|                          [uTools](https://u.tools)                          |   ✔️    |              |                                 |
|                     [VLC](https://www.videolan.org/vlc)                     |   ✔️    |              |                                 |
|       [VovStickyNotes](https://vovsoft.com/software/vov-sticky-notes)       |   ✔️    |              |                                 |
|                   [VSCode](https://code.visualstudio.com)                   |   ✔️    |              |                                 |
|                      [WasmEdge](https://wasmedge.org)                       |   ➖    |              |                                 |
|               [WebStorm](https://www.jetbrains.com/webstorm)                |   ✔️    |              |                                 |
|                     [WeChat](https://pc.weixin.qq.com)                      |   ✔️    |              |              微信               |
|                       [WeekToDo](https://weektodo.me)                       |   ✔️    |              |                                 |
|               [Widgets](https://github.com/widget-js/widgets)               |   ✔️    |              |            桌面组件             |
|                       [WinRAR-CN](https://rarlab.com)                       |   ✔️    |              |          WinRAR 中文版          |
|                        [WinRAR](https://rarlab.com)                         |   ✔️    |              |                                 |
|        [WiseCare365](https://www.wisecleaner.com/wise-care-365.html)        |   ✔️    |   confirm    |                                 |
|               [WonderPen](https://www.tominlab.com/wonderpen)               |   ✔️    |              |              妙笔               |
|                   [Writeathon](https://www.writeathon.cn)                   |   ✔️    |              |                                 |
|            [XBYDriver](https://github.com/gaozhangmin/aliyunpan)            |   ✔️    |              |   小白羊云盘(阿里云盘第三方)    |
|               [XYplorer](https://www.xyplorer.com/index.php)                |   ✔️    |              |                                 |
|              [XYplorerFree](https://www.xyplorer.com/free.php)              |   ✔️    | noAutoUpdate |                                 |
|        [YouDaoTranslate](https://fanyi.youdao.com/download-Windows)         |   ✔️    |   confirm    |          网易有道翻译           |
|                       [YuQue](https://www.yuque.com)                        |   ✔️    |              |              语雀               |
|                      [Z-Library](https://z-library.se)                      |   ✔️    |              |                                 |
|                      [Zotero](https://www.zotero.org)                       |   ✔️    |              |                                 |
