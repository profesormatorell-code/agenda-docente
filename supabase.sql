-- Agenda docente · configuración de la base de datos en Supabase
-- Copia todo este archivo en Supabase > SQL Editor > New query y pulsa "Run".
-- Se puede ejecutar más de una vez sin problema.

-- 1) Una fila por docente con toda su agenda
create table if not exists public.agendas (
  user_id    uuid primary key references auth.users(id) on delete cascade,
  data       jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);

alter table public.agendas enable row level security;

-- Permiso de acceso por la API solo para usuarios con sesión (en proyectos nuevos no viene por defecto)
grant usage on schema public to authenticated;
grant select, insert, update on table public.agendas to authenticated;
revoke all on table public.agendas from anon;

-- Cada docente solo puede ver, crear y modificar su propia agenda
drop policy if exists "agenda: ver la propia" on public.agendas;
create policy "agenda: ver la propia" on public.agendas
  for select to authenticated using (auth.uid() = user_id);

drop policy if exists "agenda: crear la propia" on public.agendas;
create policy "agenda: crear la propia" on public.agendas
  for insert to authenticated with check (auth.uid() = user_id);

drop policy if exists "agenda: editar la propia" on public.agendas;
create policy "agenda: editar la propia" on public.agendas
  for update to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);

-- 2) Carpeta privada para los archivos (horario, planeaciones), máximo 20 MB por archivo
insert into storage.buckets (id, name, public, file_size_limit)
values ('archivos', 'archivos', false, 20971520)
on conflict (id) do update set public = false, file_size_limit = 20971520;

-- Cada docente solo usa su propia carpeta: archivos/<su id>/...
drop policy if exists "archivos: subir los propios" on storage.objects;
create policy "archivos: subir los propios" on storage.objects
  for insert to authenticated
  with check (bucket_id = 'archivos' and (storage.foldername(name))[1] = auth.uid()::text);

drop policy if exists "archivos: ver los propios" on storage.objects;
create policy "archivos: ver los propios" on storage.objects
  for select to authenticated
  using (bucket_id = 'archivos' and (storage.foldername(name))[1] = auth.uid()::text);

drop policy if exists "archivos: borrar los propios" on storage.objects;
create policy "archivos: borrar los propios" on storage.objects
  for delete to authenticated
  using (bucket_id = 'archivos' and (storage.foldername(name))[1] = auth.uid()::text);
