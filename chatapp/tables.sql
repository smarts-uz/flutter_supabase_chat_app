create table if not exists public.profiles (
    id uuid references auth.users on delete cascade not null primary key,
    username varchar(24) not null unique,
    created_at timestamp with time zone default timezone('utc' :: text, now()) not null,

    -- username should be 3 to 24 characters long containing alphabets, numbers and underscores
    constraint username_validation check (username ~* '^[A-Za-z0-9_]{3,24}$')
);
comment on table public.profiles is 'Holds all of users profile information';

create table if not exists public.messages (
    id uuid not null primary key default gen_random_uuid(),
    profile_id uuid default auth.uid() references public.profiles(id) on delete cascade not null,
    content varchar(500) not null,
    created_at timestamp with time zone default timezone('utc' :: text, now()) not null
);
comment on table public.messages is 'Holds individual messages sent on the app.';
