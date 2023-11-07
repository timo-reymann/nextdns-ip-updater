package main

import (
	"io"
	"io/ioutil"
	"net/http"
	"os"
	"strings"
	"time"
)

func main() {
	nextdnsId := os.Getenv("NEXTDNS_ACCOUNT_ID")
	if nextdnsId == "" {
		println("ERR: NEXTDNS_ACCOUNT_ID is missing")
		os.Exit(2)
	}

	configIds := strings.Split(os.Getenv("NEXTDNS_CONFIG_ID"), ",")
	if len(configIds) == 0 {
		println("ERR: NEXTDNS_CONFIG_ID should at least contain one id")
		os.Exit(2)
	}

	for {
		for _, configId := range configIds {
			updateForConfig(configId, nextdnsId)
		}
		time.Sleep(15 * time.Minute)
	}
}

func updateForConfig(configId string, nextdnsId string) {
	print("Updating " + configId + " ... ")
	url := "https://link-ip.nextdns.io/" + configId + "/" + nextdnsId
	res, err := http.Get(url)
	defer func(Body io.ReadCloser) {
		_ = Body.Close()
	}(res.Body)

	if err != nil {
		print(" => ERR: " + err.Error())
		return
	}

	body, err := ioutil.ReadAll(res.Body)
	if err == nil {
		print(" => " + string(body))
	} else {
		print(" => ERR: " + err.Error())
	}

	println("")
}
