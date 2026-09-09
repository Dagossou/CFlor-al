-- À coller une seule fois dans Supabase : Éditeur SQL (SQL Editor) -> New query -> Run.
-- Crée la table des factures partagées par tous les postes.

create table if not exists public.invoices (
  id uuid primary key,
  invoice_no text,
  invoice_date date,
  patient_nom text,
  patient_prenom text,
  patient_sexe text,
  patient_age int4,
  patient_contact text,
  periode text,
  lines jsonb not null default '[]'::jsonb,
  total numeric not null default 0,
  montant_lettres text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

-- Maintient updated_at à jour automatiquement.
create or replace function public.set_updated_at()
returns trigger as $$
begin
  new.updated_at = now();
  return new;
end;
$$ language plpgsql;

drop trigger if exists trg_invoices_updated_at on public.invoices;
create trigger trg_invoices_updated_at
  before update on public.invoices
  for each row execute function public.set_updated_at();

-- Sécurité : la clé "anon" peut lire/écrire (accès unique, pas de comptes séparés
-- pour l'instant). Si un jour vous voulez des comptes avec des droits différents,
-- on remplacera ces règles par des règles basées sur auth.uid().
alter table public.invoices enable row level security;

drop policy if exists "invoices_select_all" on public.invoices;
create policy "invoices_select_all" on public.invoices for select using (true);

drop policy if exists "invoices_insert_all" on public.invoices;
create policy "invoices_insert_all" on public.invoices for insert with check (true);

drop policy if exists "invoices_update_all" on public.invoices;
create policy "invoices_update_all" on public.invoices for update using (true) with check (true);

-- Active la synchronisation en temps réel (pour que toutes les tablettes voient
-- les nouvelles factures apparaître automatiquement dans le relevé).
alter publication supabase_realtime add table public.invoices;
