package main

import (
	"log"
	"os"

	db "github.com/rahulmadduluri/SmartWord/backend/app/db"
	server "github.com/rahulmadduluri/SmartWord/backend/app/server"

	"github.com/99designs/gqlgen/handler"
	"github.com/gorilla/mux"
	"github.com/joho/godotenv"
	"github.com/urfave/negroni"
)

const (
	_PortKey = "PORT"
)

func main() {

	// load env
	err := godotenv.Load()
	if err != nil {
		log.Print("Error loading .env file")
	}

	// config Redis & Elastic
	log.Println("Starting application")
	db.ConfigHandler()
	defer db.Handler().Close()

	// Set up Router to route to landing page & playground
	r := mux.NewRouter()

	// handle playground
	r.HandleFunc("/playground", handler.Playground("GraphQL playground", "/api"))

	// create API router
	api := mux.NewRouter()
	api.HandleFunc("/api", handler.GraphQL(
		server.NewExecutableSchema(server.New()),
	))

	// routes
	r.PathPrefix("/api").Handler(negroni.New(
		negroni.Wrap(api),
	))

	// Run Server
	port := os.Getenv(_PortKey)
	if port == "" {
		log.Fatal("Could not find PORT in env variables")
	}
	n := negroni.Classic()
	n.UseHandler(r)
	n.Run(":" + port)
}
