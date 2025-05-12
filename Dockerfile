FROM golang:1.24 AS builder

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download && go mod verify

COPY . .

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o parcel-tracker

FROM alpine:latest

RUN apk add --no-cache sqlite

WORKDIR /app
COPY --from=builder /app/parcel-tracker .
COPY tracker.db .

EXPOSE 8080

CMD ["./parcel-tracker"]
