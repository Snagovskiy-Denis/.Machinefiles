package main

import (
	"testing"
)

func TestGetFeedByArticleUrl(t *testing.T) {
	db, shutdown := fixtureNewsboatDb(t)
	defer shutdown()

	cases := []struct {
		in   string
		want Article
	}{
		{
			"https://github.com/eradman/entr/releases/tag/5.6",
			Article{"https://github.com/eradman/entr/releases.atom", "https://github.com/eradman/entr/releases/tag/5.6"},
		},
		{
			"https://github.com/eradman/entr/releases/tag/3.3",
			Article{"https://github.com/eradman/entr/releases.atom", "https://github.com/eradman/entr/releases/tag/3.3"},
		},
		{
			"https://go.dev/blog/go1.22",
			Article{"https://go.dev/blog/feed.atom", "https://go.dev/blog/go1.22"},
		},
	}

	for _, tc := range cases {
		item, err := GetFeedByArticleUrl(db, tc.in)
		if err != nil || item != tc.want {
			t.Errorf("GetFeedByArticleUrl\nexpected: %v, %v\n actual: %v %v", tc.want, nil, item, err)
		}
	}
}

func TestGetFeedByArticleUrlThatDoesNotExist(t *testing.T) {
	db, shutdown := fixtureNewsboatDb(t)
	defer shutdown()

	_, err := GetFeedByArticleUrl(db, "https://go.dev/non/existing/path")
	if err == nil {
		t.Errorf("Excpects error, but got %v", err)
	}
}

func TestGetExistingArticleScore(t *testing.T) {
    dbs, shutdown := fixtureDbs(t)
    defer shutdown()

	article := fixtureRssItemsNewsboats[0]
    itemZ, err := GetArticleScore(dbs.zettl, article.articleUrl)
    if err != nil || itemZ.articleUrl != article.articleUrl {
        t.Errorf("GetArticleScore\nexpected: %v, %v\n actual: %v %v", article, nil, itemZ, err)
    }
}

func TestGetNonExistingArticleScore(t *testing.T) {
    dbs, shutdown := fixtureDbs(t)
    defer shutdown()

    _, err := GetArticleScore(dbs.zettl, "https://go.dev/non/existing/path")
    if err == nil {
        t.Errorf("Excpects error, but got %v", err)
    }
}
