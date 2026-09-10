// Service worker CFL Facturation — network-first pour le squelette de l'app,
// avec repli sur le cache si le réseau est coupé (usage hors-ligne).
// Incrémenter CACHE_VERSION à chaque mise à jour des fichiers pour forcer le rafraîchissement.
const CACHE_VERSION = "cfl-v20";
const SHELL_FILES = [
  "./",
  "./index.html",
  "./manifest.webmanifest",
  "./icon-192.png",
  "./icon-512.png"
];

self.addEventListener("install", event => {
  event.waitUntil(
    caches.open(CACHE_VERSION).then(cache => cache.addAll(SHELL_FILES)).then(() => self.skipWaiting())
  );
});

self.addEventListener("activate", event => {
  event.waitUntil(
    caches.keys().then(keys => Promise.all(
      keys.filter(k => k !== CACHE_VERSION).map(k => caches.delete(k))
    )).then(() => self.clients.claim())
  );
});

self.addEventListener("fetch", event => {
  const req = event.request;
  if (req.method !== "GET") return;

  // Les appels vers Supabase (API/realtime) ne passent jamais par le cache.
  if (req.url.includes("supabase.co")) return;

  event.respondWith(
    fetch(req)
      .then(res => {
        const copy = res.clone();
        caches.open(CACHE_VERSION).then(cache => cache.put(req, copy));
        return res;
      })
      .catch(() => caches.match(req).then(cached => cached || caches.match("./index.html")))
  );
});

self.addEventListener("message", event => {
  if (event.data === "skipWaiting") self.skipWaiting();
});
