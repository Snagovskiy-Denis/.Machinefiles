package main

import (
	"database/sql"
	"testing"
)

var fixtureRssItemsNewsboats = [3]Article{
	{"https://github.com/eradman/entr/releases.atom", "https://github.com/eradman/entr/releases/tag/5.6"},
	{"https://github.com/eradman/entr/releases.atom", "https://github.com/eradman/entr/releases/tag/3.3"},
	{"https://go.dev/blog/feed.atom", "https://go.dev/blog/go1.22"},
}

var fixtureRssScores = [3]ArticleScore{
	{"https://github.com/eradman/entr/releases.atom", "https://github.com/eradman/entr/releases/tag/5.6", 1},
	{"https://go.dev/blog/feed.atom", "https://go.dev/blog/go1.22", 2},
	{"https://go.dev/blog/feed.atom", "https://go.dev/blog/routing-enhancements", 2},
}

func fixtureNewsboatDb(t *testing.T) (*sql.DB, func()) {
	db, _ := sql.Open("sqlite", ":memory:")

	db.Exec(`
        CREATE TABLE rss_item (
            id INTEGER PRIMARY KEY,
            url TEXT NOT NULL,
            feedurl TEXT NOT NULL
        )
    `)

	for _, item := range fixtureRssItemsNewsboats {
		db.Exec(`INSERT INTO rss_item (url, feedurl) VALUES (?, ?)`, item.articleUrl, item.feedUrl)
	}

	return db, func() {
		db.Close()
	}
}

func fixtureZettelkastenDb(t *testing.T) (*sql.DB, func()) {
	db, _ := sql.Open("sqlite", ":memory:")

	db.Exec(`
        CREATE TABLE rss_scores (
            -- id INTEGER PRIMARY KEY AUTOINCREMENT,
            feed_url TEXT NOT NULL,
            article_url TEXT NOT NULL,
            score INTEGER NOT NULL,
            timestamp INTEGER DEFAULT (unixepoch(date('now'))),
            -- UNIQUE(feed_url, article_url)
            PRIMARY KEY (feed_url, article_url)
        )
    `)

	for _, item := range fixtureRssScores {
		db.Exec(
			`INSERT INTO rss_scores (feed_url, article_url, score) VALUES (?, ?, ?)`,
			item.feedUrl, item.articleUrl, item.score,
		)
	}

	return db, func() {
		db.Close()
	}
}

func fixtureDbs(t *testing.T) (*Databases, func()) {
	dbN, closeDbN := fixtureNewsboatDb(t)
	dbZ, closeDbZ := fixtureZettelkastenDb(t)
	dbs := &Databases{dbN, dbZ}
	return dbs, func() {
		closeDbN()
		closeDbZ()
	}
}
