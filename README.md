# SONATA – karaoke with phone reservations (Supabase edition)

## Setup (about 10 minutes)
1. Create a free project at supabase.com.
2. Open **SQL Editor**, paste `schema.sql`, click **Run**.
   If `pg_cron` errors, enable it under **Database > Extensions**, then run again.
3. Open **Project Settings > API**. Copy the **Project URL** and the **anon public** key.
4. In `index.html`, replace `YOUR_SUPABASE_URL` and `YOUR_SUPABASE_ANON_KEY` near the top of the script.
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
