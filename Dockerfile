FROM golang:latest 

WORKDIR /go/sql-example

COPY go.mod go.sum ./

RUN go mod download

COPY main.go . 

RUN go build -o main

EXPOSE 3000

ENTRYPOINT ["./main"]

