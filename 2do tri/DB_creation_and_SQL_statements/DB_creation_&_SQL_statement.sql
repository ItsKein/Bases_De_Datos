CREATE DATABASE juan;
use juan;
CREATE TABLE users (
id int8 primary key auto_increment,
name text,
email text,
nick text,
login text,
password text,
birth date
);
SELECT * FROM GAMES;
CREATE TABLE games (
id int8 primary key auto_increment,
code text,
name text,
description text,
rules text
);
CREATE TABLE avatars (
id int8 primary key auto_increment,
user_id int8,
game_id int8,
appearance text,
level int4
);
drop table confrontations;
CREATE TABLE matches (
id int8 primary key auto_increment,
game_id int8,
name text,
password text,
created_at date,
status text,
creator_avatar_id int8
);
CREATE TABLE match_participants (
match_id int8,
avatar_id int8,
FOREIGN KEY (match_id) REFERENCES matches(id)
);
CREATE TABLE confrontations (
id int8,
match_id int8,
avatar1_id int8,
avatar2_id int8,
result text,
FOREIGN KEY (match_id) REFERENCES matches(id),
FOREIGN KEY (avatar1_id, avatar2_id) REFERENCES matches(creator_avatar_id)
);