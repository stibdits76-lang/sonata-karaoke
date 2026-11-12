-- SONATA schema. Paste into Supabase: SQL Editor > New query > Run.
create extension if not exists pg_cron;

create table sessions(
  code text primary key,
  mode text not null check (mode in ('solo','group')),
  created_at timestamptz default now(),
  last_active timestamptz default now());
create table queue(
  id uuid primary key default gen_random_uuid(),
  code text not null references sessions on delete cascade,
  song_id int not null, singer text not null, ts timestamptz default now());
create table playing(
  code text primary key references sessions on delete cascade,
  song_id int, singer text, started_at timestamptz,
  status text, score int, ended_at timestamptz);
create table history(
  id uuid primary key default gen_random_uuid(),
  code text not null references sessions on delete cascade,
  song_id int, singer text, score int, ts timestamptz default now());

-- Clean slate: deleting a session wipes its queue, playing and history.
create or replace function cleanup_idle() returns void
language sql security definer as
$$ delete from sessions where last_active < now() - interval '1 hour'; $$;
grant execute on function cleanup_idle() to anon;
select cron.schedule('sonata-cleanup','*/10 * * * *','select cleanup_idle()');

-- Party-grade access: anyone with the app can read/write. No personal data is stored.
do $$ declare t text; begin
  foreach t in array array['sessions','queue','playing','history'] loop
    execute format('alter table %I enable row level security',t);
    execute format('create policy "open" on %I for all to anon using (true) with check (true)',t);
  end loop; end $$;

alter publication supabase_realtime add table sessions, queue, playing, history;

-- Optional editable songbook. The app merges these rows into its built-in list,
-- caches the result on the device, and re-checks on startup or via "Update songs".
-- Already ran the script above? Run just this block.
create table if not exists songs(
  id int primary key, title text not null, artist text not null,
  cat text not null check (cat in ('New','Worship','OPM','Classics')),
  sec int not null default 240);
alter table songs enable row level security;
create policy "read songs" on songs for select to anon using (true);
-- Example: insert into songs values (10014,'Your New Song','Artist','New',210);
