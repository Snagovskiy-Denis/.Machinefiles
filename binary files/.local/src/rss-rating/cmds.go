package main

func scoreSubcommand(dbs *Databases, articleUrl string, score int) error {
	itemNewsboat, err := GetFeedByArticleUrl(dbs.newsboat, articleUrl)
	if err != nil {
		return err
	}

	existingScore, err := GetArticleScore(dbs.zettl, articleUrl)
	if err == nil {
		if _, err := dbs.zettl.Exec(
			`UPDATE rss_scores SET score = ? WHERE feed_url = ? AND article_url = ?`,
			score, existingScore.feedUrl, existingScore.articleUrl,
		); err != nil {
			return err
		}
		return nil
	}

	if _, err = dbs.zettl.Exec(
		`INSERT INTO rss_scores (feed_url, article_url, score) VALUES (?, ?, ?)`,
		itemNewsboat.feedUrl, itemNewsboat.articleUrl, score,
	); err != nil {
		return err
	}

	return nil
}
