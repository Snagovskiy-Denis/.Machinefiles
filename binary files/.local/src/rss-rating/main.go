package main

import (
	"flag"
	"fmt"
	"log"
	"os"
	"path/filepath"
)

/*
[x] newsboat macro - алгоритм формирования аргументов этой прилы:
    - newsboat пайаит в dmenu url
    - dmenu даёт на выбор score (от -2 до +2)
    - url+score пайпятся в этот скрипт, команда передаётся как 1-ый аргумент

[x] Сетап:
    - валидация команды и аргументов
    - валидация баз данных
        - или вообще провести ATTACH DATABASE как в etl/uhabits.py

[x] Команда оценить:
1. Взять feed_url по article_url из newsboat_db
2. В 1 транзакции insert or update для этой пары feed_url, article_url

[ ] Команда сформировать рейтинг для ленты:
- за последние X статей (ORDER BY + LIMIT)
    - по умолчанию: за 2**64-2
- за период (месяц, дата начала и дата конца)
    - по умолчанию: за всё время

[x] Команда посмотреть рейтинг статьи
*/

func help(cmd *flag.FlagSet) {
	fmt.Print("Newsboat plugin that adds personal likes and dislikes to articles\n\n")
	fmt.Println("Usage: rss-rating (score | report | check | help) OPTION... [ARGUMENT]...")
	if cmd != nil {
		fmt.Println("\nOptions:")
		cmd.PrintDefaults()
	}
}

func main() {
	dbPathNewsboat := filepath.Join(os.Getenv("XDG_DATA_HOME"), "newsboat/cache.db")
	dbPathZettelkasten, ok := os.LookupEnv("ZETTELKASTEN_DB")
	if !ok {
		log.Fatal("Missing ZETTELKASTEN_DB")
	}

	dbs, err := NewDatabases(dbPathNewsboat, dbPathZettelkasten)
	if err != nil {
		log.Fatalf("Cannot connect to db: %v", err)
	}
	defer dbs.Close()

	scoreCmd := flag.NewFlagSet("score", flag.ExitOnError)
	scoreInt := scoreCmd.Int("score", -777, "negative or positive integer")
	articleUrl1 := scoreCmd.String(
		"article-url",
		"",
		"expects '%u' value from newsboat macro on article-detail page",
	)

	reportCmd := flag.NewFlagSet("report", flag.ExitOnError)
	feedUrl := reportCmd.String(
		"feed-url",
		"",
		"expects '%u' value from newsboat macro on feed-list page",
	)

	checkCmd := flag.NewFlagSet("check", flag.ExitOnError)
	articleUrl2 := checkCmd.String(
		"article-url",
		"",
		"expects '%u' value from newsboat macro on article-detail page",
	)

	helpCmd := flag.NewFlagSet("help", flag.ExitOnError)
	cmdName := helpCmd.String("cmd", "help", "subcommand name to show help to")

	if len(os.Args) < 2 {
		help(nil)
		os.Exit(1)
	}

	switch os.Args[1] {
	default:
		help(nil)
	case "help":
		helpCmd.Parse(os.Args[2:])
		cmd, _ := map[string]*flag.FlagSet{
			"report": reportCmd,
			"score":  scoreCmd,
			"check":  checkCmd,
			"help":   helpCmd,
		}[*cmdName]
		help(cmd)
	case "score":
		scoreCmd.Parse(os.Args[2:])
		if *articleUrl1 == "" {
			log.Fatal("Missing article-url option")
		}
		if *scoreInt == -777 {
			log.Fatal("Missing score option")
		}
		if err := scoreSubcommand(dbs, *articleUrl1, *scoreInt); err != nil {
			log.Fatal(err)
		}
	case "report":
		fmt.Println("WIP")
		reportCmd.Parse(os.Args[2:])
		if *feedUrl == "" {
			log.Fatal("Missing feed-url option")
		}
	case "check":
		checkCmd.Parse(os.Args[2:])
		if *articleUrl2 == "" {
			log.Fatal("Missing article-url option")
		}
		as, _ := GetArticleScore(dbs.zettl, *articleUrl2)
		fmt.Println(as.score)
	}
}
