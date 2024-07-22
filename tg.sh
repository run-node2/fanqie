#!/bin/bash

# 游戏和任务列表
games=("blum" "bobak" "bump" "cexp" "clydetap" "cyber" "djdog" "pocketfi" "solstone" "tomarket" "time" "drum" "yescoin" "tabi" "ice" )
tasks=("task" "guaji" "farm" "sign" "play" "level" "hangup")

# 特殊游戏列表
special_games=("cexp" "blum" "time" "yescoin" "seed" "hexa" "mtk")

# 显示游戏列表
echo "请选择游戏："
for i in "${!games[@]}"; do
    echo "$((i+1))) ${games[$i]}"
done

read -p "输入游戏编号: " game_index
game_index=$((game_index-1))
game=${games[$game_index]}

# 过滤出与选定游戏相关的任务
case $game in
    "blum")
        filtered_tasks=("play" "farm")
        ;;
    "bobak")
        filtered_tasks=("farm")
        ;;
    "bump")
        filtered_tasks=("guaji" "sign")
        ;;
    "cexp")
        filtered_tasks=("hangup" "farm" "task")
        ;;
    "time")
        filtered_tasks=("farm" "task")
        ;;
    "yescoin")
        filtered_tasks=("hangup" "task" "sign" "level")
        ;;
    "clydetap")
        filtered_tasks=("guaji" "task")
        ;;
    "cyber")
        filtered_tasks=("task" "level" "guaji")
        ;;
    "djdog")
        filtered_tasks=("task" "guaji" "level")
        ;;
    "pocketfi")
        filtered_tasks=("guaji" "sign" "task")
        ;;
    "solstone")
        filtered_tasks=("farm" "task")
        ;;
    "tomarket")
        filtered_tasks=("sign" "play" "farm" "task")
        ;;
    "drum")
        filtered_tasks=("guaji" "farm" "task")
        ;;
    "tabi")
        filtered_tasks=("sign" "task" "guaji")
        ;;
    "ice")
        filtered_tasks=("guaji" "task")
        ;;
    *)
        filtered_tasks=("${tasks[@]}")
        ;;
esac

# 显示过滤后的任务列表
echo "请选择任务："
for i in "${!filtered_tasks[@]}"; do
    echo "$((i+1))) ${filtered_tasks[$i]}"
done

read -p "输入任务编号: " task_index
task_index=$((task_index-1))
task=${filtered_tasks[$task_index]}

screen_name="${game}_${task}"

echo "选择的游戏是: $game"
echo "选择的任务是: $task"
echo "screen 会话名: $screen_name"

# 提供查询和结束 screen 的选项
echo "请选择操作："
echo "1) 创建 screen"
echo "2) 查询 screen"
echo "3) 结束 screen"

read -p "输入操作编号: " operation

if [ "$operation" -eq 1 ]; then
    # 结束同名的 screen 会话
    existing_screen=$(screen -ls | grep $screen_name)
    if [ ! -z "$existing_screen" ]; then
        echo "正在结束已有的 screen 会话: $screen_name"
        screen -S $screen_name -X quit
    fi

    # 创建新的 screen 会话并在其中执行命令
    echo "正在创建新的 screen 会话: $screen_name"
    screen -dmS $screen_name
    
    # 检查是否是特殊游戏
    if [[ " ${special_games[@]} " =~ " ${game} " ]]; then
        screen -S $screen_name -X stuff "cd \$HOME/tg && python3 tg.py\n"
    else
        screen -S $screen_name -X stuff "cd \$HOME/tg && python3 ${game}.py\n"
    fi

    echo "已创建 screen 会话: $screen_name"
    screen -r $screen_name

elif [ "$operation" -eq 2 ]; then
    screen -r $screen_name

elif [ "$operation" -eq 3 ]; then
    screen -S $screen_name -X quit
    echo "已结束 screen 会话: $screen_name"

else
    echo "无效操作"
fi
