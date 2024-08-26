#!/bin/sh

# 定义第一个脚本的逻辑
script1() {
    echo "修复文件系统"

    losetup /dev/loop0 /dev/mmcblk1p2
    e2fsck -y /dev/loop0
    sync
    losetup -d /dev/loop0
}

# 定义第二个脚本的逻辑
script2() {
    echo "扩容文件系统"

    parted /dev/mmcblk1 resizepart 2 100%
    losetup /dev/loop0 /dev/mmcblk1p2
    resize2fs -f /dev/loop0
    sync
    losetup -d /dev/loop0
}

# 用户选择
echo "选择操作:"
echo "1) 修复文件系统"
echo "2) 扩容文件系统"

read -p "输入数字: " choice

case $choice in
    1)
        script1
        ;;
    2)
        script2
        ;;
    *)
        echo "无效选择，请输入 1 或 2"
        exit 1
        ;;
esac

# 提示是否重启
read -p "操作完成。是否需要重启系统？(y/n): " reboot_choice

case $reboot_choice in
    [Yy]*)
        echo "系统正在重启..."
        reboot
        ;;
    [Nn]*)
        echo "系统不会重启。"
        ;;
    *)
        echo "无效选择。"
        ;;
esac


