#!/bin/bash

# Настройки по умолчанию
WORK_TIME=40m      # Время работы
BREAK_TIME=20m     # Время перерыва
ENABLE_MUSIC=1     # Музыка включена
VOLUME=50          # Громкость по умолчанию (0-100)

# Чтение аргументов
while getopts "w:b:m:v" opt; do
    case $opt in
        w)
            if [[ "$OPTARG" =~ ^[0-9]+$ ]]; then
                WORK_TIME="${OPTARG}m"
            else
                echo "Ошибка: Время работы должно быть целым числом"
                exit 1
            fi
            ;;
        b)
            if [[ "$OPTARG" =~ ^[0-9]+$ ]]; then
                BREAK_TIME="${OPTARG}m"
            else
                echo "Ошибка: Время перерыва должно быть целым числом"
                exit 1
            fi
            ;;
        m)
            ENABLE_MUSIC=0
            ;;
        v)
            if [[ "$OPTARG" =~ ^[0-9]+$ && "$OPTARG" -ge 0 && "$OPTARG" -le 100 ]]; then
                VOLUME="$OPTARG"
            else
                echo "Ошибка: Громкость должна быть числом от 0 до 100"
                exit 1
            fi
            ;;
        *)
            echo "Использование: $0 [-w время_работы] [-b время_перерыва] [-m отключить_музыку] [-v громкость]"
            exit 1
            ;;
    esac
done

# Проверка наличия необходимых утилит
if [ "$ENABLE_MUSIC" -eq 1 ]; then
    if ! command -v mpv &>/dev/null; then
        echo "Ошибка: mpv не установлен. Установите его для воспроизведения музыки."
        exit 1
    fi
fi

if ! command -v termdown &>/dev/null; then
    echo "Ошибка: termdown не установлен. Установите его с помощью:"
    echo "pip3 install termdown"
    exit 1
fi

# Цвета для терминала
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

# Обработка прерывания Ctrl+C
trap 'echo -e "\n\n${RED}Таймер остановлен пользователем${NC}\n"; stop_lofi; exit 0' SIGINT

MPV_PID=""

# Функция остановки mpv
stop_lofi() {
    if [ -n "$MPV_PID" ]; then
        kill "$MPV_PID" 2>/dev/null || true
        MPV_PID=""
    fi
}

# Функция отправки уведомлений
send_notification() {
    local title="$1"
    local message="$2"
    
    if command -v notify-send &>/dev/null; then
        notify-send "$title" "$message"
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        osascript -e "display notification \"$message\" with title \"$title\" sound name \"Frog\""
    else
        tput bel
    fi
}

# Очистка экрана
clear_screen() {
    printf '\033[H\033[J'
}

# Основной цикл
clear_screen
echo -e "${GREEN}Pomodoro таймер запущен (${WORK_TIME} мин работы + ${BREAK_TIME} мин перерыва)${NC}"
if [ "$ENABLE_MUSIC" -eq 1 ]; then
    echo -e "Музыка включена (громкость: $VOLUME%)"
else
    echo -e "${RED}Музыка отключена${NC}"
fi
echo -e "Нажмите ${RED}Ctrl+C${NC} для остановки в любой момент\n"

while true; do
    # Фаза работы
    clear_screen
    echo -e "${GREEN}Начинается рабочая сессия (${WORK_TIME} минут)${NC}"
    
    # Запуск mpv при необходимости
    if [ "$ENABLE_MUSIC" -eq 1 ]; then
        echo "Запуск lofi-музыки..."
        mpv --volume=$VOLUME --no-video --playlist=~/.config/mpv/lofi_playlist.txt --quiet > /dev/null 2>&1 &
        MPV_PID=$!
    else
        echo "Музыка отключена"
    fi
    
    termdown "$WORK_TIME" --no-seconds
    
    # Остановка lofi
    stop_lofi
    
    # Уведомление о перерыве
    send_notification "Пора на перерыв!"
    clear_screen
    echo -e "${RED}Перерыв (${BREAK_TIME} минут)${NC}"
    sleep 3
    
    # Фаза перерыва
    termdown "$BREAK_TIME" --no-seconds
    
    # Уведомление о возврате к работе
    send_notification "Время вернуться!" "Перерыв закончился"
    clear_screen
    echo -e "${GREEN}Время вернуться к работе!${NC}"
    sleep 3
done
