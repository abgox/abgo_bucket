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

-   [Scoop completion in PSCompletions ](https://github.com/abgox/PSCompletions "PSCompletions")is recommended

### For ones familiar with Scoop :

-   `scoop bucket add abgo_bucket https://github.com/abgox/abgo_bucket`

    -   The `abgo_bucket` here is the name of the bucket added locally, you can name it freely

-   List all installable apps in `abgo_bucket`

    ```powershell>
    <your_scoop_path>\bucket\abgo_bucket\bin\list_all_app.ps1
    ```

---

### Never used Scoop :

-   [What is Scoop](https://github.com/ScoopInstaller/Scoop)
-   [Scoop install](https://github.com/ScoopInstaller/Install)
-   [Scoop Document](https://github.com/ScoopInstaller/Scoop/wiki)

---

### Why create this `bucket` ?

1. When using official or third-party `buckets`, there may be the following issues.

    - Some Apps doesn't `persist` data.
        - They don't include Apps that do not necessarily `persist` data.
    - After uninstalling App, local data was not cleaned up. (e.g. the App's data under `$env:AppData`)
    - When uninstalling App, there's a problem where the process is occupied and cannot be uninstalled.
    - ...

2. Organize my commonly used apps.

---

### App Manifests

-   Guide
    -   App：Sort by first letter(0-9,a-z).
    -   Persist: Important data of software is saved to `persist` under the installation directory of 'Scoop'.
    -   clear data：When the software is uninstalled, delete data of the software (Except for `persist` data).
    -   Forced uninstall：When the software is running, using the `scoop uninstall <app_name>` will terminate the process before uninstalling, to avoid the problem that the software is in use and cannot be uninstalled.
    -   **√**：It has been done.
    -   **x**：It hasn't been done yet.
    -   **/**：It's not necessary, or the conditions are not meet.
    -   **\*run** : Run the application once after installing.
    -   **invalid**: Invalid app placed in the deprecated folder

|                               App                                | Persist | clear data | Forced uninstall | Notes       |
| :--------------------------------------------------------------: | :-----: | :--------: | :--------------: | ----------- |
|                    [7zip](https://7-zip.org)                     |    /    |     √      |        √         |             |
|                   [aardio](https://aardio.com)                   |    √    |     √      |        √         |             |
|                  [chfs](http://iscute.cn/chfs)                   |    √    |     √      |        √         |             |
|          [DownKyi](https://leiurayer.github.io/downkyi)          |    √    |     /      |        √         |             |
|               [Final2x](https://final2x.tohru.top)               |    x    |     /      |        √         |             |
|               [fnm](https://github.com/Schniz/fnm)               |    /    |     /      |        √         |             |
|      [FastGithub](https://github.com/dotnetcore/FastGithub)      |    /    |     /      |        √         | **invalid** |
|         [Geek Uninstaller](https://geekuninstaller.com)          |    √    |     √      |        √         |             |
|           [Keyviz](https://mularahul.github.io/keyviz)           |    √    |     √      |        √         |             |
|                [Listary](https://www.listary.com)                |    √    |     √      |        √         | **\*run**   |
|               [LX-Music](https://docs.lxmusic.top)               |    √    |     √      |        √         |             |
|                   [Motrix](https://motrix.app)                   |    √    |     √      |        √         |             |
|   [MusicPlayer2](https://github.com/zhongyang219/MusicPlayer2)   |    √    |     √      |        √         |             |
|                 [PixPin](https://pixpinapp.com)                  |    √    |     √      |        √         | **\*run**   |
|       [pyenv-win](https://github.com/pyenv-win/pyenv-win)        |    √    |     √      |        √         |             |
|               [Snipaste](https://www.snipaste.com)               |    √    |     √      |        √         | **\*run**   |
|              [Snipaste2](https://www.snipaste.com)               |    √    |     √      |        √         | **\*run**   |
| [TrafficMonitor](https://github.com/zhongyang219/TrafficMonitor) |    √    |     √      |        √         | **\*run**   |
|           [tts-vue](https://github.com/LokerL/tts-vue)           |    √    |     √      |        √         |             |
|      [XBYDriver](https://github.com/gaozhangmin/aliyunpan)       |    √    |     √      |        √         |             |
