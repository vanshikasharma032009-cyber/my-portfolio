-- Vanshika Sharma Portfolio: Supabase database schema
-- Before running: replace YOUR_ADMIN_EMAIL with the email used for Supabase Auth.
-- Run this entire file in Supabase Dashboard -> SQL Editor -> New query.

begin;

create table if not exists public.portfolio_content (
  id integer primary key check (id = 1),
  content jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);

alter table public.portfolio_content enable row level security;

-- Public visitors may read the portfolio content. Only the configured admin may write it.
revoke all on table public.portfolio_content from anon, authenticated;
grant select on table public.portfolio_content to anon, authenticated;
grant insert, update on table public.portfolio_content to authenticated;

drop policy if exists "Public can read portfolio content" on public.portfolio_content;
create policy "Public can read portfolio content"
on public.portfolio_content
for select
to anon, authenticated
using (true);

drop policy if exists "Only portfolio admin can manage content" on public.portfolio_content;
create policy "Only portfolio admin can manage content"
on public.portfolio_content
for all
to authenticated
using ((auth.jwt() ->> 'email') = 'YOUR_ADMIN_EMAIL')
with check ((auth.jwt() ->> 'email') = 'YOUR_ADMIN_EMAIL');

commit;

-- After running this schema:
-- 1. In Supabase Authentication, create the admin user with the same email above.
-- 2. Put the Project URL and publishable/anon key in supabase-config.js.
-- 3. Never put a service_role/secret key in browser code.
