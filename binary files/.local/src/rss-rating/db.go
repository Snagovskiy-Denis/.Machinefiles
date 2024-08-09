package main

import (
	"database/sql"
	_ "modernc.org/sqlite"
)

type Databases struct {
	newsboat     *sql.DB
	zettl *sql.DB
}

type Article struct {
	feedUrl    string
	articleUrl string
}

type ArticleScore struct {
	feedUrl    string
	articleUrl string
	score       int
}

func NewDatabases(pathNewsboat, pathZettelkasten string) (*Databases, error) {
	var dbs Databases
	var err error
    dbs.newsboat, err = sql.Open("sqlite", pathNewsboat)
	if err != nil {
		return &dbs, err
	}
	dbs.zettl, err = sql.Open("sqlite", pathZettelkasten)
	if err != nil {
		return &dbs, err
	}
	return &dbs, nil
}

func (dbs *Databases) Close() {
    dbs.newsboat.Close()
    dbs.zettl.Close()
}

func GetFeedByArticleUrl(dbNewsboat *sql.DB, url string) (Article, error) {
	row := dbNewsboat.QueryRow(`SELECT feedurl, url FROM rss_item WHERE url = ?;`, url)
	var a Article
	if err := row.Scan(&a.feedUrl, &a.articleUrl); err != nil {
		return a, err
	}
	return a, nil
}

func GetArticleScore(dbZetl *sql.DB, articleUrl string) (ArticleScore, error) {
	row := dbZetl.QueryRow(
		`SELECT feed_url, article_url, score FROM rss_scores WHERE article_url = ?`,
		articleUrl,
	)
	var as ArticleScore
	if err := row.Scan(&as.feedUrl, &as.articleUrl, &as.score); err != nil {
		return as, err
	}
	return as, nil
}
