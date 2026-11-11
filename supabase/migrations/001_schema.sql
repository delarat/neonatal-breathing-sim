-- Private research response store.
-- Apply only after the faculty-approved Supabase project has been provisioned.
create extension if not exists pgcrypto;

create schema if not exists private;
revoke all on schema private from public, anon;
grant usage on schema private to authenticated;

create table if not exists public.study_admins (
  user_id uuid primary key references auth.users(id) on delete cascade,
  created_at timestamptz not null default now(),
  added_by text
);

create table if not exists public.submissions (
  id uuid primary key default gen_random_uuid(),
  participant_id uuid not null unique,
  submitted_at timestamptz not null default now(),
  clinical_role text,
  neonatal_experience text,
  presentation_order jsonb not null,
  responses jsonb not null,
  final_questions jsonb not null default '{}'::jsonb,
  consent_given boolean not null default false,
  consent_version text not null,
  client_version text,
  is_test boolean not null default false,
  constraint submissions_eight_responses check (jsonb_typeof(responses) = 'array' and jsonb_array_length(responses) = 8),
  constraint submissions_order_array check (jsonb_typeof(presentation_order) = 'array' and jsonb_array_length(presentation_order) = 8),
  constraint submissions_final_questions_object check (jsonb_typeof(final_questions) = 'object')
);

create index if not exists submissions_submitted_at_idx on public.submissions (submitted_at desc);
create index if not exists submissions_is_test_idx on public.submissions (is_test);

alter table public.study_admins enable row level security;
alter table public.submissions enable row level security;

revoke all on public.study_admins from anon, authenticated;
revoke all on public.submissions from anon, authenticated;
grant select on public.study_admins to authenticated;
grant select on public.submissions to authenticated;

drop policy if exists "study administrators can read submissions" on public.submissions;
drop policy if exists "administrators can read own allow-list entry" on public.study_admins;
create policy "administrators can read own allow-list entry"
on public.study_admins for select to authenticated
using (user_id = (select auth.uid()));

create or replace function private.is_study_admin()
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select (select auth.uid()) is not null
    and exists (
      select 1 from public.study_admins a
      where a.user_id = (select auth.uid())
    );
$$;
revoke all on function private.is_study_admin() from public, anon;
grant execute on function private.is_study_admin() to authenticated;

create policy "study administrators can read submissions"
on public.submissions for select to authenticated
using ((select private.is_study_admin()));

-- No direct participant table writes. The server-side Edge Function inserts using
-- its server-only Supabase secret key after validating the complete eight-scenario payload.
