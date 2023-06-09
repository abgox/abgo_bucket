# ✨ abgo_bucket ✨

[![license](https://img.shields.io/github/license/abgox/abgo_bucket)](https://github.com/abgox/abgo_bucket/blob/main/LICENSE)
[![code size](https://img.shields.io/github/languages/code-size/abgox/abgo_bucket.svg)](https://img.shields.io/github/languages/code-size/abgox/abgo_bucket.svg)
[![repo size](https://img.shields.io/github/repo-size/abgox/abgo_bucket.svg)](https://img.shields.io/github/repo-size/abgox/abgo_bucket.svg)

<p align="left">
<a href="README.md">English</a> |
<a href="README-CN.md">简体中文</a>
</p>

-   [scoop-tab-completion ](https://github.com/abgox/PS-completions/tree/main/scoop-tab-completion "scoop-tab-completion")is recommended

### For ones familiar with Scoop :

-   `scoop bucket add abgo_bucket https://github.com/abgox/abgo_bucket`
-   _**You should install `sudo` first `scoop install sudo`**_.( `sudo` is used in all App Manifests)
    -   Why use `sudo` in App Manifest ?
        > -   Some APPs require administrator permissions to create a link to persist data
        > -   To ensure that the process cannot be terminated due to permission issues when uninstalling the App
-   List all installable apps

    ```powershell>
    <your_scoop_path>\bucket\abgo_bucket\bin\list_all_app.ps1
    ```

### Never used Scoop :

-   [What is Scoop](https://github.com/ScoopInstaller/Scoop)
-   [Scoop install](https://github.com/ScoopInstaller/Install)
-   [Scoop Document](https://github.com/ScoopInstaller/Scoop/wiki)

---

### App Manifests

-   Guide
    -   App：Sort before and after adding the App Manifest
    -   Persist: Important data of software is saved to `persist` under the installation directory of 'Scoop'
    -   clear data：When the software is uninstalled, delete all data of the software (except the data under 'persist').
    -   Forced uninstall：When the software is running, using the `scoop uninstall <app_name>` will terminate the process before uninstalling, to avoid the problem that the software is in use and cannot be uninstalled.

|                               App                                | Persist ? | clear data | Forced uninstall | Notes     |
| :--------------------------------------------------------------: | :-------: | :--------: | :--------------: | --------- |
|                  [7zip](https://www.7-zip.org)                   |     ×     |     √      |  √(**\*7zip**)   |           |
|                [listary](https://www.listary.com)                |  √(link)  |     √      |        √         | **\*run** |
|     [lx-music](https://github.com/lyswhut/lx-music-desktop)      |  √(link)  |     √      |        √         |           |
|               [snipaste](https://www.snipaste.com)               |     √     |     √      |        √         | **\*run** |
|              [snipaste2](https://www.snipaste.com)               |     √     |     √      |        √         | **\*run** |
| [trafficMonitor](https://github.com/zhongyang219/TrafficMonitor) |     √     |     √      |        √         | **\*run** |
|                  [chfs](http://iscute.cn/chfs)                   |     √     |     √      |        √         |           |
|           [tts-vue](https://github.com/LokerL/tts-vue)           |  √(link)  |     √      |        √         |           |
|                 [aardio](https://www.aardio.com)                 |     √     |     √      |        √         |           |
|         [Geek Uninstaller](https://geekuninstaller.com)          |     √     |     √      |        √         |           |

-   **\*run** : Run the application once after installing
-   **\*7zip** : Because 7zip has a right-click context menu, the file manager will occupy the process. In order to successfully uninstall the application, the uninstall script will terminate the file manager first, and then restart it immediately. As a result, all open file management pages will be closed
