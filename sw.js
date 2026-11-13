// SONATA service worker: the app opens even with no network after the first visit.
const C='sonata-v2',ASSETS=['./','./index.html','https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2.45.4/dist/umd/supabase.min.js','https://cdnjs.cloudflare.com/ajax/libs/qrcodejs/1.0.0/qrcode.min.js'];
self.addEventListener('install',e=>{e.waitUntil(caches.open(C).then(c=>Promise.allSettled(ASSETS.map(a=>c.add(a)))));self.skipWaiting()});
self.addEventListener('activate',e=>e.waitUntil(clients.claim()));
self.addEventListener('fetch',e=>{
  const u=new URL(e.request.url);
  if(e.request.method!=='GET'||u.hostname.endsWith('supabase.co'))return;
  e.respondWith(caches.match(e.request,{ignoreSearch:true}).then(m=>{
    const f=fetch(e.request).then(r=>{if(r.ok||r.type==='opaque')caches.open(C).then(c=>c.put(e.request,r.clone()));return r}).catch(()=>m||caches.match('./index.html'));
    return m||f;
  }));
});
