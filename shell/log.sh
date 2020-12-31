#!/bin/bash

# 输出信息到控制台
log() {
    red=$(tput setaf 1)
    green=$(tput setaf 2)
    white=$(tput sgr0)
        
    # 第一个参数作为输出颜色的依据
    status=$1
    case $status in
        "error")
            color=$red
            ;;
        "ok")
            color=$green
            ;;
        *)
            color=$white
            ;;
    esac
    # 去掉第一个参数
    shift
    echo "[${color}${status}${white}] $(date +%F-%T): $@"
}

