package main

import (
	"encoding/json"
	"fmt"
	"github.com/joho/godotenv"
	"net/http"
	"os"
	"runtime"
)

func main() {
	_ = godotenv.Load("local.env")

	port := os.Getenv("PORT")
	fmt.Println("Server is listening on port", port)

	http.HandleFunc("/ping", pingHandler)
	http.ListenAndServe(":"+port, nil)
}

func pingHandler(w http.ResponseWriter, r *http.Request) {
	response := map[string]interface{}{
		"message":       "pong",
		"bin":           os.Args[0],
		"Версия Golang": runtime.Version(),
		"env":           os.Environ(),
	}

	jsonResponse, err := json.Marshal(response)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	w.Write(jsonResponse)
}
