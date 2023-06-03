# ✨ abgo_bucket ✨

[![license](https://img.shields.io/github/license/abgox/abgo_bucket)](https://github.com/ivaquero/scoopet/blob/master/LICENSE)
[![code size](https://img.shields.io/github/languages/code-size/abgox/abgo_bucket.svg)](https://img.shields.io/github/languages/code-size/abgox/abgo_bucket.svg)
[![repo size](https://img.shields.io/github/repo-size/abgox/abgo_bucket.svg)](https://img.shields.io/github/repo-size/abgox/abgo_bucket.svg)

<p align="left">
<a href="README_EN.md">English</a> |
<a href="README.md">简体中文</a>
</p>

### 正在使用 Scoop :

-   `scoop bucket add abgo_bucket https://github.com/abgox/abgo_bucket`
    > -   此处的 abgo_bucket 为添加到本地的桶名称，可随意命名
-   你应该首先安装 sudo `scoop install sudo`,因为所有应用清单中都使用到了`sudo`,不安装会报错

    -   为什么应用清单中使用`sudo` ?
        > -   一些应用难以使用 `persist` 进行持久化数据，于是采取创建软链接的方式来达到目的
        > -   创建链接需要使用到管理员权限，因此一些应用清单的安装过程中使用到了 `sudo`
        > -   卸载过程中使用`sudo`：为了卸载软件时确保不会因为权限问题而无法终止进程

-   列出 abgo_bucket 中所有可安装的应用

```powershell
    <your_scoop_path>\bucket\abgo_bucket\bin\list_all_app.ps1
```

### 没有使用过 Scoop :

-   [什么是 Scoop](https://github.com/ScoopInstaller/Scoop)
-   [安装 Scoop](https://github.com/ScoopInstaller/Install)
-   [Scoop 文档](https://github.com/ScoopInstaller/Scoop/wiki)

---

### 为什么创建此 bucket

1. 在使用官方或第三方 `bucket` 时，可能存在以下问题

    - 少数软件并没有进行`persist`
    - 软件卸载后,本地数据没有得到及时清理(如 `~/AppData/Roaming` 下的软件数据)
    - 软件卸载时，存在进程占用无法卸载问题
    - ...

2. 用于整理我的常用应用
    - 有时候经常为了几个软件而去添加一个`bucket`，导致 `scoop bucket list` 有很多 `bucket`
    - 每次安装应用触发`bucket`的更新(或手动更新 `scoop update`)的时间很长，且大量更新对我无用

---

### 应用清单

-   说明
    -   应用：以添加应用清单前后进行排序
    -   persist: 软件重要数据保存到 `Scoop` 安装目录下的 `persist` 中
    -   数据清理：当软件卸载后，删除一切此软件数据(`persist` 下的数据除外)
    -   强制卸载：当软件正在运行时，使用 `scoop uninstall <app_name>` 会先终止进程，再进行卸载，避免卸载时出现软件正在使用，无法卸载的问题

|      应用      | persist ? | 数据清理 | 强制卸载  | 备注  |
| :------------: | :-------: | :------: | :-------: | ----- |
|      7zip      |     ×     |    √     | √(\*7zip) |       |
|    listary     |  √(link)  |    √     |     √     | \*run |
|    lx-music    |  √(link)  |    √     |     √     |       |
|    snipaste    |     √     |    √     |     √     | \*run |
|   snipaste2    |     √     |    √     |     √     | \*run |
| trafficMonitor |     √     |    √     |     √     | \*run |
|      chfs      |     √     |    √     |     √     |       |
|    tts-vue     |  √(link)  |    √     |     √     |       |
|     aardio     |     √     |    √     |     √     |       |

-   \*7zip : 7zip 因为右键上下文菜单，文件管理器会占用进程，因此卸载脚本中会先终止文件管理器，之后立即重启，这会导致已经打开的文件管理页面全部关闭，如有未保存的文件管理器任务，请先保存后再进行
-   \*run : 安装后会立即运行一次
