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

# Проверка, установлен ли curl
if ! command -v curl &> /dev/null
then
    echo "curl не установлен. Установите его с помощью 'pkg install curl'."
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

# Функция для поиска и загрузки аудио с MP3Party
download_mp3party_audio() {
    read -p "Введите название песни или исполнителя: " query
    if [ -z "$query" ]; then
        echo "Название песни не может быть пустым."
        exit
    fi

    echo "Ищем песню на MP3Party: $query"

    # Поиск песни на MP3Party
    search_url="https://mp3party.net/search?q=$(echo "$query" | sed 's/ /%20/g')"
    song_page=$(curl -s "$search_url" | grep -oP 'href="\K(/song/\d+)"' | head -n 1)

    if [ -z "$song_page" ]; then
        echo "Песня не найдена на MP3Party."
        exit
    fi

    # Полный URL для песни
    full_song_url="https://mp3party.net$song_page"
    echo "Загружаем песню с: $full_song_url"

    # Загрузка аудио с помощью yt-dlp
    yt-dlp -o "$output_dir/%(title)s.%(ext)s" -x --audio-format mp3 --limit-rate 1M --retries 10 "$full_song_url"

    # Поиск загруженного файла
    audio_file=$(find "$output_dir" -type f -name "*.mp3")

    # Проверка, найден ли аудиофайл
    if [ -z "$audio_file" ]
    then
        echo "Не удалось загрузить песню."
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
