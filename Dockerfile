FROM golang:1.24 AS builder

WORKDIR /app

COPY . .

RUN go mod tidy
RUN go build -o parcel-tracker

FROM alpine:latest

RUN apk add --no-cache sqlite-libs

WORKDIR /app

COPY --from=builder /app/parcel-tracker .
COPY tracker.db .

EXPOSE 8080

CMD ["./parcel-tracker"]
