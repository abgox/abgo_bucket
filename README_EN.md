# ✨ abgo_bucket ✨

[![license](https://img.shields.io/github/license/abgox/abgo_bucket)](https://github.com/ivaquero/scoopet/blob/master/LICENSE)
[![code size](https://img.shields.io/github/languages/code-size/abgox/abgo_bucket.svg)](https://img.shields.io/github/languages/code-size/abgox/abgo_bucket.svg)
[![repo size](https://img.shields.io/github/repo-size/abgox/abgo_bucket.svg)](https://img.shields.io/github/repo-size/abgox/abgo_bucket.svg)

<p align="left">
<a href="README_EN.md">English</a> |
<a href="README.md">简体中文</a>
</p>

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

|      App       | Persist ? | clear data | Forced uninstall | Notes |
| :------------: | :-------: | :--------: | :--------------: | ----- |
|      7zip      |     ×     |     √      |    √(\*7zip)     |       |
|    listary     |  √(link)  |     √      |        √         | \*run |
|    lx-music    |  √(link)  |     √      |        √         |       |
|    snipaste    |     √     |     √      |        √         | \*run |
|   snipaste2    |     √     |     √      |        √         | \*run |
| trafficMonitor |     √     |     √      |        √         | \*run |
|      chfs      |     √     |     √      |        √         |       |
|    tts-vue     |  √(link)  |     √      |        √         |       |
|     aardio     |     √     |     √      |        √         |       |

-   \*run : Run the application once after installing
-   \*7zip : Because 7zip has a right-click context menu, the file manager will occupy the process. In order to successfully uninstall the application, the uninstall script will terminate the file manager first, and then restart it immediately. As a result, all open file management pages will be closed
