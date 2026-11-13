# SONATA – karaoke with phone reservations (Supabase edition)

## How it works
- **Solo:** pick a song and sing. Favorites, Recent and Top lists are available.
- **Group:** the laptop is the stage. Phones join with a 4-letter code or QR, reserve songs while someone sings, and send reactions.
- **Clean slate:** a session idle for 1 hour is deleted with its queue and history (pg_cron every 10 min, plus a check when the app opens).
  The host screen then starts a new session on its own.

## Notes
- The songbook lives in the `SONGS` list in `index.html`. Edit it to add songs.
- Karaoke videos open through a YouTube search link. SONATA does not host media.
- Free Supabase projects pause after 7 days idle. Resume yours from the dashboard before a party.
- The anon key is public by design. Policies here are open for party use. Don't store private data.

## Offline and song cache
- The songbook is saved on each device and loads first, so it works with no signal. On startup the app refreshes it from the `songs` table.
  Press **🔄 Update songs** to refresh by hand. Add or edit songs in Supabase under Table Editor > `songs` (id, title, artist, cat, sec).
- `sw.js` lets the app open offline after the first visit. Keep it in the same folder as `index.html` when deploying.
- If the connection drops, the host keeps singing, scoring and advancing the queue locally, then syncs when the signal returns.
  Phones need a connection to reserve songs.
- Start a session while you have signal. Once started, it keeps going and can be resumed offline.

## Lyrics and karaoke screen
- Only the **host** sees lyrics. During a song the host stage shows a lyrics panel that highlights and scrolls with the song. **⛶ Karaoke screen** makes it full screen (Esc exits).
- SONATA bundles lyrics only for public-domain songs (for example "Amazing Grace"). For other songs, press **✏️ Lyrics / video** and paste lyrics you have the right to use, plus an optional YouTube karaoke link that plays on the host screen.
  Lyrics are saved on the host laptop. Plain text scrolls evenly across the song. For exact timing, use lines like `[01:23.50] words`.
- Phones have **📱 Share QR**, a full-screen QR code others can scan to join.

## Commit and push (VS Code terminal)
    git init
    git add .
    git commit -m "SONATA: lyrics view, more songs, share QR"
    git branch -M main
    git remote add origin https://github.com/YOUR-USERNAME/sonata.git
    git push -u origin main
Later updates: `git add .`, `git commit -m "message"`, `git push`.

## Play vs Reserve
When nothing is playing and the queue is empty, a song's button says **▶ Play** and starts it right away. While a song is playing or others are waiting, it says **＋ Reserve**.

## Auto lyrics and online song search
- When a song is reserved or played, the host fetches its lyrics from LRCLIB (a free community lyrics database) and saves them on the laptop. Timed lyrics highlight in time. **⬇ Lyrics** downloads lyrics for the whole songbook ahead of time.
- **🌐 Online** searches the same database for any song and adds it to the songbook (tab **🌐 Added**). Phones can add songs too.
- Coverage is not complete, and lyrics belong to their rights holders. For a business or public venue, use a licensed lyrics provider.
- Press **🔄 Retry** if a song's lyrics weren't found, or paste your own with ✏️.

## Get-ready lights
Each song starts with a 6-second red, yellow, green countdown before the timer, lyrics and video begin.
