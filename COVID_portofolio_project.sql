create schema themoviesdb; 

create table movies_metadata(
	budget int,
    genres json ,
    homepage text,
    id int,
    imdb_id text,
    original_language text,
    original_title text,
	overview text,
    popularity decimal(12.9),
    poster_path text,
    release_date date,
    revenue bigint,
    runtime int,
    spoken_languages text,
    status text,
    tagline text,
    title text,
    video bool,
    vote_average decimal(12.9),
    vote_count bigint
); 

Show variables like "local_infile";

SET GLOBAL local_infile = 1;

LOAD DATA LOCAL INFILE '/Users/poetntowncrier/Documents/sql_project/load_infile_tutorial/movies_metadata.csv'
INTO TABLE movies_metadata
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '""'
IGNORE 1 ROWS
(
	@ignore,
    @ignore,
    budget,
    @genres,
    homepage,
    id,
    imdb_id,
    original_language,
    original_title,
	overview,
    popularity,
    poster_path,
    @release_date,
    revenue,
    @runtime,
    spoken_languages,
    status,
    tagline,
    title,
    @video,
    vote_average,
    vote_count
)

SET 
	genres = REPLACE(@genres, "'", '\"'),
    video = (CASE WHEN @video = 'True' THEN 1 ELSE 0 END),
    runtime = REPLACE(@runtime, "", NULL),
    release_date = REPLACE(@release_date, "", NULL)
;