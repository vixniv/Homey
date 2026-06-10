-- SP-1b: recurrence support.
alter table chores add column if not exists recurrence_days smallint[] not null default '{}';

create table if not exists chore_occurrences (
  id uuid primary key default gen_random_uuid(),
  chore_id uuid not null references chores(id) on delete cascade,
  occurrence_date date not null,
  assignee_id uuid references members(id) on delete set null,
  status text not null default 'available',
  created_at timestamptz not null default now(),
  unique (chore_id, occurrence_date)
);
create index if not exists idx_occurrences_chore on chore_occurrences(chore_id);

alter table chore_occurrences enable row level security;
drop policy if exists "demo all" on chore_occurrences;
create policy "demo all" on chore_occurrences for all to anon, authenticated using (true) with check (true);

-- A recurring demo task: "Water the plants" weekly on Mon/Wed/Fri, default assignee Mom,
-- anchored 30 days ago at 08:00 so it shows on the current week strip.
delete from chores where id = 'a0000010-0000-0000-0000-000000000010';
insert into chores (id, household_id, title, notes, assignee_id, due_date, recurrence, recurrence_days, status) values
  ('a0000010-0000-0000-0000-000000000010', '11111111-1111-1111-1111-111111111111',
   'Water the plants', '', '22222222-2222-2222-2222-222222222222',
   date_trunc('day', now()) - interval '30 days' + interval '8 hours', 'weekly', '{1,3,5}', 'available');
