-- Idempotent reseed of the shared demo household. Safe to re-run to reset the demo.
-- UUIDs MUST match Homey/Core/Supabase/SupabaseConfig.swift (DemoConfig).

delete from households where id = '11111111-1111-1111-1111-111111111111';

insert into households (id, name) values
  ('11111111-1111-1111-1111-111111111111', 'Ana''s Family House');

insert into members (id, household_id, name, emoji, role) values
  ('22222222-2222-2222-2222-222222222222', '11111111-1111-1111-1111-111111111111', 'Mom', '👩', 'admin'),
  ('33333333-3333-3333-3333-333333333333', '11111111-1111-1111-1111-111111111111', 'Dad', '👨', 'member'),
  ('44444444-4444-4444-4444-444444444444', '11111111-1111-1111-1111-111111111111', 'Ana', '👧', 'member'),
  ('55555555-5555-5555-5555-555555555555', '11111111-1111-1111-1111-111111111111', 'Ama', '🧒', 'member');

insert into chores (id, household_id, title, notes, assignee_id, due_date, status) values
  ('a0000001-0000-0000-0000-000000000001', '11111111-1111-1111-1111-111111111111', 'Clean bathroom', 'Don''t forget the bedsheets.', null,
     date_trunc('day', now()) + interval '17 hours', 'available'),
  ('a0000002-0000-0000-0000-000000000002', '11111111-1111-1111-1111-111111111111', 'Wash dishes', '', '44444444-4444-4444-4444-444444444444',
     date_trunc('day', now()) + interval '20 hours', 'in_progress'),
  ('a0000003-0000-0000-0000-000000000003', '11111111-1111-1111-1111-111111111111', 'Mop the floor', '', '33333333-3333-3333-3333-333333333333',
     date_trunc('day', now()) - interval '1 day' + interval '21 hours', 'done'),
  ('a0000004-0000-0000-0000-000000000004', '11111111-1111-1111-1111-111111111111', 'Vacuum living room', '', '55555555-5555-5555-5555-555555555555',
     date_trunc('day', now()) - interval '1 day' + interval '14 hours', 'available'),
  ('a0000005-0000-0000-0000-000000000005', '11111111-1111-1111-1111-111111111111', 'Take out trash', '', null,
     date_trunc('day', now()) + interval '1 day' + interval '9 hours', 'available'),
  ('a0000006-0000-0000-0000-000000000006', '11111111-1111-1111-1111-111111111111', 'Water the plants', '', '22222222-2222-2222-2222-222222222222',
     date_trunc('day', now()) + interval '1 day' + interval '8 hours', 'available'),
  ('a0000007-0000-0000-0000-000000000007', '11111111-1111-1111-1111-111111111111', 'Grocery shopping', '', '22222222-2222-2222-2222-222222222222',
     date_trunc('day', now()) + interval '2 days' + interval '11 hours', 'available');

insert into chore_completions (id, chore_id, completed_by, completed_at) values
  ('c0000001-0000-0000-0000-000000000001', 'a0000003-0000-0000-0000-000000000003', '33333333-3333-3333-3333-333333333333',
     date_trunc('day', now()) - interval '1 day' + interval '20 hours');
