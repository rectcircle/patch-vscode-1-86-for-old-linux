# Patch VSCode 1.86+ For Old Linux

> A way to remote connect to an old Linux system using the latest (1.86) VSCode desktop.

## Usage

1. Open VSCode Remote SSH and connect to the old Linux device once. Once you see the message "Waiting for server log...", you can close the VSCode window.
2. SSH into the old Linux device and execute the patch script:

```bash
wget -O - https://raw.githubusercontent.com/rectcircle/patch-vscode-1-86-for-old-linux/master/patch.sh | sudo bash -s $(whoami)
```

3. Retry opening VSCode Remote SSH again and reconnect to the old Linux device.

## Manual downlaod and usage

> In case you experience network issues.

1. Open VSCode Remote SSH and connect to the old Linux device once. Once you see the message "Waiting for server log...", you can close the VSCode window.

2. Click [here](https://rectcircle.cn/res/patch-vscode-1-86-for-old-linux.tar.gz) or [here](https://github.com/rectcircle/patch-vscode-1-86-for-old-linux/releases/download/v0.0.1/patch-vscode-1-86-for-old-linux.tar.gz) to download patch tools.
3. SCP the `patch-vscode-1-86-for-old-linux.tar.gz` to old linux device.
4. Unpack it.

```bash
# use root exec
mkdir -p /opt/patch-vscode-1-86-for-old-linux
tar -zxvf patch-vscode-1-86-for-old-linux.tar.gz -C /opt/patch-vscode-1-86-for-old-linux
```

5. `vi patch.sh` and pates [rectcircle/patch-vscode-1-86-for-old-linux/patch.sh](rectcircle/patch-vscode-1-86-for-old-linux/blob/master/patch.sh) script.

6. Exec `bash patch.sh <username>`.

7. Retry opening VSCode Remote SSH again and reconnect to the old Linux device.
