FROM golang:latest 

WORKDIR /go/http-sample

COPY app-code .

COPY go.mod go.sum ./

RUN go mod download

RUN go build -o main

EXPOSE 3000

ENTRYPOINT ["./main"]

