library(rvest)     

# Read links
page <- read_html("https://risalahmuslim.id/surah-al-quran/")
links <- page %>% html_nodes(".nmr-ayat > a") %>% html_attr("href")

# Choose Link
k <- sample(1:6236,1)
url <- links[k]

# Read url
risalahmuslim <- read_html(url)

# Scrap Arabic Text
arabic_text <- html_nodes(risalahmuslim, ".card.card-arab") %>% html_text()

# Scrap Transliteration Text
tl_html <- html_nodes(risalahmuslim, ".transliterasi") %>% html_text()

# Scrap Translation Text
id_html <- html_nodes(risalahmuslim, ".card-5")
id_text <- html_text(id_html)
id_text <- gsub('^.*\n=\\s*|\\s* 🔊.*$', '', id_text)
id_text <- gsub('\n',' ',id_text)

# Get Surah & Ayah Number
library(stringr)
sa <- url %>% str_match_all("[0-9,]+") %>% unlist

library(rtweet)

token_rm <- rtweet::rtweet_bot(
  api_key =    Sys.getenv("TWITTER_CONSUMER_API_KEY"),
  api_secret = Sys.getenv("TWITTER_CONSUMER_API_SECRET"),
  access_token =    Sys.getenv("TWITTER_ACCESS_TOKEN"),
  access_secret =   Sys.getenv("TWITTER_ACCESS_TOKEN_SECRET")
)

post_tweet(
  status = paste0(arabic_text,
                  "\n",
                  "\n",
                  id_text, " (", sa[1], " : ",sa[2], ")"
                 ),
  token = token_rm               
)
