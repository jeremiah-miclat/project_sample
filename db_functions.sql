-- =========================================
-- RPC FUNCTIONS FOR FETCHING POSTS AND COMMENTS WITH DETAILS
-- =========================================

-- Function to get all posts with author details and images
create or replace function get_posts_with_details()
returns table (
  id uuid,
  author_id uuid,
  author_name text,
  author_avatar text,
  title text,
  content text,
  images jsonb,
  created_at timestamptz,
  updated_at timestamptz
) as $$
  select 
    p.id,
    p.author_id,
    u.display_name as author_name,
    u.avatar_url as author_avatar,
    p.title,
    p.content,
    coalesce(
      jsonb_agg(
        distinct pi.url
      ) filter (where pi.url is not null),
      '[]'::jsonb
    ) as images,
    p.created_at,
    p.updated_at
  from posts_jeremiah p
  left join users_jeremiah u on p.author_id = u.id
  left join posts_image pi on p.id = pi.post_id
  group by p.id, p.author_id, u.display_name, u.avatar_url, p.title, p.content, p.created_at, p.updated_at
  order by p.created_at desc;
$$ language sql;

-- Function to get a single post with author details and images
create or replace function get_post_with_details(post_id_param uuid)
returns table (
  id uuid,
  author_id uuid,
  author_name text,
  author_avatar text,
  title text,
  content text,
  images jsonb,
  created_at timestamptz,
  updated_at timestamptz
) as $$
  select 
    p.id,
    p.author_id,
    u.display_name as author_name,
    u.avatar_url as author_avatar,
    p.title,
    p.content,
    coalesce(
      jsonb_agg(
        distinct pi.url
      ) filter (where pi.url is not null),
      '[]'::jsonb
    ) as images,
    p.created_at,
    p.updated_at
  from posts_jeremiah p
  left join users_jeremiah u on p.author_id = u.id
  left join posts_image pi on p.id = pi.post_id
  where p.id = post_id_param
  group by p.id, p.author_id, u.display_name, u.avatar_url, p.title, p.content, p.created_at, p.updated_at;
$$ language sql;

-- Function to get all comments for a post with author details and images
create or replace function get_comments_with_details(post_id_param uuid)
returns table (
  id uuid,
  post_id uuid,
  author_id uuid,
  author_name text,
  author_avatar text,
  content text,
  images jsonb,
  created_at timestamptz,
  updated_at timestamptz
) as $$
  select 
    c.id,
    c.post_id,
    c.author_id,
    u.display_name as author_name,
    u.avatar_url as author_avatar,
    c.content,
    coalesce(
      jsonb_agg(
        distinct ci.url
      ) filter (where ci.url is not null),
      '[]'::jsonb
    ) as images,
    c.created_at,
    c.updated_at
  from comments_jeremiah c
  left join users_jeremiah u on c.author_id = u.id
  left join comment_images_jeremiah ci on c.id = ci.comment_id
  where c.post_id = post_id_param
  group by c.id, c.post_id, c.author_id, u.display_name, u.avatar_url, c.content, c.created_at, c.updated_at
  order by c.created_at asc;
$$ language sql;
