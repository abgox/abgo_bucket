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

    -   使用外部方式下载(更新)应用：

        -   当使用命令行下载速度慢，并且有更好的方式可以通过安装包链接下载时，它是一个很好的选择。

        ```powershell
            <your_scoop_path>\bucket\abgo_bucket\bin\download.ps1 [bucket/]<app_name>
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

### 关于应用更新

- 当使用 `scoop update` 更新应用时，现在默认会保留旧版本目录
  - 注意: 如果当前应用使用了应用自带的卸载程序，会在更新时执行卸载程序，不会保留旧版本目录
- 如果应用存在旧版本目录，你可以通过 `scoop reset app@version` 去重置为指定的已安装的旧版本
- 你可以运行以下命令添加 `Scoop` 配置项让应用更新时移除旧版本目录
  - `scoop config abgo_bucket_no_old_version true`

### 关于 persist(数据持久化)

-   `abgo_bucket` 中的应用主要通过 `New-Item -ItemType SymbolicLink` 去实现 `persist`，它不局限于应用目录下的数据文件。
    -   由于链接的数据文件和目录不一定在 scoop 目录下
    -   如果重装系统或将 scoop 目录拷贝到其他电脑，请重装应用确保数据文件或目录与 `persist` 目录下的应用数据链接
-   持久化策略**比较激进**，如果存在数据目录，`abgo_bucket` 中的应用就会将整个数据目录持久化，而非一些重要的配置文件。
    -   以 `Neovim` 为例，它会在 `$env:LocalAppData` 下形成两个目录，`nvim` 和 `nvim-data` ，而这两个目录都会被持久化。
    -   这样做的好处是应用在拥有 `persist` 时，安装后的使用体验是流畅无感的，但可能导致占用的存储空间会更多。
-   这种**激进**的持久化策略会导致 `abgo_bucket` 的持久化目录文件和其他 `bucket` 不同
-   因此，如果从其他 `bucket` 迁移至 `abgo_bucket` 或者从 `abgo_bucket` 迁移至其他仓库，请重视数据持久化 `persist` 的变动

#### ⚠︎ 关于 persist 目录变动 ⚠︎

-   **2024 年 1 月 15 日**，部分应用的持久化操作发生了一些变动。[点击查看这个 commit](https://gitee.com/abgox/abgo_bucket/commit/3b65bc2fe6f836028e0b7bde9bce4de586550eb9)
-   变动的应用有：`Final2x`，`GeekUninstaller`，`Helix`，`LX-Music`，`Listary`，`MarkText`，`Motrix`，`MusicPlayer2`，`ngrok`，`Oh-My-Posh`，`Quicker`，`Rubick`，`RustDesk`，`ScreenToGif`，`Sigma-File-Manager`，`TrafficMonitor`，`tts-vue`，`Typora`，`XBYDriver`
    -   以 `GeekUninstaller`为例：
        -   之前：`<your_scoop_path>\persist\geekuninstaller`
        -   现在：`<your_scoop_path>\persist\geekuninstaller\Geek Uninstaller`

### 关于快捷方式

-   `abgo_bucket` 中的应用默认会在安装和更新时，自动创建桌面快捷方式。
-   你可以运行以下命令添加 `Scoop` 配置项来禁止创建桌面快捷方式。
    -   `scoop config abgo_bucket_no_shortcut true`

### 关于 Confirm 确认

-   [应用清单](#应用清单) 中带有 `Confirm` 标签的应用在以下情况中(一个或多个)需要用户确认以避免一些问题
    1. 卸载应用时，因为一些特殊情况，卸载程序无法完全停止应用进程
    2. 卸载应用后，会重启文件管理器(`explorer.exe`)
-   这会导致软件的安装卸载无法达到完全的静默自动化
-   但你可以运行以下命令添加 `Scoop` 配置项来避免用户确认
    -   `scoop config abgo_bucket_no_confirm true`

### 关于 `UAC`

-   为了保证脚本正常的运行，`bin` 目录下的脚本在某些情况下会提升到管理员权限运行
-   这会出现 `UAC` 授权窗口需要用户确认
-   如果你不希望受到 `UAC` 授权窗口的干扰，实现完成的静默自动化，你应该寻找方法去避免它出现
    1. 使用管理员权限启动命令行
    2. 在系统设置里修改 `用户账户控制设置`
    3. ...

---

### 应用清单

-   所有清单默认支持：

    -   **数据清理** ：当应用卸载后，如果存在应用残留数据则删除(`persist` 数据除外)。
    -   **强制卸载** ：当应用正在运行时，使用 `scoop uninstall <app_name>` 会先尝试终止进程，再进行卸载，避免卸载时出现应用正在使用，无法卸载的问题。

-   说明

    -   **`App`** ：点击跳转官网或仓库，按照数字字母排序(0-9,a-z)。
    -   **`Persist`** ：应用重要数据保存到 `Scoop` 安装目录下的 `persist` 中。
        -   **`✔️`** ：已实现。
        -   **`❌`** ：未实现。
        -   **`➖`** ：没必要或不满足条件(比如：找不到数据文件)。
    -   **`Tag`**

        -   `Font`: 一种字体
            -   在字体的安装过程中，会频繁使用到管理员权限
            -   相关内容请查看 [关于 UAC](#关于-uac)
        -   `PSModule`: 一个 PowerShell 模块
        -   `Confirm` : 应用在卸载时有一个命令行(或卸载程序)交互确认
        -   `NoAutoUpdate` : `json.autoupdate` 未配置，Scoop 无法自动检测更新

    -   **`Description`**: 应用描述

---

|App|Persist|Tag|Description|
|:-:|:-:|:-:|-|
|[123pan](https://www.123pan.com/)|✔️||123 云盘，一款云存储服务产品。<br>A cloud storage service product.|
|[1History](https://github.com/1History/1History)|➖||一款命令行工具，可将不同的浏览器历史记录备份到一个文件中，并将其可视化。<br>A command line tool to backup your different browser histories into one file, and visualize them.|
|[7zip](https://www.7-zip.org/)|➖|`Confirm`|具有高压缩比的多格式文件归档器。<br>A multi-format file archiver with high compression ratios.|
|[aardio](https://www.aardio.com/)|✔️||灵活而强大的动态语言。<br>A flexible and powerful dynamic language.|
|[AdsPower](https://www.adspower.net/)|✔️||一个指纹浏览器。<br>A No anti-detection browser|
|[AFFINE](https://affine.pro)|✔️||下一代知识库，集规划、分类和创建于一体。隐私第一、开源、可定制、随时可用。<br>A next-gen knowledge base that brings planning, sorting and creating all together. Privacy first, open-source, customizable and ready to use.|
|[aliyunDrive](https://www.alipan.com/)|✔️||一款速度快、不打扰、够安全、易于分享的网盘，你可以在这里存储、管理和探索内容，尽情打造丰富的数字世界。<br>A fast, non-intrusive, secure and easy-to-share personal netdisk where you can store, manage and explore things, and build a flourishing digital world.|
|[Apifox](https://apifox.com)|✔️||API 设计、开发、测试一体化协作平台。<br>All-in-one collaboration platform for API documentation, API debugging, API Mock and API test automation.|
|[AppFlowy](https://www.appflowy.io/)|✔️||一个开源的 Notion 替代品。<br>An open-source alternative to Notion.|
|[AutoHotkey](https://www.autohotkey.com)|✔️||适用于 Windows 的终极自动化脚本语言。<br>The ultimate automation scripting language for Windows.|
|[BaiduNetdisk](https://pan.baidu.com/download)|✔️||百度网盘。<br>Baidu Netdisk for windows.|
|[BaiduTranslate](https://fanyi.baidu.com)|✔️||轻·快的多语种翻译工具。<br>A fast and lightweight multilingual translation tool.|
|[Bilibili](https://app.bilibili.com/)|✔️||哔哩哔哩 Windows 客户端|
|[BitMeterOS](https://codebox.net/pages/bitmeteros-downloads)|➖||一个带命令行的网络监控工具。<br>A networking monitoring with command line tool.|
|[Bruno](https://www.usebruno.com/)|✔️||一个快速且 Git 友好的开源 API 客户端。<br>A Fast and Git-Friendly OpenSource API client.|
|[Carnac](http://carnackeys.com/)|✔️||一个可以帮助您了解键盘使用方式的实用程序。<br>A utility to give some insight into how you use your keyboard.|
|[Chatbox](https://chatboxai.app/)|✔️||一个可使用 ChatGPT、Claude 和其他 LLM 的桌面客户端。<br>A desktop client for ChatGPT, Claude and other LLMs.|
|[chfs](http://iscute.cn/chfs)|✔️||一个免费的http服务器文件共享工具，通过局域网实现文件传输。<br>A free file sharing http server tool.|
|[CLion](https://www.jetbrains.com/clion/)|✔️||由 JetBrains 开发的适用于 C 和 C++ 的跨平台集成开发环境。<br>Cross-Platform IDE for C and C++ by JetBrains.|
|[CloudMusic](https://music.163.com/)|✔️||网易旗下的音乐平台，同时也是业内领先的音乐社区。<br>It's NetEase's music platform, and it's also the industry's leading music community.|
|[ContextMenuManager](https://github.com/BluePointLilac/ContextMenuManager)|✔️||🖱️ 纯粹的 Windows 右键菜单管理程序。<br>A pure Windows context menu manager.|
|[coriander_player](https://ferry-200.github.io/coriander_player_website/)|✔️||Windows 端本地音乐播放器。<br>Local music player for Windows.|
|[Cursor](https://cursor.sh/)|✔️||人工智能优先的代码编辑器。<br>The AI-first Code Editor.|
|[DataGrip](https://www.jetbrains.com/datagrip/)|✔️||由 JetBrains 提供的一款处理多种数据库的工具。<br>A tool to handle with many databases by JetBrains.|
|[DataSpell](https://www.jetbrains.com/dataspell/)|✔️||由 JetBrains 提供的一款工具，轻松地将数据转化为见解。<br>A tool to turn data into insights with ease by JetBrains.|
|[DevToys](https://devtoys.app/)|✔️||开发人员的瑞士军刀。<br>A Swiss Army knife for developers.|
|[Ditto](https://ditto-cp.sourceforge.io)|✔️||一个 Windows 剪贴板的扩展工具。<br>An extension to the Windows Clipboard.|
|[Dnest](https://github.com/davidkane0526/Dnest)|➖||Windows 系统上的文件暂存工具，类似 MacOs 上的 Yoink。<br>A file staging tool for Windows systems, similar to Yoink for MacOs.|
|[DouYin](https://www.douyin.com/)|✔️||抖音，一个短视频平台。<br>|
|[DownKyi](https://github.com/leiurayer/downkyi)|✔️||一个B站(bilibili)视频下载工具。<br>A bilibili video download tool.|
|[draw\.io](https://www.diagrams.net)|✔️||一款专业的绘图工具。<br>Professional diagramming.|
|[Dropit](http://www.dropitproject.com)|✔️||一个可以自动管理文件的工具。<br>Personal assistant to automatically manage your files.|
|[Escrcpy](https://github.com/viarotel-org/escrcpy)|✔️||使用图形化的 Scrcpy 显示和控制您的 Android 设备，由 Electron 驱动。<br>Graphical Scrcpy to display and control Android, devices powered by Electron.|
|[Everything](https://www.voidtools.com)|✔️||文件搜索工具，基于名称快速定位文件和文件夹。<br>Locate files and folders by name instantly.|
|[EverythingToolbar](https://github.com/srwi/EverythingToolbar)|✔️||由 Everything 提供支持的 Windows 任务栏的即时文件搜索集成。<br>Instant file search integration for the Windows taskbar powered by Everything.|
|[FastGithub](https://github.com/dotnetcore/FastGithub)|➖||github加速神器，解决github打不开、用户头像无法加载、releases无法上传下载、git-clone、git-pull、git-push失败等问题|
|[FeiShu](https://github.com/microsoft/winget-pkgs/tree/master/manifests/b/ByteDance/Feishu)|✔️||字节跳动旗下先进企业写协作与管理平台，一站式无缝办公协作。<br>Empowering teams by messenger, meetings, calendar, docs, and emails. It's all in one place.|
|[Final2x](https://github.com/Tohrusky/Final2x)|✔️||2^x图像超分辨率,一个开源的、强大的跨平台图像超分辨率工具。<br>2^x Image Super-Resolution.|
|[FishingFunds](https://ff.1zilc.top/)|✔️||基金,大盘,股票,虚拟货币状态栏显示小应用,基于 Electron 开发,数据源来自天天基金,蚂蚁基金,爱基金,腾讯证券等|
|[Flow-Launcher](https://www.flowlauncher.com)|✔️||适用于 Windows 的快速文件搜索和应用程序启动器。<br>Quick file searcher and app launcher with community-made plugins|
|[Fluent-Search](https://fluentsearch.net)|✔️||使用它，你可以搜索正在运行的应用程序、浏览器标签、应用程序内内容、文件等。<br>With it, you can search for running apps, browser tabs, in-app content, files and more.|
|[fnm](https://github.com/Schniz/fnm)|✔️||快速、简单的 Node.js 版本管理器，采用 Rust 内建。<br>Fast and simple Node.js version manager, built in Rust.|
|[Fonger](http://morin.vin/)|✔️||方格音乐，一款音乐播放器|
|[Font-Hack](https://github.com/ryanoasis/nerd-fonts)|➖|`Font`|Hack 字体，Nerd Font 系列。<br>Nerd Fonts patched 'Hack' Font family.|
|[FSViewer](https://www.faststone.org/FSViewerDetail.htm)|✔️||FastStone Image Viewer 是一款快速、稳定、用户友好的图像浏览器、转换器和编辑器。<br>FastStone Image Viewer is a fast, stable, user-friendly image browser, converter and editor.|
|[GeekUninstaller](https://geekuninstaller.com/)|✔️||非常好用的免费卸载程序。<br>The good free uninstaller.|
|[GitExtensions](https://gitextensions.github.io/)|✔️||一个独立的 Git UI 工具去管理 Git 仓库。<br>A standalone UI tool for managing git repositories.|
|[GoLand](https://www.jetbrains.com/goland/)|✔️||由 JetBrains 开发的 Go 语言的跨平台集成开发环境。<br>Cross-Platform IDE for Golang by JetBrains.|
|[Gopeed](https://gopeed.com)|✔️||一款支持所有平台的现代下载管理器。使用 Golang 和 Flutter 构建。<br>A modern download manager that supports all platforms. Built with Golang and Flutter.|
|[HBuilderX](https://www.dcloud.io/hbuilderx.html)|✔️||DCloud 旗下的代码编辑器。<br>A code editor by DCloud.|
|[He3](https://he3.app)|✔️||一个免费、现代化的工具箱，为开发人员打造。<br>A Free, Modern Toolbox, Built for Developers.|
|[Helix](https://helix-editor.com)|✔️||后现代文本编辑器。<br>A post-modern modal text editor.|
|[Heynote](https://heynote.com/)|✔️||为开发人员提供的专用便签本。<br>A dedicated scratchpad for developers.|
|[hummingbird](https://arayofsunshine.dev/hummingbird)|✔️||一个图片压缩程序 (jpg/png/webp/svg/gif/css/js/html/mp4/mov)，它可以转换不同格式的图片。<br>A compression (jpg/png/webp/svg/gif/css/js/html/mp4/mov) App, it can convert different format pictures.|
|[Hydrogen-Music](https://gitee.com/sunshineluo/Hydrogen-Music)|✔️||仿明日方舟工业风音乐播放器，支持添加曲绘|
|[Hyper](https://hyper.is)|✔️||一个基于 Web 技术构建的终端。<br>A terminal built on web technologies.|
|[Idea](https://www.jetbrains.com/idea/)|✔️||由 JetBrains 开发的适用于 Java 和 Kotlin 开发的 IDE。<br>Cross-Platform IDE for Java and Kotlin by JetBrains.|
|[IdeaCE](https://www.jetbrains.com/idea/)|✔️||社区版 - 由 JetBrains 开发的适用于 Java 和 Kotlin 开发的 IDE。<br>Community Edition - Cross-Platform IDE for Java and Kotlin by JetBrains.|
|[ImageGlass](https://imageglass.org)|✔️||一个轻量级的、多功能的图像查看器。<br>A lightweight, versatile image viewer.|
|[InputTip](https://github.com/abgox/InputTip)|✔️||一个小工具，根据当前输入法中英文状态切换光标样式。<br>A small tool to switch the cursor style according to the current state of the input method in English and Chinese.|
|[Insomnia](https://insomnia.rest)|✔️||适用于 GraphQL、REST、WebSockets、SSE 和 gRPC 的开源跨平台 API 客户端。支持云存储、本地存储和 Git 存储。<br>The open-source, cross-platform API client for GraphQL, REST, WebSockets, SSE and gRPC. With Cloud, Local and Git storage.|
|[jan](https://jan.ai)|✔️||ChatGPT 的开源替代品，可在计算机上百分百脱机运行。<br>An open source alternative to ChatGPT that runs 100% offline on your computer.|
|[Joplin](https://joplinapp.org)|✔️||一个安全的记事和待办事项应用程序，具有同步功能，适用于 Windows、macOS、Linux、Android 和 iOS。<br>A secure note taking and to-do app with syncing capabilities for Windows, macOS, Linux, Android and iOS.|
|[Keyviz](https://mularahul.github.io/keyviz)|✔️||一个免费的开源工具来可视化你的击键 ⌨️ 和 🖱️ 鼠标实时动作。<br>A free and open-source tool to visualize your keystrokes ⌨️ and 🖱️ mouse actions in real-time.|
|[Knotes](https://knotesapp.cn/)|✔️||高效全能的读书笔记管理工具，读书爱好者的最佳读书伴侣。<br>An efficient reading notes management tool for bookworms.|
|[Koodo-Reader](https://koodo.960960.xyz)|✔️||一款现代电子书管理器和阅读器，具有同步和备份功能，适用于 Windows、macOS、Linux 和 Web。<br>A modern ebook manager and reader with sync and backup capacities for Windows, macOS, Linux and Web.|
|[KuGouMusic](https://www.kugou.com/)|✔️||酷狗音乐|
|[Lark](https://github.com/microsoft/winget-pkgs/tree/master/manifests/b/ByteDance/Lark)|✔️||无缝衔接的团队工作工具。<br>Essential Work Tools, Seamless Connection|
|[Lattics](https://lattics.zineapi.com/)|✔️||「类脑式」知识管理笔记与写作。<br>"Brain-like" Knowledge Management Notes.|
|[Listary](https://www.listary.com)|✔️||一个革命性的 Windows 搜索工具。<br>A revolutionary search utility for Windows.|
|[LocalSend](https://localsend.org/)|✔️||将文件共享到附近的设备。免费、开源、跨平台。<br>Share files to nearby devices. An open source cross-platform alternative to AirDrop.|
|[LX-Music](https://github.com/lyswhut/lx-music-desktop)|✔️||一个基于 electron 的音乐软件。<br>An electron-based music player.|
|[Mailpit](https://mailpit.axllent.org)|➖||为开发人员提供的带有应用程序接口的电子邮件和 SMTP 测试工具。<br>An email and SMTP testing tool with API for developers.|
|[Manuskript](https://github.com/olivierkes/manuskript)|➖||一个面向作家的开源工具。<br>A open-source tool for writers.|
|[MarkLion](https://www.marklion.cn/)|✔️||部署在企业私有服务器的快捷高效设计协作平台,助力团队提升协作效率、保障产品数据安全与私密。<br>|
|[MarkText](https://www.marktext.cc)|✔️||一个简单优雅的 MarkDown 编辑器，可用于 Linux、macOS 和 Windows。<br>A simple and elegant markdown editor, available for Linux, macOS and Windows.|
|[MediaElch](https://mediaelch.github.io/mediaelch-doc/about.html)|✔️||Kodi 的媒体管理器。<br>Media Manager for Kodi.|
|[Monit](https://monit.fzf404.art)|✔️||🎯桌面小组件。<br>Desktop Widget.|
|[Motrix](https://motrix.app)|✔️||一个全功能的下载器。<br>A full-featured download manager.|
|[mpv](https://mpv.io)|✔️||一个免费的、开源的、跨平台的媒体播放器。<br>A free, open source, and cross-platform media player|
|[MusicBee](https://getmusicbee.com)|✔️||音乐播放器，可轻松管理、查找和播放音乐、播客、网络广播电台等。<br>The ultimate music player to easily manage, find, and play music, podcasts, web radio stations, etc|
|[MusicPlayer2](https://github.com/zhongyang219/MusicPlayer2)|✔️||一款集音乐播放、歌词显示、格式转换等众多功能于一身的音频播放软件。<br>Audio player which supports music collection playback, lyrics display, format conversion and many other functions.|
|[Neovim](https://neovim.io/)|✔️||一个旨在重构 Vim 的文本编辑器项目。<br>A project that seeks to aggressively refactor Vim.|
|[ngrok](https://ngrok.com/)|✔️||一个命令用于通过任何 NAT 或防火墙向本地主机服务器提供即时、安全的 URL，即内网穿透。<br>Spend more time programming. One command for an instant, secure URL to your localhost server through any NAT or firewall.|
|[Noi](https://noi.nofwl.com/)|✔️||人工智能助力你的世界 —— 探索、扩展、赋能。<br>Power Your World with AI - Explore, Extend, Empower.|
|[NotepadNext](https://github.com/dail8859/NotepadNext)|✔️||Notepad++ 的跨平台重新实现。<br>A cross-platform, reimplementation of Notepad++|
|[Notepads](https://www.notepadsapp.com/)|✔️||一款设计简约的现代轻量级文本编辑器。<br>A modern, lightweight text editor with a minimalist design.|
|[nvm-desktop](https://github.com/1111mp/nvm-desktop)|✔️||一个用于管理多个活动 node.js 版本的桌面应用程序。<br>A desktop application to manage multiple active node.js versions.|
|[OBS-Studio](https://obsproject.com)|✔️||用于视频录制和直播的免费开源软件。<br>Free and open source software for video recording and live streaming.|
|[Obsidian](https://obsidian.md)|✔️||强大的知识库，基于 Markdown 文件。<br>Powerful knowledge base that works on top of a local folder of plain text Markdown files.|
|[Oh-My-Posh](https://ohmyposh.dev)|✔️||任何 shell 的提示主题引擎。<br>A prompt theme engine for any shell.|
|[PDFgear](https://www.pdfgear.com/)|✔️||一款功能齐全的 PDF 管理软件。<br>A piece of full-featured PDF management software.|
|[PeaZip](https://peazip.github.io)|✔️||一个基于开放源码技术的免费文件归档(压缩)实用程序。<br>A free file archiver utility, based on Open Source technologies.|
|[PhpStorm](https://www.jetbrains.com/phpstorm/)|✔️||由 JetBrains 开发的适用于 PHP 的跨平台集成开发环境。<br>Cross-Platform IDE for PHP by JetBrains.|
|[PicGo](https://molunerfinn.com/PicGo/)|✔️||由 vue-cli-electron-builder 构建的简洁美观的图片上传工具。<br>A simple & beautiful tool for pictures uploading built by vue-cli-electron-builder.|
|[PixPin](https://pixpinapp.com/)|✔️||功能强大使用简单的截图/贴图工具，帮助你提高效率。<br>A powerful screenshot tool.|
|[PixPinBeta](https://pixpinapp.com/)|✔️||(Beta 版本) 功能强大使用简单的截图/贴图工具，帮助你提高效率。<br>(Beta version) A powerful screenshot tool.|
|[Postman](https://www.getpostman.com/)|✔️||一个完整的API开发环境。<br>Complete API development environment.|
|[Pot](https://pot-app.com/)|✔️||一个跨平台的划词翻译和OCR软件。<br>A cross-platform software for text translation and recognition.|
|[PotPlayer](https://potplayer.daum.net)|✔️||高度可定制的媒体播放器。<br>Highly customizable media player.|
|[PSCompletions](https://github.com/abgox/PSCompletions)|✔️|`PSModule`|一个补全管理模块，更简单、更方便的使用 PowerShell 命令补全。<br>A completion manager for better and simpler use PowerShell completions.|
|[PyCharm](https://www.jetbrains.com/pycharm/)|✔️||由 JetBrains 开发的适用于纯 Python 开发的 IDE。<br>Cross-Platform IDE for Python by JetBrains.|
|[PyCharmCE](https://www.jetbrains.com/pycharm/)|✔️||社区版 - 由 JetBrains 开发的适用于纯 Python 开发的 IDE。<br>Community Edition - Cross-Platform IDE for Python by JetBrains.|
|[pyenv-win](https://github.com/pyenv-win/pyenv-win)|✔️||windows 下的 pyenv，一个简单的 python 版本管理工具。<br>pyenv for Windows. pyenv is a simple python version management tool. |
|[QQ](https://im.qq.com/)|✔️||(NT版本) 一款能让你与你的朋友和家人保持联系的即时通讯工具。<br>(NT version) An instant messaging tool that gives you the best way to keep in touch with your friends and family.|
|[QQBrowser](https://browser.qq.com/)|✔️||腾讯官方出品，基于 Chromium 内核开发，启动速度、打开网页速度更快的浏览器。<br>Tencent's official Chromium-based browser with faster startup and web page opening speed.|
|[QtScrcpy](https://github.com/barry-ran/QtScrcpy)|✔️||通过TCP/IP或USB显示和控制Android设备。<br>Display and control Android device via TCP/IP or USB.|
|[Quicker](https://getquicker.net)|✔️||指尖工具箱, Windows 效率工具|
|[Raptor](https://github.com/InfpHub/Raptor)|✔️||第三方阿里云盘桌面应用客户端|
|[Recyclarr](https://recyclarr.dev/)|➖||一个命令行应用程序，可自动将 TRaSH 指南中的推荐设置同步到 Sonarr/Radarr 实例。<br>A command-line application that will automatically synchronize recommended settings from the TRaSH guides to your Sonarr/Radarr instances.|
|[Rider](https://www.jetbrains.com/rider/)|✔️||由 JetBrains 开发的适用于 .NET 的跨平台集成开发环境。<br>Cross-Platform IDE for .NET by JetBrains.|
|[Rime](https://rime.im/)|✔️|`Confirm`|一个跨平台的开源输入法，Windows 中叫小狼毫。<br>A cross-platform open source input method. It's called weasel on Windows.|
|[Rubick](https://github.com/rubickCenter/rubick)|✔️||基于 electron 的开源工具箱，自由集成丰富插件。<br>Electron based open source toolbox, free integration of rich plug-ins.|
|[RubyMine](https://www.jetbrains.com/rubymine/)|✔️||由 JetBrains 开发的适用于 Ruby 和 Rails 的跨平台集成开发环境。<br>Cross-Platform IDE for Ruby and Rails by JetBrains.|
|[RunCat](https://github.com/Kyome22/RunCat_for_windows)|➖||一个 windows 任务栏上的可爱的奔跑猫动画。<br>A cute running cat animation on your windows taskbar.|
|[RustDesk](https://github.com/rustdesk/rustdesk)|✔️||一个安全的远程桌面访问工具，用 Rust 语言编写。<br>An open-source remote desktop software, written in Rust.|
|[Screego](https://github.com/screego/server)|✔️||开发人员屏幕共享。<br>Screen sharing for developers.|
|[ScreenToGif](https://github.com/NickeManarin/ScreenToGif)|✔️||该工具可让您录制屏幕的选定区域、网络摄像头的实时画面或草图板上的实时绘图。之后，您可以编辑动画并将其保存为 gif、apng、视频、psd 或 png 图像。<br>This tool allows you to record a selected area of your screen, live feed from your webcam or live drawings from a sketchboard. Afterward, you can edit and save the animation as a gif, apng, video, psd or png image.|
|[Sigma-File-Manager](https://github.com/aleksey-hoffman/sigma-file-manager)|✔️||一款免费、开源、快速发展的现代文件管理器。<br>A free, open-source, quickly evolving, modern file manager (explorer / browser) app.|
|[SimpleMindMap](https://wanglin2.github.io/mind-map/#/index)|✔️||一个相对强大的Web思维导图。<br>A relatively powerful web mind map.|
|[SimplyListenMusic](https://music.codepublic.top/)|✔️||一个阿里云盘音乐播放器，它可以读取阿里云盘内的音乐来进行播放。 用户可以创建并同步歌单，播放时可以读取歌曲标签信息，还支持读取内嵌歌词/外置歌词。<br>|
|[SiYuan](https://b3log.org/siyuan/)|✔️||一款隐私优先的个人知识管理系统，支持完全离线使用，同时也支持端到端加密同步。融合块、大纲和双向链接，重构你的思维。<br>A privacy-first personal knowledge management system that supports complete offline usage, as well as end-to-end encrypted data sync. Fuse blocks, outlines, and bidirectional links to refactor your thinking.|
|[Snipaste](https://www.snipaste.com/)|✔️||一个剪切工具，可以让你把截图固定在屏幕上。<br>A snipping tool, which allows you to pin the screenshot back onto the screen. |
|[Snipaste2](https://www.snipaste.com/)|✔️||一个剪切工具，可以让你把截图固定在屏幕上。<br>A snipping tool, which allows you to pin the screenshot back onto the screen.|
|[SodaMusic](https://music.douyin.com/)|✔️||抖音官方出品音乐 App。<br>DouYin's official music App.|
|[Spacedrive](https://www.spacedrive.com)|✔️||一个开源的跨平台文件浏览器，由一个用 Rust 编写的虚拟分布式文件系统提供支持。<br>An open source cross-platform file explorer, powered by a virtual distributed filesystem written in Rust.|
|[SQLynx](https://www.sqlynx.com/)|✔️||本地基于 Web 的 SQL IDE，支持企业桌面和网络管理。它是一款跨平台数据库工具，适用于所有数据处理人员。它支持所有流行的数据库，如 MySQL、MariaDB、PostgreSQL、SQLite、Hive、Impala、Hadoop 等。<br>Native Web-Based SQL IDE, support desktop and web management for enterprise. It's a cross-platform database tool for everyone working with data. It supports all popular databases like MySQL, MariaDB, PostgreSQL, SQLite, Hive, Impala, Hadoop and more.|
|[Starship](https://starship.rs)|✔️||适用于任何 shell 的最简洁、快速且可定制的提示符。<br>The minimal, blazing fast, and extremely customizable prompt for any shell!|
|[Steampp](https://steampp.net/)|✔️||一个开源跨平台的多功能 Steam 工具箱，它有另一个名字: "Watt Toolkit"。<br>A toolbox with lots of Steam tools. Its other name is "Watt Toolkit".|
|[StrokesPlus\.net](https://www.strokesplus.net)|✔️||适用于 Windows 的鼠标手势识别实用程序，可让您创建强大的鼠标手势，从而节省您的时间。<br>Mouse gesture recognition utility for Windows which allows you to create powerful mouse gestures that save you time.|
|[SublimeText](https://www.sublimetext.com/)|✔️||一个文本编辑器。<br>A text editor.|
|[superProductivity](https://super-productivity.com)|✔️||一个先进的待办事项列表应用程序，集成了时间盒和时间跟踪功能。它还集成了 Jira、Gitlab、GitHub 和 Open Project。<br>An advanced todo list app with integrated Timeboxing and time tracking capabilities. It also comes with integrations for Jira, Gitlab, GitHub and Open Project.|
|[SwitchHosts](https://switchhosts.vercel.app)|✔️||一个管理、切换多个 hosts 方案的工具，快速切换 hosts！An App for hosts management & switching.Switch hosts quickly!|
|[SyncBackFree](https://www.2brightsparks.com/)|✔️||可免费用于个人、教育、慈善、政府和商业用途的 Windows 备份软件。<br>Windows Backup Software that is free for personal, educational, charity, government, and commercial use.|
|[Thunderbird-CN](https://www.thunderbird.net)|✔️||一款易于设置和定制的免费电子邮件应用程序。<br>A free email application that’s easy to set up and customize.|
|[Thunderbird](https://www.thunderbird.net)|✔️||一款易于设置和定制的免费电子邮件应用程序。<br>A free email application that’s easy to set up and customize.|
|[TinyRDM](https://redis.tinycraft.cc/)|✔️||一款现代轻量级跨平台 Redis 桌面管理器。<br>A modern lightweight cross-platform Redis Desktop Manager.|
|[TrafficMonitor](https://github.com/zhongyang219/TrafficMonitor)|✔️|`Confirm`|Windows 上的网络监控窗口软件。可显示当前网速/CPU/内存使用情况。支持嵌入任务栏/主题更改/流量统计。<br>Network monitoring floating window software on Windows. It can display the current network speed, CPU and memory usage. It also supports being embedded into the taskbar, theme changing and traffic statistics.|
|[TranslucentTB](https://github.com/TranslucentTB/TranslucentTB)|✔️||一个轻量级的实用程序，使 Windows 任务栏半透明/透明。<br>A lightweight utility that makes the Windows taskbar translucent/transparent.|
|[TTime](https://github.com/InkTimeRecord/TTime)|✔️||一款简洁、高效、高颜值的输入、截图、划词翻译软件。<br>A concise, efficient, and high-quality input, screenshot, and word translation software.|
|[tts-vue](https://github.com/LokerL/tts-vue)|✔️||🎤 微软语音合成工具，使用 Electron + Vue + ElementPlus + Vite 构建。<br>🎤 Microsoft speech synthesis tool, built using Electron + Vue + ElementPlus + Vite.|
|[Typora](https://typora.io)|✔️||一个 Markdown 编辑器和阅读器，所见即所得。<br>A minimal Markdown editor and reader.|
|[TyporaFree](https://typora.io)|✔️||(Beta Free 版本) 一个 Markdown 编辑器和阅读器，所见即所得。<br>(Beta Free Version) A minimal Markdown editor and reader.|
|[uncle-novel](https://uncle-novel.github.io/uncle-novel-official-site/)|✔️||一个全网小说下载器及阅读器，目录解析与书源结合，支持有声小说与文本小说，可下载 mobi、epub、txt 格式文本小说。<br>|
|[Uninstalr](https://uninstalr.com/)|➖||一个用于在 Windows 中快速、轻便、准确地卸载软件的应用程序。<br>A fast, lightweight and accurate way to uninstall software in Windows.|
|[Upscayl](https://github.com/upscayl/upscayl)|✔️||适用于 Linux、MacOS 和 Windows 的免费开源 AI 图像升级程序，秉承 Linux 优先的理念。<br>Free and Open Source AI Image Upscaler for Linux, MacOS and Windows built with Linux-First philosophy.|
|[uTools](https://u.tools)|✔️||新一代效率工具平台，自由组合插件应用，打造专属你的趁手工具集。<br>|
|[version-manager](https://github.com/gvcgo/version-manager)|✔️||支持各种语言，无需插件，无需记忆命令，最好用的SDK版本管理器。<br>A general version manager for 60+ SDKs with TUI inspired by lazygit. No need to remember any commands.|
|[VLC](https://www.videolan.org/vlc)|✔️||一款自由、开源的跨平台多媒体播放器及框架，可播放大多数多媒体文件，以及 DVD、音频 CD、VCD 及各类流媒体协议。<br>A free and open source cross-platform multimedia player and framework that plays most multimedia files as well as DVDs, Audio CDs, VCDs, and various streaming protocols.|
|[VovStickyNotes](https://vovsoft.com/software/vov-sticky-notes/)|✔️||创建数字贴纸和提醒事项。<br>Creates digital stickers and reminders|
|[VSCode](https://code.visualstudio.com/)|✔️||一个轻量级、功能强大，插件生态丰富的文件编辑器。<br>Lightweight but powerful source code editor.|
|[WasmEdge](https://wasmedge.org/)|➖||一款轻量级、高性能和可扩展的 WebAssembly 运行时，适用于云原生、边缘和去中心化应用。它为无服务器应用程序、嵌入式功能、微服务、智能合约和物联网设备提供支持。<br>A lightweight, high-performance, and extensible WebAssembly runtime for cloud native, edge, and decentralized applications. It powers serverless apps, embedded functions, microservices, smart contracts, and IoT devices.|
|[WebStorm](https://www.jetbrains.com/webstorm/)|✔️||由 JetBrains 开发的 JavaScript 和 TypeScript 的跨平台集成开发环境。<br>Cross-Platform IDE for JavaScript and TypeScript by JetBrains.|
|[WeChat](https://pc.weixin.qq.com/)|✔️||一款跨平台的通讯工具。支持单人、多人参与。通过手机网络发送语音、图片、视频和文字。<br>A free messaging and calling app.  Enjoy group chats that support voice and video calls, photos, videos, and stickers.|
|[WeekToDo](https://weektodo.me/)|✔️||一个免费和开源的极简每周计划和待办事项应用程序，专注于隐私。<br>A free and open source minimalist weekly planner and To Do list App focused on privacy.|
|[Widgets](https://github.com/widget-js/widgets)|✔️||功能强大、符合人体工程学的 Windows 桌面组件系统，使用 Vue 构建。<br>Desktop widgets for windows. built with vue3.|
|[WinRAR-CN](https://rarlab.com/)|✔️||一款功能强大的存档器（RAR 和 ZIP）和解压工具，可打开所有流行的文件格式。<br>A powerful archiver (RAR and ZIP) and extractor tool that can open all popular file formats.|
|[WinRAR](https://rarlab.com/)|✔️||一款功能强大的存档器（RAR 和 ZIP）和解压工具，可打开所有流行的文件格式。<br>A powerful archiver (RAR and ZIP) and extractor tool that can open all popular file formats.|
|[WiseCare365](https://www.wisecleaner.com/wise-care-365.html)|✔️|`Confirm`|Windows 系统清理和加速工具。<br>Free Windows PC Cleaner and Speed up Tool|
|[WonderPen](https://www.tominlab.com/wonderpen)|✔️||一款专业的写作软件，致力于为作者提供专注且流畅的写作体验。<br>A professional writing software dedicated to providing writers with a focused and smooth writing experience.|
|[Writeathon](https://www.writeathon.cn/)|✔️||一款写作产品，为创作者提供丰富的灵感和完善的流程。<br>A product for writing, providing the flow and inspiration creators need to make content.|
|[XBYDriver](https://github.com/gaozhangmin/aliyunpan)|✔️||小白羊网盘 - Powered by 阿里云盘|
|[XYplorer](https://www.xyplorer.com/index.php)|✔️||一个 Windows 上的第三方文件管理器。<br>A file manager for Windows.|
|[XYplorerFree](https://www.xyplorer.com/free.php)|✔️|`NoAutoUpdate`|(Free 版本) 一个 Windows 上的第三方文件管理器。<br>(Free version) A file manager for Windows.|
|[YouDaoTranslate](https://fanyi.youdao.com/download-Windows)|✔️|`Confirm`|网易有道翻译。<br>YouDaoTranslate for windows.|
|[YuQue](https://www.yuque.com/)|✔️||为每一个人，为每一个团队，提供优秀的文档与知识库工具。<br>Provide excellent documentation and knowledge base tools for everyone and every team.|
|[Z-Library](https://z-library.se/)|✔️||Z-Library——世界上最大的电子书图书馆。<br>Z-Library – the world’s largest e-book library.|
|[Zotero](https://www.zotero.org/)|✔️||Open-source reference management software to manage bibliographic data and related research materials.|
