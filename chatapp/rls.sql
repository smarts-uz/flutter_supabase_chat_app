-- Returns true if the signed in user is a participant of the room
create or replace function is_room_participant(room_id uuid)
returns boolean as $$
  select exists(
    select 1
    from room_participants
    where room_id = is_room_participant.room_id and profile_id = auth.uid()
  );
$$ language sql security definer;


-- *** Row level security polities ***


alter table public.profiles enable row level security;
create policy "Public profiles are viewable by everyone."
  on public.profiles for select using (true);


alter table public.rooms enable row level security;
create policy "Users can view rooms that they have joined"
  on public.rooms for select using (is_room_participant(id));


alter table public.room_participants enable row level security;
create policy "Participants of the room can view other participants."
  on public.room_participants for select using (is_room_participant(room_id));


alter table public.messages enable row level security;
create policy "Users can view messages on rooms they are in."
  on public.messages for select using (is_room_participant(room_id));
create policy "Users can insert messages on rooms they are in."
  on public.messages for insert with check (is_room_participant(room_id) and profile_id = auth.uid());
