-- *** Table definitions ***

create table if not exists public.rooms (
    id uuid not null primary key default gen_random_uuid(),
    created_at timestamp with time zone default timezone('utc' :: text, now()) not null
);
comment on table public.rooms is 'Holds chat rooms';

create table if not exists public.room_participants (
    profile_id uuid references public.profiles(id) on delete cascade not null,
    room_id uuid references public.rooms(id) on delete cascade not null,
    created_at timestamp with time zone default timezone('utc' :: text, now()) not null,
    primary key (profile_id, room_id)
);
comment on table public.room_participants is 'Relational table of users and rooms.';

alter table public.messages
add column room_id uuid references public.rooms(id) on delete cascade not null;

-- *** Add tables to the publication to enable realtime ***

alter publication supabase_realtime add table public.room_participants;

-- Creates a new room with the user and another user in it.
-- Will return the room_id of the created room
-- Will return a room_id if there were already a room with those participants
create or replace function create_new_room(other_user_id uuid) returns uuid as $$
    declare
        new_room_id uuid;
    begin
        -- Check if room with both participants already exist
        with rooms_with_profiles as (
            select room_id, array_agg(profile_id) as participants
            from room_participants
            group by room_id
        )
        select room_id
        into new_room_id
        from rooms_with_profiles
        where create_new_room.other_user_id=any(participants)
        and auth.uid()=any(participants);


        if not found then
            -- Create a new room
            insert into public.rooms default values
            returning id into new_room_id;

            -- Insert the caller user into the new room
            insert into public.room_participants (profile_id, room_id)
            values (auth.uid(), new_room_id);

            -- Insert the other_user user into the new room
            insert into public.room_participants (profile_id, room_id)
            values (other_user_id, new_room_id);
        end if;

        return new_room_id;
    end
$$ language plpgsql security definer;
