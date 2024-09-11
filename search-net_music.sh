#!/data/data/com.termux/files/usr/bin/bash

# Проверка, установлен ли mpv
if ! command -v mpv &> /dev/null
then
    echo "mpv не установлен. Установите его с помощью 'pkg install mpv'."
    exit
fi

# Проверка, установлен ли yt-dlp
if ! command -v yt-dlp &> /dev/null
then
    echo "yt-dlp не установлен. Установите его с помощью 'pip install yt-dlp'."
    exit
fi

# Путь для сохранения загруженных файлов
output_dir="/storage/emulated/0/Download"

# Проверка существования директории и создание, если она не существует
if [ ! -d "$output_dir" ]; then
    mkdir -p "$output_dir"
fi

# Функция для загрузки аудио с YouTube
download_youtube_audio() {
    read -p "Введите название песни или исполнителя: " query
    if [ -z "$query" ]; then
        echo "Название песни не может быть пустым."
        exit
    fi

    echo "Ищем и загружаем песню: $query"
    yt-dlp -o "$output_dir/%(title)s.%(ext)s" -x --audio-format mp3 --limit-rate 1M --retries 10 "ytsearch1:$query"

    # Поиск загруженного файла
    audio_file=$(find "$output_dir" -type f -name "*.mp3")

    # Проверка, найден ли аудиофайл
    if [ -z "$audio_file" ]
    then
        echo "Не удалось загрузить песню по запросу: $query"
        exit
    fi

    # Проигрывание музыки с помощью mpv
    mpv "$audio_file"
}

# Функция для загрузки аудио с MP3Party
download_mp3party_audio() {
    read -p "Введите название песни или исполнителя: " query
    if [ -z "$query" ]; then
        echo "Название песни не может быть пустым."
        exit
    fi

    echo "Ищем и загружаем песню с MP3Party: $query"
    yt-dlp -o "$output_dir/%(title)s.%(ext)s" -x --audio-format mp3 --limit-rate 1M --retries 10 "mp3party:$query"

    # Поиск загруженного файла
    audio_file=$(find "$output_dir" -type f -name "*.mp3")

    # Проверка, найден ли аудиофайл
    if [ -z "$audio_file" ]
    then
        echo "Не удалось загрузить песню по запросу: $query"
        exit
    fi

    # Проигрывание музыки с помощью mpv
    mpv "$audio_file"
}

# Главное меню
while true; do
    echo "Выберите действие:"
    echo "1. Скачать и воспроизвести аудио с YouTube"
    echo "2. Скачать и воспроизвести аудио с MP3Party"
    echo "3. Выйти"
    read -p "Введите номер действия: " choice

    case $choice in
        1)
            download_youtube_audio
            ;;
        2)
            download_mp3party_audio
            ;;
        3)
            echo "Выход..."
            exit
            ;;
        *)
            echo "Неверный выбор. Пожалуйста, выберите снова."
            ;;
    esac
done
