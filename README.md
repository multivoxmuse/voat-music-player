# voat-music-player
### A project attempting to provide an interface to posts of voat.co/v/music.

## Purpose
 
Create a site that aggregates and makes available for streaming, posts to voats `music` subverse

## How to deploy

- Deploy the code to a linux server (Only Ubuntu 14.04 tested)
- Run `rackup voat-music.ru`
- Point an apache vhost to index.html
- ProxyPass to the rack server on 8080 (it is private by default)
- At this point you need to set up a cron job to pull the posts via the voat legacy api and save them to disk periodically
- The `load_cache_or_fetch` method will load from the cache. Otherwise, change the code to use the voat api function instead of loading from cache! 

## To do

- Use `GET api/submissioncomments?submissionId={submissionId}` to show the comment count
- Make it easier to deploy
- Use the new voat api (2016)

