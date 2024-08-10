package main

func scoreSubcommand(dbs *Databases, articleURL string, score int) error {
	article, err := GetFeedByArticleUrl(dbs.Newsboat, articleURL)
	if err != nil {
		return err
	}

	articleScore, err := GetArticleScore(dbs.Zettl, articleURL)
	if err == nil {
		_, err := dbs.Zettl.Exec(
			`UPDATE rss_scores SET score = ? WHERE feed_url = ? AND article_url = ?`,
			score, articleScore.FeedURL, articleScore.ArticleURL,
		)
		return err
	}

	_, err = dbs.Zettl.Exec(
		`INSERT INTO rss_scores (
            feed_url,
            feed_title,
            article_url,
            article_title,
            pub_date,
            score
        )
        VALUES (?, ?, ?, ?, ?, ?)`,
		article.FeedURL,
		article.FeedTitle,
		article.ArticleURL,
		article.ArticleTitle,
		article.PubDate,
		score,
	)
	return err
}

func reportSubcommand(dbs *Databases, feedURL, start, end string) float32 {
	query := `SELECT AVG(score) FROM rss_scores WHERE feed_url = ?`

	args := []interface{}{feedURL}

	if start != "" {
		query += " AND pub_date >= unixepoch(?, 'auto')"
		args = append(args, start)
	}

	if end != "" {
		query += " AND pub_date <= unixepoch(?, 'auto')"
		args = append(args, end)
	}

	query += " GROUP BY feed_url ORDER BY pub_date DESC"

	row := dbs.Zettl.QueryRow(query, args...)

	var result float32
	row.Scan(&result)
	return result
}
