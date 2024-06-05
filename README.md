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

-   The apps in `abgo_bucket` will uses `New-Item -ItemType SymbolicLink` to persist data, which is not limited to data in app directories.
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

## About `UAC`

-   The scripts in the `bin` directory will be elevated to administrator permission under some cases to ensure that they run properly.
-   A `UAC` authorization window will appear requiring user confirmation.
-   If you don't want to be bothered by the `UAC` authorization window, you should find ways to avoid it.
    1. Start the command line with administrator permission.
    2. Modify `User Account Control` in system Settings.
    3. ...

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
        -   `Font`: A font.
            -   Administrator permission are frequently used during the installation of fonts.
            -   Reference: [About UAC](#about-uac)
        -   `PSModule`: A PowerShell Module.
        -   `Confirm` : The app has a command line(or uninstaller) interactive confirmation when uninstalling.
        -   `NoAutoUpdate` : `json.autoupdate` are not configured, and Scoop cannot automatically detect updates.
    -   **`Description`**: App Description.

---

|App|Persist|Tag|Description|
|:-:|:-:|:-:|:-:|
