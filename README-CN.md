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

### 关于 persist(数据持久化)

-   `abgo_bucket` 中的应用主要通过软链接的方式去实现 `persist`，好处是不局限于应用目录下的数据文件。
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
-   你可以运行命令添加 `Scoop` 配置项来禁止创建桌面快捷方式。`scoop config abgo_bucket_no_shortcut true`

## 关于 `UAC`

-   为了保证脚本正常的运行，`bin` 目录下的脚本在某些情况下会提升到管理员权限运行
-   这会出现 `UAC` 授权窗口需要用户确认
-   如果你不希望受到 `UAC` 授权窗口的干扰，你应该寻找方法去避免它出现
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
|:-:|:-:|:-:|:-:|
