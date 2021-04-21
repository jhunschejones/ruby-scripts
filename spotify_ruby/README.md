# Spotify Ruby

This is a small console app to try out the Spotify API for potential use in a future version of Album Tags.

### API Notes:

To play with the API using the `RSpotify` gem, simply set the client secret and id in ./tmp/.env and run `./bin/consle`.

```ruby
# Find albums matching name:
RSpotify::Album.search("The Question")

# Find artists matching name
RSpotify::Artist.search("Emery")

# Generate recomendations
so_cold_i_can_see_my_breath = RSpotify::Album.search("The Question").first.tracks.first
RSpotify::Recommendations.generate(limit: 20, seed_tracks: [so_cold_i_can_see_my_breath.id])

# There are tons of availibile parameters for recomendations: https://rdoc.info/github/guilhermesad/rspotify/master/RSpotify/Recommendations
```

I'm not 100% sure yet but from an initial look, the API feels fairly easy to use with the included `RSpotify` gem. It does appear to have the same issue as Counseling Book Tags in terms of hard-to-programatically-differentiate duplicate data, but the recommendations feature seems pretty powerful!

The gem documentation said only some requests require authentication, and at least based on Spotify's dashboard tracking of my credentials it appears to not send along my credentials for requests that do _not_ require authentication, which is interesting.
