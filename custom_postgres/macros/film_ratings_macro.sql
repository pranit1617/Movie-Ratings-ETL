{% macro generate_film_ratings() %}
with films_with_ratings as (
    select
        film_id
        , title
        , release_date
        , price
        , rating
        , user_rating
        {{ classify_ratings('user_rating') }} AS rating_category
    from {{ ref('films')}}
)
, films_with_actor as (
    select
        f.film_id
        , f.title
        , string_agg(a.actor_name,',') as actors
    from {{ ref('films')}} f 
    left join {{ ref('film_actors')}} fa on f.film_id = fa.film_id 
    left join {{ ref('actors')}} a on fa.actor_id = a.actor_id 
    group by 1,2
)
, result as (
    select
        fwr.* 
        , fwa.actors
    from films_with_ratings fwr
    left join films_with_actor fwa on fwa.film_id = fwr.film_id
)
select * from result
{%endmacro%}