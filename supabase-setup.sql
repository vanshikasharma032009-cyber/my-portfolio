create table if not exists public.portfolio_content (
  id integer primary key check (id = 1),
  content jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);
alter table public.portfolio_content enable row level security;
revoke all on public.portfolio_content from anon, authenticated;
grant select, insert, update on public.portfolio_content to authenticated;
drop policy if exists "Authenticated admins can manage portfolio content" on public.portfolio_content;
create policy "Authenticated admins can manage portfolio content"
on public.portfolio_content for all to authenticated
using (auth.uid() in (select id from auth.users where email = 'REPLACE_WITH_YOUR_ADMIN_EMAIL'))
with check (auth.uid() in (select id from auth.users where email = 'REPLACE_WITH_YOUR_ADMIN_EMAIL'));