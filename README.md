# google-urlify

## What?
Push-button service to convert strings into URLs from the
first result of a Google Search.

## Using it
```
docker run --restart=always -p 8008:8008 -d -it samnissen/google-urlify
```

```
curl http://localhost:8008/urlify?string=%22Maximum%20Fun%22
# => {"result":"http://www.maximumfun.org/"}
```

### Or build locally
```
docker build -t google-urlify .
docker run --restart always -p 8008:8008 -d -it google-urlify
```

## Contributing

1. Fork it ( https://github.com/samnissen/google-urlify/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
