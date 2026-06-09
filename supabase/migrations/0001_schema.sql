-- Homey schema: households, members, chores, chore_completions.
-- RLS is intentionally permissive (anon CRUD) for the public demo — NOT production.

create extension if not exists "pgcrypto";

create table if not exists households (
  id          uuid primary key default gen_random_uuid(),
  name        text not null,
  created_at  timestamptz not null default now()
);

create table if not exists members (
  id           uuid primary key default gen_random_uuid(),
  household_id uuid not null references households(id) on delete cascade,
  name         text not null,
  emoji        text not null default '',
  role         text not null default 'member'
);

create table if not exists chores (
  id           uuid primary key default gen_random_uuid(),
  household_id uuid not null references households(id) on delete cascade,
  title        text not null,
  notes        text not null default '',
  assignee_id  uuid references members(id) on delete set null,
  due_date     timestamptz not null,
  recurrence   text not null default 'once',
  status       text not null default 'available',
  created_at   timestamptz not null default now()
);

create table if not exists chore_completions (
  id           uuid primary key default gen_random_uuid(),
  chore_id     uuid not null references chores(id) on delete cascade,
  completed_by uuid not null references members(id) on delete cascade,
  completed_at timestamptz not null,
  created_at   timestamptz not null default now()
);

create index if not exists idx_members_household on members(household_id);
create index if not exists idx_chores_household on chores(household_id);
create index if not exists idx_chores_assignee on chores(assignee_id);
create index if not exists idx_completions_chore on chore_completions(chore_id);

alter table households enable row level security;
alter table members enable row level security;
alter table chores enable row level security;
alter table chore_completions enable row level security;

drop policy if exists "demo all" on households;
drop policy if exists "demo all" on members;
drop policy if exists "demo all" on chores;
drop policy if exists "demo all" on chore_completions;

create policy "demo all" on households       for all to anon, authenticated using (true) with check (true);
create policy "demo all" on members          for all to anon, authenticated using (true) with check (true);
create policy "demo all" on chores           for all to anon, authenticated using (true) with check (true);
create policy "demo all" on chore_completions for all to anon, authenticated using (true) with check (true);
