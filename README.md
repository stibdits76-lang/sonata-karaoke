# SONATA – karaoke with phone reservations (Supabase edition)

## Setup (about 10 minutes)
1. Create a free project at supabase.com.
2. Open **SQL Editor**, paste `schema.sql`, click **Run**.
   If `pg_cron` errors, enable it under **Database > Extensions**, then run again.
3. Open **Project Settings > API**. Copy the **Project URL** and the **anon public** key.
4. In `index.html`, replace only the quoted values `YOUR_SUPABASE_URL` and `YOUR_SUPABASE_ANON_KEY` near the top of the script. Leave the other lines as they are.
5. Deploy `index.html` as a static site: drag the folder into Netlify Drop, or use Cloudflare Pages or GitHub Pages.
6. Open the site on the laptop, choose **Host a party**, and have phones scan the QR code.

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

## Karaoke video on the host screen (YouTube)
SONATA doesn't host music. With a free YouTube Data API key, the host finds an embeddable karaoke video for each song, remembers it, and plays it after the red-yellow-green lights.
1. Go to console.cloud.google.com, create a project, and enable **YouTube Data API v3**.
2. Create an **API key** and restrict it to your website address (HTTP referrers) and to the YouTube Data API.
3. Put it in `index.html`: replace `YOUR_YOUTUBE_API_KEY` near the top of the script.
Each new song search uses part of the free daily quota. Found videos are saved, so replays cost nothing.
The **👁 View** button on the host screen cycles Video, Video + lyrics, and Lyrics only. Without a key, use ✏️ to paste a YouTube link per song.
