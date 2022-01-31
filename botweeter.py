#!/usr/bin/env python

import tweepy
import json
from elasticsearch import Elasticsearch

# Tweeter Data
api_key = "q24LpCj7gzUROVrOYfXK0EUi1"
api_secret = "Gt58jb58mK1MXsfvYAwhaxDhnR6jntV0YvXxD9fWDk7aEX2c20"

access_token = "1466128495902351366-46lDfMyUKKN32ncdjiXVsBrGksLSyD"
access_token_secret = "UkSRTjkQOGljAuXXSCu1yMFHdOCzUJ6XJqX12dxnyZmqJ"

auth = tweepy.OAuthHandler(api_key, api_secret)
auth.set_access_token(access_token, access_token_secret)
api = tweepy.API(auth, wait_on_rate_limit=True)

hashtags = ["cyberattaque", "cybersécurité", "cyberdéfense", "FIC2022"]
keyword = "FIC_eu"

# ELK Data
es = Elasticsearch(HOST="http://localhost", PORT=9200)

def PrintDbg(tweet):
    print()
    print("metadata of tweet:")
    print("author: " + tweet.user.screen_name)
    print("date: " + str(tweet.created_at))
    print("geolocalisation: " + str(tweet.user.location))
    print("retweet count: " + str(tweet.retweet_count))
    print("like count: " + str(tweet.favorite_count))
    print("lang: " + tweet.lang)
    print("source: " + tweet.source)

# Send data to elk
def SendData(json_obj, destination, type):
    #print(json_obj)
    es.index(index=destination, doc_type=type, body=json_obj)

# Tweet only
def SearchTw( Research, howMany):
    SearchResults = tweepy.Cursor(api.search_tweets, q=Research + " -filter:retweets", tweet_mode="extended").items(howMany)
    for tweet in SearchResults:
        #PrintDbg(tweet)
        data = {}
        data["author"] = tweet.user.screen_name
        data["date"] = str(tweet.created_at)
        data["geolocalisation"] = tweet.user.location
        data["retweet_count"] = tweet.retweet_count
        data["favorite_count"] = tweet.favorite_count
        data["lang"] = tweet.lang
        data["source"] = tweet.source
        SendData(json.dumps(data), "tweet_mining", "tweet")

# Retweet only     
def SearchRTw( Research, howMany):
    SearchResults = tweepy.Cursor(api.search_tweets, q=Research + " filter:retweets", tweet_mode="extended").items(howMany)
    for tweet in SearchResults:
        #PrintDbg(tweet)
        data = {}
        data["author"] = tweet.user.screen_name
        data["date"] = str(tweet.created_at)
        data["geolocalisation"] = tweet.user.location
        data["retweet_count"] = tweet.retweet_count
        data["favorite_count"] = tweet.favorite_count
        data["lang"] = tweet.lang
        data["source"] = tweet.source
        SendData(json.dumps(data), "retweet_mining", "retweet")   

for i in hashtags:
    #looking for #
    SearchTw("%23" + i, 10)
    SearchRTw("%23" + i, 10)

    #looking for @
    SearchTw("%40" + keyword, 10)
    SearchRTw("%40" + keyword, 10)