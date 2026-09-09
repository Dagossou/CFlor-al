# Guide — CFL Facturation

## 🔄 Toi tu as déjà tout configuré (Supabase + GitHub + Vercel) — voici juste la mise à jour

Cette nouvelle version ajoute :
- Un onglet **Statistiques** avec des graphiques (chiffre d'affaires dans le temps, répartition par sexe, factures par jour de la semaine, top des prestations les plus facturées) et des cartes de synthèse.
- Un **nouveau design** plus moderne, avec des animations, ton **logo intégré en fond transparent**, une interface plus intuitive (notifications élégantes, boîtes de confirmation stylées, icônes).
- Les bibliothèques de graphiques et de connexion à la base sont maintenant **incluses directement dans les fichiers** (au lieu d'être chargées depuis Internet) — l'application démarre plus vite et reste utilisable même hors-ligne dès le premier chargement.

Le ZIP contient maintenant **8 fichiers** : `index.html`, `sw.js`, `manifest.webmanifest`, `icon-192.png`, `icon-512.png`, `logo.png`, `supabase.min.js`, `chart.min.js` (le fichier `supabase-schema.sql` n'a pas changé, pas besoin de le rejouer).

**Pour mettre à jour ton application existante :**
1. Va sur ton dépôt GitHub (celui que tu avais créé, par ex. `cfl-facturation`).
2. Pour chaque fichier du ZIP : s'il existe déjà dans le dépôt, ouvre-le, clique le crayon ✏️ (Edit), remplace tout son contenu par celui du nouveau fichier, puis **Commit changes**. S'il est nouveau (`supabase.min.js`, `chart.min.js`), utilise **Add file → Upload files** pour l'ajouter.
   - Astuce plus rapide : sur la page principale du dépôt, **Add file → Upload files**, puis glisse-dépose les 8 fichiers d'un coup — GitHub te proposera de remplacer les fichiers existants automatiquement.
3. Clique **Commit changes**. Vercel redéploie tout seul en quelques secondes (aucune action sur Vercel n'est nécessaire).
4. Rouvre l'application sur chaque tablette/téléphone déjà installé : elle se met à jour automatiquement au prochain chargement.

Comme ta connexion Supabase (URL + clé) est probablement déjà enregistrée sur chaque appareil (via l'écran Réglages), tu n'as **rien à ressaisir** — sauf si tu avais choisi de la coller directement dans `index.html` (lignes `DEFAULT_SUPA_URL` / `DEFAULT_SUPA_KEY`), auquel cas reporte ces deux valeurs dans le nouveau fichier avant de l'uploader.

Le reste de ce guide (ci-dessous) est la procédure complète de A à Z — utile si tu configures un nouveau poste ou si tu veux tout revérifier, mais tu n'as pas besoin d'y repasser pour cette mise à jour.

---

## 1. Créer la base de données (Supabase)

1. Connecte-toi sur [supabase.com](https://supabase.com) et crée un nouveau projet (choisis un mot de passe de base de données que tu notes quelque part de sûr — tu n'en auras normalement plus besoin après cette étape).
2. Une fois le projet prêt, va dans **SQL Editor** (menu de gauche) → **New query**.
3. Ouvre le fichier `supabase-schema.sql` reçu, copie tout son contenu, colle-le dans l'éditeur, puis clique **Run**. Tu dois voir "Success" — la table des factures est créée.
4. Va dans **Project Settings** (roue crantée) → **API**. Note deux valeurs :
   - **Project URL** (ressemble à `https://xxxxx.supabase.co`)
   - **anon public** (une longue clé qui commence par `eyJ...`)

   Ce sont ces deux valeurs qu'il faut coller dans l'application, soit en modifiant directement `index.html` (voir l'étape 2), soit plus tard directement dans l'écran **Réglages** de l'application — les deux fonctionnent.

## 2. (Optionnel mais recommandé) Pré-remplir la connexion dans le fichier

Pour que l'app soit déjà connectée dès la première ouverture sur chaque appareil, sans que quelqu'un ait à ressaisir les identifiants :

1. Ouvre `index.html` avec un éditeur de texte simple (Bloc-notes, ou directement l'éditeur de fichier de GitHub à l'étape suivante).
2. Cherche ces deux lignes (utilise Ctrl+F) :
   ```
   const DEFAULT_SUPA_URL = "";
   const DEFAULT_SUPA_KEY = "";
   ```
3. Colle tes valeurs entre les guillemets :
   ```
   const DEFAULT_SUPA_URL = "https://xxxxx.supabase.co";
   const DEFAULT_SUPA_KEY = "eyJhbGciOi...";
   ```
4. Enregistre le fichier.

Si tu préfères ne pas toucher au fichier, ce n'est pas grave : à la première ouverture de l'application, un écran **Réglages** s'affichera automatiquement pour te demander ces deux mêmes informations (à faire une fois par appareil).

## 3. Mettre le code en ligne (GitHub)

1. Va sur [github.com](https://github.com), connecte-toi, clique **New repository**.
2. Donne-lui un nom, par exemple `cfl-facturation`, laisse-le en **Public** ou **Private** (peu importe pour Vercel), clique **Create repository**.
3. Sur la page du dépôt vide, clique **uploading an existing file**.
4. Glisse-dépose les 8 fichiers (`index.html`, `sw.js`, `manifest.webmanifest`, `icon-192.png`, `icon-512.png`, `logo.png`, `supabase.min.js`, `chart.min.js`) — pas besoin d'uploader le fichier `.sql`, il ne sert que dans Supabase.
5. Clique **Commit changes**.

## 4. Publier l'application (Vercel)

1. Va sur [vercel.com](https://vercel.com) et connecte-toi avec ton compte GitHub.
2. Clique **Add New** → **Project**, choisis le dépôt `cfl-facturation`.
3. Laisse les réglages par défaut (aucun "framework", c'est un site statique) et clique **Deploy**.
4. Après une minute, Vercel te donne une URL du type `https://cfl-facturation.vercel.app`. C'est **l'adresse officielle de l'application** — ouvre-la pour vérifier que tout fonctionne (le catalogue de 696 prestations doit apparaître dès que tu tapes dans DESCRIPTION).

## 5. Installer l'application sur une tablette / un téléphone

1. Ouvre l'URL Vercel dans le navigateur de l'appareil (Chrome sur Android, Safari sur iPad).
2. **Android (Chrome)** : un bandeau "Installer l'application" apparaît, ou via le menu ⋮ → **Installer l'application** / **Ajouter à l'écran d'accueil**.
3. **iPad (Safari)** : bouton Partager (carré avec flèche) → **Sur l'écran d'accueil**.
4. Une icône CFL Facturation apparaît alors comme une vraie application.

Répète cette étape sur chaque appareil (tablette accueil, PC caisse, etc.) — tous partageront le même relevé de factures en temps réel puisqu'ils pointent vers la même base de données Supabase.

## 6. Mettre à jour l'application plus tard

Voir la section tout en haut de ce guide — c'est exactement cette procédure.

## Bon à savoir

- La clé **anon public** n'est pas un mot de passe : elle est faite pour être utilisée dans une application publique. Ne partage en revanche jamais la clé **service_role** ni le mot de passe de la base Supabase.
- Si une tablette perd la connexion pendant la saisie d'une facture, celle-ci reste enregistrée sur l'appareil (badge "en attente" visible dans le relevé) et se synchronise automatiquement dès que le réseau revient — aucune action supplémentaire n'est nécessaire.
- Le catalogue des 696 prestations est intégré directement dans l'application ; si les prix changent, dis-le-moi et je régénère le fichier `index.html` avec les nouveaux tarifs.
- L'onglet **Statistiques** se base sur les factures déjà enregistrées dans Supabase (et celles en attente sur l'appareil) : plus tu factures, plus les graphiques sont parlants. Les boutons 7/30/90 jours ou "Tout" changent la période analysée.
