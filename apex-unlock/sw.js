// Scoped offline cache; never intercept other projects on the same domain.
const CACHE="legend-ledger-v1.1.1", PREFIX="legend-ledger-";
const root=new URL("./",self.location.href), index=new URL("index.html",root).href;
const assets=["./","./index.html","./manifest.webmanifest","./icon-192.png","./icon-512.png"].map(x=>new URL(x,root).href);
self.addEventListener("install",e=>e.waitUntil(caches.open(CACHE).then(c=>c.addAll(assets)).then(()=>self.skipWaiting())));
self.addEventListener("activate",e=>e.waitUntil(caches.keys().then(keys=>Promise.all(keys.filter(k=>k.startsWith(PREFIX)&&k!==CACHE).map(k=>caches.delete(k)))).then(()=>self.clients.claim())));
self.addEventListener("fetch",e=>{
 const u=new URL(e.request.url);
 if(e.request.method!=="GET"||u.origin!==root.origin||!u.pathname.startsWith(root.pathname))return;
 if(e.request.mode==="navigate"){
  e.respondWith(fetch(e.request).then(async r=>{if(!r.ok)throw Error("Network unavailable");const c=await caches.open(CACHE);await c.put(index,r.clone());return r;}).catch(async()=>await caches.match(index)||Response.error()));
 }else if(assets.includes(u.href)){
  e.respondWith(caches.match(e.request).then(r=>r||fetch(e.request)));
 }
});