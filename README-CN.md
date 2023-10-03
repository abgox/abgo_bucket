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

### 没有使用过 Scoop :

-   [什么是 Scoop](https://github.com/ScoopInstaller/Scoop)
-   [安装 Scoop](https://github.com/ScoopInstaller/Install)
-   [Scoop 文档](https://github.com/ScoopInstaller/Scoop/wiki)

---

### 为什么创建此 `bucket` ？

1. 在使用官方或第三方 `bucket` 时，可能存在以下问题

    - 一些软件并没有进行`persist`
        - 没有必要持久化数据的软件除外
    - 软件卸载后,本地数据没有得到及时清理(如 `~/AppData/Roaming` 下的软件数据)
    - 软件卸载时，存在进程占用无法卸载问题
    - ...

2. 用于整理我的常用应用
    - 有时候为了几个软件而去添加一个`bucket`，导致 `scoop bucket list` 有很多 `bucket`
    - 每次安装应用触发`bucket`的更新(或手动更新 `scoop update`)的时间很长，且大量更新对我无用
        - 现在我知道它可以用`-u`来避免更新
        - 如: `scoop install sudo -u`

---

### 应用清单

-   说明
    -   应用：按照数字字母排序(0-9,a-z)
    -   persist: 软件重要数据保存到 `Scoop` 安装目录下的 `persist` 中
    -   数据清理：当软件卸载后，删除软件数据(`persist` 数据除外)
    -   强制卸载：当软件正在运行时，使用 `scoop uninstall <app_name>` 会先终止进程，再进行卸载，避免卸载时出现软件正在使用，无法卸载的问题
    -   **√**：已实现
    -   **x**：未实现
    -   **/**：没必要或不满足条件
    -   **\*run** : 安装后会立即运行一次

|                       应用                       | persist ? | 数据清理 | 强制卸载 | 备注      |
| :----------------------------------------------: | :-------: | :------: | :------: | --------- |
|            [7zip](/bucket/7zip.json)             |     /     |    √     |    √     |           |
|          [aardio](/bucket/aardio.json)           |     √     |    √     |    √     |           |
|            [chfs](/bucket/chfs.json)             |     √     |    √     |    √     |           |
|         [downKyi](/bucket/downkyi.json)          |     √     |    /     |    √     |           |
|      [fastGithub](/bucket/fastGithub.json)       |     /     |    /     |    √     |           |
| [Geek Uninstaller](/bucket/geekUninstaller.json) |     √     |    √     |    √     |           |
|         [listary](/bucket/listary.json)          |     √     |    √     |    √     | **\*run** |
|        [lx-music](/bucket/lx-music.json)         |     √     |    √     |    √     |           |
|       [pyenv-win](/bucket/pyenv-win.json)        |     √     |    √     |    √     |           |
|        [snipaste](/bucket/snipaste.json)         |     √     |    √     |    √     | **\*run** |
|       [snipaste2](/bucket/snipaste2.json)        |     √     |    √     |    √     | **\*run** |
|  [trafficMonitor](/bucket/trafficMonitor.json)   |     √     |    √     |    √     | **\*run** |
|         [tts-vue](/bucket/tts-vue.json)          |     √     |    √     |    √     |           |
