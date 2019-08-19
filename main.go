package main

import (
	"database/sql"
	"fmt"
	"net/http"

	_ "github.com/go-sql-driver/mysql"
)

func handleIndex(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "Congratulations! Your Go application has been successfully deployed on Kubernetes.")
}

func handleConnectDb(w http.ResponseWriter, r *http.Request) {
	connectionString := "tcp(127.0.0.1:3306)"

	fmt.Println("Connecting to : " + connectionString)

	db, err := sql.Open("mysql", connectionString+"/test")

	if err != nil {
		panic(err.Error())
	} else {
		fmt.Println("Connection OK !")
	}

	defer db.Close()

}

func main() {
	fmt.Println("Server starting at 3000")
	http.HandleFunc("/", handleIndex)
	http.HandleFunc("/connect", handleConnectDb)
	http.ListenAndServe(":3000", nil)
}
