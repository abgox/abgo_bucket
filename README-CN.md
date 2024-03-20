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

-   推荐使用 [PSCompletions 项目中的 scoop 补全 ](https://gitee.com/abgox/PSCompletions 'PSCompletions')

### 正在使用 Scoop

1.  `scoop bucket add abgo_bucket https://gitee.com/abgox/abgo_bucket`

    -   此处的 `abgo_bucket` 为添加到本地的桶名称，可自由命名。

2.  安装应用

    -   `scoop install [abgo_bucket/]<app_name>`

    -   使用外部浏览器下载应用：

        -   当国内使用命令行下载慢，且你有其他更好的方式可以通过安装包链接下载时，它是一个很好的选择。

        ```powershell
            <your_scoop_path>\bucket\abgo_bucket\bin\download.ps1 [bucket/]<app_name> [-isUpdate]
        ```

-   列出 `abgo_bucket` 中所有可安装的应用：

    ```powershell
        <your_scoop_path>\bucket\abgo_bucket\bin\list_all_app.ps1
    ```

### 没有使用过 Scoop

-   [什么是 Scoop?](https://github.com/ScoopInstaller/Scoop)
-   [什么是 Scoop 中的 bucket?](https://github.com/ScoopInstaller/Scoop)
-   [什么是 Scoop 中的应用清单(App-Manifests)?](https://github.com/ScoopInstaller/Scoop/wiki/App-Manifests)
-   [安装 Scoop](https://github.com/ScoopInstaller/Install)
-   [Scoop 文档](https://github.com/ScoopInstaller/Scoop/wiki)

---

### 为什么创建 `abgo_bucket`

1. 在使用官方或第三方 `bucket` 时，可能存在以下问题：

    - 一些应用并没有进行 `persist` (没有必要持久化数据的应用除外)。
        - `abgo_bucket` 中采取软链接的方式持久化数据，不局限于应用目录下的数据，包括如 `$env:AppData`、`$env:LocalAppData` 等目录中的应用数据。
    - 应用卸载后，本地数据没有得到及时清理(如 `$env:AppData`、`$env:LocalAppData` 或其他目录下的应用数据)。
        - `abgo_bucket` 中所有应用在卸载时，会删除所有相关应用数据，只有 `persist` 目录下的数据会保留。
        - 如果卸载时使用 `-p/--purge` 参数，`persist` 目录下的数据也会删除。
    - 应用卸载时，可能出现当前应用正在运行，无法卸载的情况，导致应用未正常卸载，又不可用的尴尬状态。
        - `abgo_bucket` 中的应用在卸载时会先终止所有应用目录下的进程，然后执行卸载操作。
    - 应用安装仅限于解包获取到应用目录，有可能存在一些文件、库、或注册表缺失。
        - `abgo_bucket` 中的应用，如果可以运行 exe 安装，会静默运行 exe 安装，保证安装后应用目录的完整性。
        - 同时，卸载时会优先使用应用自带的卸载程序进行卸载。
    - ...

2. 整理一些常用的、使用体验不错的应用。

---

### 关于 persist(数据持久化)

-   `abgo_bucket` 中的应用主要通过软链接的方式去实现 `persist`，好处是不局限于应用目录下的数据文件。
-   持久化策略**比较激进**，如果存在数据目录，`abgo_bucket` 中的应用就会将整个数据目录持久化，而非一些重要的配置文件。
    -   以 `Neovim` 为例，它会在 `$env:LocalAppData` 下形成两个目录，`nvim` 和 `nvim-data` ，而这两个目录都会被持久化。
    -   这样做的好处是应用在拥有 `persist` 时，安装后的使用体验是流畅无感的，但可能导致占用的存储空间会更多。

#### ⚠︎ 关于 persist 目录变动 ⚠︎

-   **2024 年 1 月 15 日**，部分应用的持久化操作发生了一些变动。[点击查看这个 commit](https://gitee.com/abgox/abgo_bucket/commit/3b65bc2fe6f836028e0b7bde9bce4de586550eb9)
-   变动的应用有：`Final2x`，`GeekUninstaller`，`Helix`，`LX-Music`，`Listary`，`MarkText`，`Motrix`，`MusicPlayer2`，`ngrok`，`Oh-My-Posh`，`Quicker`，`Rubick`，`RustDesk`，`ScreenToGif`，`Sigma-File-Manager`，`TrafficMonitor`，`tts-vue`，`Typora`，`XBYDriver`
    -   以 `GeekUninstaller`为例：
        -   之前：`<your_scoop_path>\persist\geekuninstaller`
        -   现在：`<your_scoop_path>\persist\geekuninstaller\Geek Uninstaller`

### 关于快捷方式

-   `abgo_bucket` 中的应用默认会在安装和更新时，自动创建桌面快捷方式。
-   你可以运行命令添加 `Scoop` 配置项来禁止创建桌面快捷方式。`scoop config abgo_bucket_no_shortcut true`

---

### 应用清单

-   所有清单默认支持：

    -   **数据清理** ：当应用卸载后，如果存在应用残留数据则删除(`persist` 数据除外)。
    -   **强制卸载** ：当应用正在运行时，使用 `scoop uninstall <app_name>` 会先尝试终止进程，再进行卸载，避免卸载时出现应用正在使用，无法卸载的问题。

-   说明

    -   **`App`** ：点击跳转官网或仓库，按照数字字母排序(0-9,a-z)。
    -   **`persist`** ：应用重要数据保存到 `Scoop` 安装目录下的 `persist` 中。
        -   **`✔️`** ：已实现。
        -   **`❌`** ：未实现。
        -   **`➖`** ：没必要或不满足条件(比如：找不到数据文件)。
    -   **`Tag`**

        -   `run` ：安装后会立即运行一次。
        -   `UWP` ：一个 `UWP` 应用，此应用的程序文件不在 `Scoop` 中。`Scoop` 只管理数据的持久化(`persist`)、安装、更新以及卸载操作。
        -   `confirm` : 应用在卸载时有一个命令行(或卸载程序)交互确认
        -   `noAutoUpdate` : `json.autoupdate` 未配置，Scoop 无法自动检测更新
        -   `invalid` ：无效应用，已放入 deprecated(废弃) 文件夹中，未来可能从清单中移除。

    -   **`Note`**: 一些其他信息

---

|                                     App                                     | persist |     Tag      |          Note          |
| :-------------------------------------------------------------------------: | :-----: | :----------: | :--------------------: |
|              [1History](https://github.com/1History/1History)               |   ➖    |              |                        |
|                          [7zip](https://7-zip.org)                          |   ➖    |   confirm    |                        |
|                      [123pan](https://www.123pan.com)                       |   ✔️    |              |        123 云盘        |
|                        [aardio](https://aardio.com)                         |   ✔️    |              |                        |
|                    [AdsPower](https://www.adspower.net)                     |   ✔️    |              |       指纹浏览器       |
|                        [AFFINE](https://affine.pro)                         |   ✔️    |              |                        |
|                    [aliyunDrive](https://www.alipan.com)                    |   ✔️    |              |        阿里云盘        |
|                    [AutoHotkey](https://autohotkey.com)                     |   ✔️    |              |                        |
|               [BaiduNetdisk](https://pan.baidu.com/download)                |   ✔️    |              |        百度网盘        |
|                  [BaiduTranslate](https://fanyi.baidu.com)                  |   ✔️    |              |        百度翻译        |
|                    [Bilibili](https://app.bilibili.com)                     |   ✔️    |              |        哔哩哔哩        |
|        [BitMeterOS](https://codebox.net/pages/bitmeteros-downloads)         |   ➖    |              |                        |
|                      [Bruno](https://www.usebruno.com)                      |   ✔️    |              |                        |
|                       [Carnac](http://carnackeys.com)                       |   ✔️    |              |                        |
|                      [Chatbox](https://chatboxai.app)                       |   ✔️    |              |                        |
|                        [chfs](http://iscute.cn/chfs)                        |   ✔️    |              |                        |
|                     [CloudMusic](https://music.163.com)                     |   ✔️    |              |       网易云音乐       |
| [ContextMenuManager](https://github.com/BluePointLilac/ContextMenuManager)  |   ✔️    |              |                        |
|                       [DevToys](https://devtoys.app)                        |   ✔️    |     UWP      |                        |
|                  [Ditto](https://ditto-cp.sourceforge.io)                   |   ✔️    |              |                        |
|               [Dnest](https://github.com/davidkane0526/Dnest)               |   ➖    |              |                        |
|                      [DouYin](https://www.douyin.com)                       |   ✔️    |              |          抖音          |
|               [DownKyi](https://leiurayer.github.io/downkyi)                |   ✔️    |              |                        |
|                     [draw.io](https://www.diagrams.net)                     |   ✔️    |              |                        |
|                   [Dropit](http://www.dropitproject.com)                    |   ✔️    |              |                        |
|                   [Everything](https://www.voidtools.com)                   |   ✔️    |              |                        |
|                    [Final2x](https://final2x.tohru.top)                     |   ✔️    |              |                        |
|                    [FishingFunds](https://ff.1zilc.top)                     |   ✔️    |              |      基金股票相关      |
|                [Flow-Launcher](https://www.flowlauncher.com)                |   ✔️    |              |                        |
|                  [Fluent-Search](https://fluentsearch.net)                  |   ✔️    |              |                        |
|                    [fnm](https://github.com/Schniz/fnm)                     |   ➖    |              |                        |
|                         [Fonger](http://morin.vin)                          |   ✔️    |              |        方格音乐        |
|          [FSViewer](https://www.faststone.org/FSViewerDetail.htm)           |   ✔️    |              | FastStone Image Viewer |
|           [FastGithub](https://github.com/dotnetcore/FastGithub)            |   ➖    | noAutoUpdate |                        |
|                       [FeiShu](https://www.feishu.cn)                       |   ✔️    |              |          飞书          |
|               [GeekUninstaller](https://geekuninstaller.com)                |   ✔️    |              |                        |
|              [GitExtensions](https://gitextensions.github.io)               |   ✔️    |              |                        |
|                        [Gopeed](https://gopeed.com)                         |   ✔️    |              |                        |
|              [HBuilderX](https://www.dcloud.io/hbuilderx.html)              |   ✔️    |              |                        |
|                           [He3](https://he3.app)                            |   ✔️    |              |                        |
|                      [Helix](https://helix-editor.com)                      |   ✔️    |              |                        |
|        [Hydrogen-Music](https://github.com/Kaidesuyo/Hydrogen-Music)        |   ✔️    |              |                        |
|                    [ImageGlass](https://imageglass.org)                     |   ✔️    |              |                        |
|                [InputTip](https://github.com/abgox/InputTip)                |   ✔️    |              |                        |
|                      [Insomnia](https://insomnia.rest)                      |   ✔️    |              |                        |
|                            [jan](https://jan.ai)                            |   ✔️    |              |                        |
|                       [Joplin](https://joplinapp.org)                       |   ✔️    |              |                        |
|                [Keyviz](https://mularahul.github.io/keyviz)                 |   ✔️    |              |                        |
|                       [Knotes](https://knotesapp.cn)                        |   ✔️    |              |        糯词笔记        |
|                  [Koodo-Reader](https://koodo.960960.xyz)                   |   ✔️    |              |                        |
|                     [KuGouMusic](https://www.kugou.com)                     |   ✔️    |              |        酷狗音乐        |
|                      [Lark](https://www.larksuite.com)                      |   ✔️    |              |       飞书国际版       |
|                   [Lattics](https://lattics.zineapi.com)                    |   ✔️    |              |                        |
|                     [Listary](https://www.listary.com)                      |   ✔️    |              |                        |
|                     [LocalSend](https://localsend.org)                      |   ✔️    |              |                        |
|                    [LX-Music](https://docs.lxmusic.top)                     |   ✔️    |              |      洛雪音乐助手      |
|                   [Mailpit](https://mailpit.axllent.org)                    |   ➖    |              |                        |
|           [Manuskript](https://github.com/olivierkes/manuskript)            |   ➖    |              |                        |
|                     [MarkLion](https://www.marklion.cn)                     |   ✔️    |              |         标记狮         |
|                     [MarkText](https://www.marktext.cc)                     |   ✔️    |              |                        |
|      [MediaElch](https://mediaelch.github.io/mediaelch-doc/about.html)      |   ➖    |              |                        |
|                      [Monit](https://monit.fzf404.art)                      |   ✔️    |              |                        |
|                        [Motrix](https://motrix.app)                         |   ✔️    |              |                        |
|        [MusicPlayer2](https://github.com/zhongyang219/MusicPlayer2)         |   ✔️    |              |                        |
|                         [Neovim](https://neovim.io)                         |   ✔️    |              |                        |
|                         [ngrok](https://ngrok.com)                          |   ✔️    |              |                        |
|                        [Noi](https://noi.nofwl.com)                         |   ✔️    |              |        AI 助手         |
|           [NotepadNext](https://github.com/dail8859/NotepadNext)            |   ✔️    |              |                        |
|                   [Notepads](https://www.notepadsapp.com)                   |   ✔️    |     UWP      |                        |
|            [nvm-desktop](https://github.com/1111mp/nvm-desktop)             |   ✔️    |              |                        |
|                    [OBS-Studio](https://obsproject.com)                     |   ✔️    |              |      直播录屏相关      |
|                       [Obsidian](https://obsidian.md)                       |   ✔️    |              |                        |
|                     [Oh-My-Posh](https://ohmyposh.dev)                      |   ✔️    |              |                        |
|                     [PDFgear](https://www.pdfgear.com)                      |   ✔️    |              |                        |
|                     [PeaZip](https://peazip.github.io)                      |   ✔️    |              |                        |
|                   [PicGo](https://molunerfinn.com/PicGo)                    |   ✔️    |              |                        |
|                       [PixPin](https://pixpinapp.com)                       |   ✔️    |              |                        |
|                     [PixPinBeta](https://pixpinapp.com)                     |   ✔️    |              |      PixPin Beta       |
|                    [Postman](https://www.getpostman.com)                    |   ✔️    |              |                        |
|                         [pot](https://pot-app.com)                          |   ✔️    |              |                        |
|                   [PotPlayer](https://potplayer.daum.net)                   |   ✔️    |              |                        |
|           [PSCompletions](https://github.com/abgox/PSCompletions)           |   ✔️    |              |   PowerShell Module    |
|             [pyenv-win](https://github.com/pyenv-win/pyenv-win)             |   ✔️    |              |                        |
|                           [QQ](https://im.qq.com)                           |   ✔️    |              |         QQ NT          |
|                     [QQBrowser](https://browser.qq.com)                     |   ✔️    |              |       QQ 浏览器        |
|              [QtScrcpy](https://github.com/barry-ran/QtScrcpy)              |   ✔️    |              |                        |
|                      [Quicker](https://getquicker.net)                      |   ✔️    |              |                        |
|                     [Recyclarr](https://recyclarr.dev)                      |   ➖    |              |                        |
|                           [Rime](https://rime.im)                           |   ✔️    |   confirm    |     weasel,小狼毫      |
|              [Rubick](https://github.com/rubickCenter/rubick)               |   ✔️    |              |                        |
|           [RunCat](https://github.com/Kyome22/RunCat_for_windows)           |   ➖    |              |                        |
|              [RustDesk](https://github.com/rustdesk/rustdesk)               |   ✔️    |              |                        |
|                [Screego](https://github.com/screego/server)                 |   ✔️    |              |                        |
|         [ScreenToGif](https://github.com/NickeManarin/ScreenToGif)          |   ✔️    |              |                        |
| [Sigma-File-Manager](https://github.com/aleksey-hoffman/sigma-file-manager) |   ✔️    |              |                        |
|              [SimplyListenMusic](https://music.codepublic.top)              |   ✔️    |              |        普听音乐        |
|                     [SiYuan](https://b3log.org/siyuan)                      |   ✔️    |              |          思源          |
|                    [Snipaste](https://www.snipaste.com)                     |   ✔️    |              |                        |
|                    [Snipaste2](https://www.snipaste.com)                    |   ✔️    |              |                        |
|                  [Spacedrive](https://www.spacedrive.com)                   |   ✔️    |              |                        |
|                       [Steampp](https://steampp.net)                        |   ✔️    |              |      Watt Toolkit      |
|               [StrokesPlus.net](https://www.strokesplus.net)                |   ✔️    |              |                        |
|                [SwitchHosts](https://switchhosts.vercel.app)                |   ✔️    |              |                        |
|                [SyncBackFree](https://www.2brightsparks.com)                |   ✔️    |              |                        |
|      [TrafficMonitor](https://github.com/zhongyang219/TrafficMonitor)       |   ✔️    |   confirm    |                        |
|       [TranslucentTB](https://github.com/TranslucentTB/TranslucentTB)       |   ✔️    |     UWP      |                        |
|                    [TTime](https://ttime.timerecord.cn)                     |   ✔️    |              |                        |
|                [tts-vue](https://github.com/LokerL/tts-vue)                 |   ✔️    |              |                        |
|                         [Typora](https://typora.io)                         |   ✔️    |              |                        |
|                       [TyporaFree](https://typora.io)                       |   ✔️    | noAutoUpdate |                        |
|   [uncle-novel](https://uncle-novel.github.io/uncle-novel-official-site)    |   ✔️    |              |       Uncle 小说       |
|                     [Uninstalr](https://uninstalr.com)                      |   ➖    |              |                        |
|                [Upscayl](https://github.com/upscayl/upscayl)                |   ✔️    |              |                        |
|                          [uTools](https://u.tools)                          |   ✔️    |              |                        |
|       [VovStickyNotes](https://vovsoft.com/software/vov-sticky-notes)       |   ✔️    |              |                        |
|                   [VSCode](https://code.visualstudio.com)                   |   ✔️    |              |                        |
|                      [WasmEdge](https://wasmedge.org)                       |   ➖    |              |                        |
|                     [WeChat](https://pc.weixin.qq.com)                      |   ✔️    |              |          微信          |
|                       [WeekToDo](https://weektodo.me)                       |   ✔️    |              |                        |
|               [Widgets](https://github.com/widget-js/widgets)               |   ✔️    |              |        桌面组件        |
|                       [WinRAR-CN](https://rarlab.com)                       |   ✔️    |              |     WinRAR 中文版      |
|                        [WinRAR](https://rarlab.com)                         |   ✔️    |              |                        |
|        [WiseCare365](https://www.wisecleaner.com/wise-care-365.html)        |   ✔️    |   confirm    |                        |
|               [WonderPen](https://www.tominlab.com/wonderpen)               |   ✔️    |              |          妙笔          |
|                   [Writeathon](https://www.writeathon.cn)                   |   ✔️    |              |                        |
|            [XBYDriver](https://github.com/gaozhangmin/aliyunpan)            |   ✔️    |              |       小白羊云盘       |
|               [XYplorer](https://www.xyplorer.com/index.php)                |   ✔️    |              |                        |
|              [XYplorerFree](https://www.xyplorer.com/free.php)              |   ✔️    | noAutoUpdate |                        |
|        [YouDaoTranslate](https://fanyi.youdao.com/download-Windows)         |   ✔️    |   confirm    |      网易有道翻译      |
|                       [YuQue](https://www.yuque.com)                        |   ✔️    |              |          语雀          |
|                      [Z-Library](https://z-library.se)                      |   ✔️    |              |                        |
|                      [Zotero](https://www.zotero.org)                       |   ✔️    |              |                        |
