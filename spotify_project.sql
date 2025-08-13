create or replace database snowflake_spotify_project;

create or replace table tblArtist (
    artist_id varchar,
    artist_name varchar,
    external_url varchar,
    primary key (artist_id)
);

create or replace table tblAlbum (
  album_id      VARCHAR,          
  name          VARCHAR,          
  release_date  VARCHAR,          
  total_tracks  BIGINT,           
  url           VARCHAR,          
  PRIMARY KEY (album_id)
);

create or replace table tblSongs (
  song_id       VARCHAR,
  song_name     VARCHAR,
  duration_ms   VARCHAR,
  url           VARCHAR,
  popularity    VARCHAR,
  song_added    VARCHAR,
  album_id      VARCHAR,
  artist_id     VARCHAR,
  PRIMARY KEY (song_id),
  CONSTRAINT fk_song_album
    FOREIGN KEY (album_id)
    REFERENCES tblAlbum (album_id),
  CONSTRAINT fk_song_artist
    FOREIGN KEY (artist_id)
    REFERENCES tblArtist (artist_id)
);

create or replace storage integration spotify_s3_integration 
    TYPE = EXTERNAL_STAGE
    storage_provider = 's3'
    ENABLED = true
    STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::072461053412:role/snowflake_s3_access_role'
    STORAGE_ALLOWED_LOCATIONS = ('s3://spotify-etl-project-rithujaa')

desc STORAGE INTEGRATION spotify_s3_integration;

create or replace stage spotify_raw_stage
    URL = 's3://spotify-etl-project-rithujaa/'
    STORAGE_INTEGRATION = spotify_s3_integration
    FILE_FORMAT = ( TYPE = CSV FIELD_DELIMITER = ',' SKIP_HEADER = 1 );

LIST @spotify_raw_stage;

create or replace schema pipes;


create or replace pipe pipes.artist_pipe
auto_ingest = true
as
COPY INTO SNOWFLAKE_SPOTIFY_PROJECT.PUBLIC.tblArtist
  FROM @snowflake_spotify_project.PUBLIC.spotify_raw_stage/transformed_data/artist_data/
  FILE_FORMAT = (
    TYPE = CSV
    FIELD_DELIMITER = ','
    SKIP_HEADER   = 1
    FIELD_OPTIONALLY_ENCLOSED_BY = '"'
    NULL_IF       = ('NULL','')
  )
;


create or replace pipe pipes.album_pipe
auto_ingest = true
as
COPY INTO SNOWFLAKE_SPOTIFY_PROJECT.PUBLIC.tblAlbum
  FROM @snowflake_spotify_project.PUBLIC.spotify_raw_stage/transformed_data/album_data/
  FILE_FORMAT = (
    TYPE = CSV
    FIELD_DELIMITER = ','
    SKIP_HEADER   = 1
    FIELD_OPTIONALLY_ENCLOSED_BY = '"'
    NULL_IF       = ('NULL','')
  )
;


create or replace pipe pipes.song_pipe
auto_ingest = true
as
COPY INTO SNOWFLAKE_SPOTIFY_PROJECT.PUBLIC.tblSongs
  FROM @snowflake_spotify_project.PUBLIC.spotify_raw_stage/transformed_data/songs_data/
  FILE_FORMAT = (
    TYPE = CSV
    FIELD_DELIMITER = ','
    SKIP_HEADER   = 1
    FIELD_OPTIONALLY_ENCLOSED_BY = '"'
    NULL_IF       = ('NULL','')
  )
;

desc pipe artist_pipe

select * from tblSongs

SELECT SYSTEM$PIPE_STATUS('pipes.song_pipe');
