package main

import "testing"

func TestScoreSubcommandNewArticle(t *testing.T) {
	dbs, shutdown := fixtureDbs(t)
	defer shutdown()

	var err error
	articleUrl, scoreInt := fixtureRssItemsNewsboats[1].articleUrl, 1

	if _, err = GetArticleScore(dbs.zettl, articleUrl); err == nil {
		t.Error("Invalid test setup")
	}

	scoreSubcommand(dbs, articleUrl, scoreInt)

	item, err := GetArticleScore(dbs.zettl, articleUrl)
	if err != nil || item.articleUrl != articleUrl || item.score != scoreInt {
		t.Errorf("err %v or invalid item:\n%v\n%v %v", err, item, articleUrl, scoreInt)
	}
}

func TestScoreSubcommandExistingArticle(t *testing.T) {
	dbs, shutdown := fixtureDbs(t)
	defer shutdown()

	var (
		before ArticleScore
		after  ArticleScore
		err    error
	)
	articleUrl, scoreInt := fixtureRssItemsNewsboats[0].articleUrl, 2

	before, err = GetArticleScore(dbs.zettl, articleUrl)
	if err != nil {
		t.Error("Invalid test setup")
	}

	scoreSubcommand(dbs, articleUrl, scoreInt)

	after, err = GetArticleScore(dbs.zettl, articleUrl)
	if err != nil || after.score != scoreInt || before == after {
		t.Errorf("err %v or before and after are equal:\n%v\n%v", err, before, after)
	}
}
