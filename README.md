простой скрипт для поиска музыки и песен через yt-dlp

```markdown
# search-net_music

`search-net_music` — это скрипт для Termux, написанный на Bash, который позволяет искать и скачивать музыку из интернета. Он поддерживает два основных источника: YouTube и MP3Party.

## Требования
- **Termux**
- **mpv**: для воспроизведения аудио
- **yt-dlp**: для загрузки с YouTube и MP3Party
- **curl**: для отправки запросов на MP3Party

## Установка
1. Клонируйте репозиторий:
   ```bash
   git clone https://github.com/LinuxFlow1/search-net_music.git
   ```
2. Перейдите в директорию:
   ```bash
   cd search-net_music
   ```

## Использование
Запустите скрипт и введите название песни:
```bash
bash search-net_music.sh
```

## Особенности
- **mpv** для локального воспроизведения.
- **yt-dlp** для скачивания и конвертации в MP3.
- Для работы скрипта `search-net_music.sh` в Termux необходимо установить следующие зависимости:

1. **curl** — для отправки запросов на MP3Party:
   ```bash
   pkg install curl
   ```

2. **yt-dlp** — для скачивания музыки:
   ```bash
   pkg install yt-dlp
   ```

3. **mpv** — для локального воспроизведения аудио:
   ```bash
   pkg install mpv
   ```
