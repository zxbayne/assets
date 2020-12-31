#!/bin/bash

source log.sh

# 需要被备份的文件夹与文件名，默认备份/etc/systemd与/home/YOUR_NAME
# 如果需要自定义，请在 shell 环境下输入 export INCLUDE="YOUR FILE OR DIRECTORY"
# 或者把下一行取消注释
# export INCLUDE="$HOME /etc/systemd"
INCLUDE=${INCLUDE:-"$HOME /etc/systemd"}

# 目标文件夹，用来存放备份文件
# 默认保存在 /tmp/YOUR_NAME/backup文件夹下
# export DEST_DIR="/tmp/${USER}/backup}"
DEST_DIR=${DEST_DIR:-"/tmp/${USER}/backup"}

# 备份文件的文件名
# 默认为 YOUR_NAME-backup-日期.tar.gz
# export FILE_PATTERN="${USER}-backup-$(date +%Y-%m-%d).tar.gz"
FILE_PATTERN=${FILE_PATTERN:-"${USER}-backup-$(date +%Y-%m-%d).tar.gz"}


# 接收并打印 tar 指令的输出
print_result() {
    # 将参数按行打印
    echo "$@" | while read line
    do
        # 检查这个行是否是以 'tar: ' 开头
        check=$(echo "$line" | grep "^tar: ")
        if [ "$check" == "" ]; then
            # 不是 'tar: '开头，说明不是错误信息
            log ok $line
        else
            log error $line
        fi
    done 
}

main() {
    # 如果存放备份文件的文件夹不存在，就重新创建。
    if [ ! -e "${DEST_DIR}" ]; then
        mkdir -p $DEST_DIR  
    fi
    # 如果备份文件已经存在，询问是否删除。
    if [ -e "${DEST_DIR}/${FILE_PATTERN}" ]; then
        read -p "The backup file ${DEST_DIR}/${FILE_PATTERN} already exist, delete it?\
             (Y/n)" del
        
        # 判断用户输入
        if [ "${del}" == "y" ] || [ "${del}" == "Y" ]; then
            # 删除文件
            rm "${DEST_DIR}/${FILE_PATTERN}"
        else
            # 若用户拒绝删除或者输入异常字符，就取消备份
            echo "Will not backup, exiting..."
            exit 1
        fi
    fi
    
    backup_file=${DEST_DIR}/${FILE_PATTERN}
    # 执行备份，并且将执行结果存到$result中
    result=$(tar -zcvf $backup_file $INCLUDE 2>&1 )
    # 输出结果 
    print_result "$result"
}

main $@
